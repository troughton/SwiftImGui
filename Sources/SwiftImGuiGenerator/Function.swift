//
//  File.swift
//  File
//
//  Created by Thomas Roughton on 11/09/21.
//

import Foundation

struct ImGuiFunction {
    enum FunctionType {
        case staticMethod
        case method
        case freeFunction
    }
    
    struct Argument {
        var label: String?
        var name: String
        var type: CType
        var defaultValue: String?
        var isByReferenceReturn: Bool = false
        
        init(_ argument: CImGuiArgument, function: CImGuiFunction) {
            var arg = argument
            
            // Translating the default value can mutate arg.type, so we need to do it early.
            let defaultValueStr = function.defaults[arg.name].map { arg.type.translateDefaultValue($0) }
            
            self.label = toSwiftParameterName(arg.name)
            if ["in", "repeat"].contains(arg.name) {
                self.name = "`\(arg.name)`"
                if self.label == arg.name {
                    self.label = nil
                }
            } else {
                self.name = arg.name
            }
            self.type = arg.type
            self.defaultValue = defaultValueStr
        }
    }
    
    enum ReturnType {
        case normal(CType)
        case byReference([(name: String, type: CType)])
        
        func swiftTypeName(in namespace: String?) -> String {
            switch self {
            case .normal(let type):
                return type.swiftTypeName(in: namespace)
            case .byReference(let types):
                if types.count == 1 {
                    return types.first!.type.swiftTypeName(in: namespace)
                } else {
                    return "(" + types.map {
                        "\($0.name): \($0.type.swiftTypeName(in: namespace))"
                    }.joined(separator: ", ") + ")"
                }
            }
        }
    }
    
    var type: FunctionType
    var isComputedVariable: Bool
    var name: String
    var returnType: ReturnType
    var arguments: [Argument]
    var cImGuiFunctionName: String
    var isMutating: Bool = false
    
    init?(_ function: CImGuiFunction) {
        if function.constructor ?? false || function.destructor ?? false || function.templated ?? false {
            return nil
        }
        if !(function.location?.starts(with: "imgui:") ?? false) {
            return nil // Don't translate internal-only functions.
        }
        if function.argsT.contains(where: {
            if case .variadic = $0.type {
                return true
            }
            return false
        }) {
            return nil // We can't import variadic functions.
        }
        
        self.isComputedVariable = function.isComputedVariable
        self.name = toSwiftFunctionName(function.funcname!)
        self.cImGuiFunctionName = function.ov_cimguiname
        
        var arguments = function.argsT
        if arguments.first?.name == "self" {
            let arg = arguments.removeFirst()
            self.type = .method
            if case .pointer = arg.type {
                self.isMutating = true
                self.isComputedVariable = false
            }
        } else if function.namespace != nil || function.is_static_function ?? false {
            self.type = .staticMethod
        } else {
            self.type = .freeFunction
        }
       
        self.returnType = .normal(function.ret ?? .void)
        self.arguments = arguments.map { Argument($0, function: function) }
        
        if case .void = (function.ret ?? .void) {
            var outValueArgs = [(name: String, type: CType)]()
            for (i, arg) in self.arguments.enumerated() where arg.name.contains("out") || arg.name.contains("Out") {
                guard case .pointer(let underlyingType) = arg.type else { continue }
                self.arguments[i].isByReferenceReturn = true
                outValueArgs.append((arg.name, underlyingType))
            }
            if !outValueArgs.isEmpty {
                self.returnType = .byReference(outValueArgs)
            }
        }
        
        if self.arguments.isEmpty, self.name.starts(with: "get"), !self.isMutating {
            self.name = toSwiftFunctionName(self.name.dropFirst(3))
            self.isComputedVariable = true
        }
    }
    
    func print(to reflectionPrinter: inout ReflectionPrinter, namespace: String?) {
        if case .normal(.bool) = self.returnType, !self.arguments.isEmpty {
            reflectionPrinter.print("@discardableResult")
        }
        
        var declaration = "public "
        
        if self.type == .staticMethod {
            declaration += "static "
        }
        switch self.isComputedVariable {
        case true:
            declaration += "var "
        case false:
            if self.isMutating {
                declaration += "mutating "
            }
            declaration += "func "
        }
        
        declaration += name
        
        let arguments: [ImGuiFunction.Argument]
        switch self.isComputedVariable {
        case true:
            declaration += ": "
            arguments = []
        case false:
            declaration += "("
            arguments = self.arguments.filter {
                if case .vaList = $0.type {
                    return false // We don't accept va_list parameters.
                }
                if $0.isByReferenceReturn {
                    return false // We don't pass in out-value parameters.
                }
                return true
            }
            
            for (i, arg) in arguments.enumerated() {
                if arg.label != arg.name {
                    declaration += "\(arg.label ?? "_") \(arg.name)"
                } else {
                    declaration += arg.name
                }
                if let inoutType = arg.type.underlyingInOutType {
                    if arg.type.hasDifferingSwiftType {
                        declaration += "Temp"
                    }
                    declaration += ": inout \(inoutType.swiftTypeName(in: namespace))"
                } else {
                    declaration += ": \(arg.type.swiftTypeName(in: namespace))"
                }
                if let defaultValue = arg.defaultValue {
                    declaration += " = \(defaultValue)"
                }
                if i + 1 < arguments.count {
                    declaration += ", "
                }
            }
            declaration += ") -> "
        }
        declaration += "\(self.returnType.swiftTypeName(in: namespace)) {"
        reflectionPrinter.print(declaration)
        
        for arg in arguments where arg.type.hasDifferingSwiftType && (arg.type.underlyingInOutType != nil || arg.isByReferenceReturn) {
            let underlyingType = arg.type.underlyingInOutType ?? arg.type
            reflectionPrinter.print("var \(arg.name) = \(underlyingType.constructCType("\(arg.name)Temp"))")
            reflectionPrinter.print("defer { \(arg.name)Temp = \(underlyingType.constructSwiftType(arg.name)) }")
        }
        
        let cImGuiArguments = ((self.type == .method ? ["\(self.isMutating ? "&" : "")self"] : []) +
                               self.arguments.map { arg in
            switch arg.type {
            case .pointer(to: .vector), .pointer(to: .array):
                return arg.name
            default:
                return arg.type.underlyingInOutType != nil || arg.isByReferenceReturn ? "&\(arg.name)" : arg.type.constructCType(arg.name)
            }
        }).joined(separator: ", ")
        
        var scopeCount = 0
        for arg in self.arguments {
            if case .vaList = arg.type {
                reflectionPrinter.print("return withVaList([]) { \(arg.name) in ")
                scopeCount += 1
            } else if case .pointer(to: .vector) = arg.type {
                reflectionPrinter.print("return \(arg.name).withMutableMemberPointer { \(arg.name) in ")
                scopeCount += 1
            } else if case .pointer(to: .array) = arg.type {
                reflectionPrinter.print("return withMutableMembers(of: &\(arg.name)) { \(arg.name) in")
                scopeCount += 1
            }
        }
        switch self.returnType {
        case .normal(let type):
            let swiftType = type.constructSwiftType("\(cImGuiFunctionName)(\(cImGuiArguments))")
            reflectionPrinter.print("return \(swiftType)")
        case .byReference(let tupleValues):
            for (name, type) in tupleValues {
                if case .optional = type {
                    reflectionPrinter.print("var \(name): \(type.cTypeName(in: namespace)) = nil")
                } else {
                    reflectionPrinter.print("var \(name) = \(type.cTypeName(in: namespace))()")
                }
            }
            reflectionPrinter.print("\(cImGuiFunctionName)(\(cImGuiArguments))")
            let tupleReturn = "return (" + tupleValues.map {
                return $0.type.constructSwiftType($0.name)
            }.joined(separator: ", ") + ")"
            
            reflectionPrinter.print(tupleReturn)
        }
        for _ in 0..<scopeCount {
            reflectionPrinter.print("}")
        }
        reflectionPrinter.print("}")
        reflectionPrinter.newLine()
    }
}
