//
//  File.swift
//  
//
//  Created by Thomas Roughton on 9/05/20.
//

import Foundation

final class CTypeStruct: Hashable {
    struct Member {
        var name: String
        var type: CType
        var isStatic: Bool
        var computedPropertyText: String?
        
        func text(in namespace: String?) -> String {
            var declaration = "public \(isStatic ? "static " : "")var \(name): \(type.swiftTypeName(in: namespace))"
            if let computedPropertyText = self.computedPropertyText {
                declaration += " { return \(computedPropertyText) }"
            }
            return declaration
        }
    }
    
    let name: String
    var namespace: String?
    var members: [Member] = []
    var isOptionSet: Bool = false
    
    static var namedTypes = [String: CTypeStruct]()
    
    private init(name: String) {
        self.name = name
    }
    
    static func named(_ name: String, isOptionSet: Bool = false) -> CTypeStruct {
        var originalName = name
        
        var name = name
        var namespace = nil as String?
        if isOptionSet {
            if name.starts(with: "ImGui") {
                name = String(name.dropFirst(5))
                namespace = "ImGui"
            } else if name.starts(with: "Im") {
                name = String(name.dropFirst(2))
                namespace = "ImGui"
            }
            if name.hasSuffix("_") {
                originalName = String(originalName.dropLast())
                name = String(name.dropLast())
            }
        }
        if name == "Col" {
            name = "Color"
        }
        
        if let type = CTypeStruct.namedTypes[name] {
            CTypeStruct.namedTypes[originalName] = type
            return type
        }
        let typeStruct = CTypeStruct(name: name)
        typeStruct.namespace = namespace
        typeStruct.isOptionSet = isOptionSet
        CTypeStruct.namedTypes[name] = typeStruct
        CTypeStruct.namedTypes[originalName] = typeStruct
        return typeStruct
    }
    
    public func print(to reflectionPrinter: inout ReflectionPrinter) {
        reflectionPrinter.print("public struct \(self.name)\(self.isOptionSet ? ": OptionSet " : "") {")
        
        for member in self.members where member.computedPropertyText == nil {
            reflectionPrinter.print(member.text(in: self.namespace))
        }
        
        if self.isOptionSet {
            reflectionPrinter.newLine()
            reflectionPrinter.print(
                """
                public init(rawValue: Self.RawValue) {
                    self.rawValue = rawValue
                }
                """)
            reflectionPrinter.newLine()
        }
        
        for member in self.members where member.computedPropertyText != nil {
            reflectionPrinter.print(member.text(in: self.namespace))
        }
        
        reflectionPrinter.print("}")
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    static func ==(lhs: CTypeStruct, rhs: CTypeStruct) -> Bool {
        return lhs === rhs
    }
}

indirect enum CType: Decodable {
    case void
    case bool
    case char
    case int8
    case uint8
    case int16
    case uint16
    case int32
    case uint32
    case int64
    case uint64
    case half
    case float
    case double
    case sizeT
    case variadic
    case vaList
    
    case imVec2
    case imVec4
    case vector(element: CType, length: Int)
    case packedVector(element: CType, length: Int)
    case matrix(element: CType, rows: Int, columns: Int)
    case array(element: CType, length: Int)
    case `struct`(CTypeStruct)
    case constPointer(to: CType)
    case pointer(to: CType)
    case union
    case optional(CType)
    
    case cFunctionPointer(arguments: [(name: String, type: CType)], returnType: CType)
    
    init?<S: StringProtocol>(string: S, addToDictIfMissing: Bool = true) {
        let string = string.trimmingCharacters(in: .whitespaces)
        if string == "..." {
            self = .variadic
            return
        }
        
        if string.last == "*" || string.last == "&" {
            if string.hasPrefix("const") {
                guard let type = CType(string: string.dropLast().dropFirst(5), addToDictIfMissing: addToDictIfMissing) else { return nil }
                switch type {
                case .pointer(let pointee):
                    self = .pointer(to: .optional(.constPointer(to: pointee)))
                case .constPointer:
                    self = .constPointer(to: .optional(type))
                case .struct(let structType) where structType.name.contains("Func") || structType.name.contains("Callback"):
                    self = .constPointer(to: .optional(type))
                default:
                    self = .constPointer(to: type)
                }
            } else {
                guard let type = CType(string: string.dropLast(), addToDictIfMissing: addToDictIfMissing) else { return nil }
                switch type {
                case .pointer, .constPointer:
                    self = .pointer(to: .optional(type))
                case .struct(let structType) where structType.name.contains("Func") || structType.name.contains("Callback"):
                    self = .pointer(to: .optional(type))
                default:
                    self = .pointer(to: type)
                }
            }
        } else {
            var string = string
            var isConst = false
            if string.hasPrefix("const") {
                isConst = true
                string = String(string.dropFirst(5))
            } else if string.hasSuffix("const") {
                isConst = true
                string = String(string.dropLast(5))
            }
            if isConst {
                if let type = CType(string: string, addToDictIfMissing: addToDictIfMissing) {
                    if case .pointer(let pointee) = type {
                        self = .constPointer(to: pointee)
                    } else {
                        self = type
                    }
                    return
                } else {
                    return nil
                }
            }
            
            if string.hasPrefix("union") {
                self = .union
                return
            }
            if let openSquareBracketIndex = string.firstIndex(of: "[") {
                let arrayLength = Int(string[openSquareBracketIndex..<string.endIndex].dropFirst().dropLast()) ?? 0
                if let type = CType(string: string[..<openSquareBracketIndex], addToDictIfMissing: addToDictIfMissing) {
                    self = isConst ? .constPointer(to: .array(element: type, length: arrayLength)) : .pointer(to: .array(element: type, length: arrayLength))
                    if arrayLength == 0 {
                        switch type {
                        case .pointer, .constPointer:
                            self = isConst ? .constPointer(to: .optional(type)) : .pointer(to: .optional(type))
                        default:
                            self = isConst ? .constPointer(to: type) : .pointer(to: type)
                        }
                    } else if arrayLength == 2 || arrayLength == 3 || arrayLength == 4 || arrayLength == 8 || arrayLength == 16 {
                        switch type {
                        case .float, .double, .int8, .uint8, .int16, .uint16, .int32, .uint32, .int64, .uint64:
                            self = isConst ? .constPointer(to: .vector(element: type, length: arrayLength)) : .pointer(to: .vector(element: type, length: arrayLength))
                        default:
                            break
                        }
                    }
                    return
                } else {
                    return nil
                }
            }
            
            switch string {
            case "void":
                self = .void
            case "bool":
                self = .bool
            case "float":
                self = .float
            case "double":
                self = .double
            case "char":
                self = .char
            case "unsigned char":
                self = .uint8
            case "unsigned short":
                self = .uint16
            case "unsigned int":
                self = .uint32
            case "signed char":
                self = .int8
            case "short":
                self = .int16
            case "int":
                self = .int32
            case "ImU32":
                self = .uint32
            case "uint64_t":
                self = .uint64
            case "size_t":
                self = .sizeT
            case "ImVec2":
                self = .imVec2
            case "ImVec4":
                self = .imVec4
            case "va_list":
                self = .vaList
            case "float(*)(void* data,int idx)":
                self = .cFunctionPointer(arguments: [("data", .optional(.pointer(to: .void))), ("index", .int32)], returnType: .float)
            case "bool(*)(void* data,int idx,const char** out_text)":
                self = .cFunctionPointer(arguments: [("data", .optional(.pointer(to: .void))), ("index", .int32), ("outText", .optional(.pointer(to: .optional(.constPointer(to: .char)))))], returnType: .bool)
            default:
                if let type = CTypeStruct.namedTypes[string] {
                    self = .struct(type)
                } else if addToDictIfMissing {
                    self = .struct(CTypeStruct.named(string)) // Point to a class that we'll fill in later.
                } else {
                    return nil
                }
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(string: try container.decode(String.self))!
    }
    
    func swiftTypeName(in namespace: String?) -> String {
        switch self {
        case .imVec2:
            return "SIMD2<Float>"
        case .imVec4:
            return "SIMD4<Float>"
        default:
            let name = self.cTypeName(in: namespace)
            if name.hasSuffix("Func") || name.hasSuffix("Callback") {
                return "@escaping \(name)"
            }
            return name
        }
    }
    
    func cTypeName(in namespace: String?, isTopLevel: Bool = true) -> String {
        switch self {
        case .void:
            return "Void"
        case .variadic:
            return "..."
        case .char:
            return "CChar"
        case .bool:
            return "Bool"
        case .int8:
            return "Int8"
        case .uint8:
            return "UInt8"
        case .int16:
            return "Int16"
        case .uint16:
            return "UInt16"
        case .int32:
            return "Int32"
        case .uint32:
            return "UInt32"
        case .int64:
            return "Int64"
        case .uint64:
            return "UInt64"
        case .half:
            return "Float16"
        case .float:
            return "Float"
        case .double:
            return "Double"
        case .sizeT:
            return "Int"
        case .vaList:
            return "va_list"
        case .packedVector(let element, let length):
            return "PackedVector\(length)<\(element)>"
        case .vector(.half, let length):
            return "Vector\(length)h" // FIXME: use SIMD once Float16 is a native Swift type.
        case .imVec2:
            return "ImVec2"
        case .imVec4:
            return "ImVec4"
        case .vector(let element, let length):
            return "SIMD\(length)<\(element)>"
        case .matrix(let element, 4, 3):
            return "AffineMatrix<\(element)>"
        case .matrix(let element, let rows, let columns):
            return "Matrix\(rows)x\(columns)<\(element)>"
        case .array(let element, let length):
            return "(\(repeatElement(element.cTypeName(in: namespace, isTopLevel: false), count: length).joined(separator: ", ")))"
        case .constPointer(let cType):
            if case .void = cType {
                return "UnsafeRawPointer"
            } else if case .char = cType, isTopLevel {
                return "String"
            }
            return "UnsafePointer<\(cType.cTypeName(in: namespace, isTopLevel: false))>"
        case .pointer(let cType):
            if case .void = cType {
                return "UnsafeMutableRawPointer"
            }
            return "UnsafeMutablePointer<\(cType.cTypeName(in: namespace, isTopLevel: false))>"
        case .struct(let structRef):
            if let structNamespace = structRef.namespace, structNamespace != namespace {
                return "\(structNamespace).\(structRef.name)"
            }
            return structRef.name
        case .union:
            fatalError()
        case .optional(let underlyingType):
            return underlyingType.cTypeName(in: namespace, isTopLevel: false) + "?"
        case .cFunctionPointer(let arguments, let returnType):
            return "@escaping @convention(c) (\(arguments.map { "_ \($0.name): \($0.type.cTypeName(in: namespace, isTopLevel: false))" }.joined(separator: ", "))) -> \(returnType.cTypeName(in: namespace, isTopLevel: false))"
        }
    }
    
    var underlyingInOutType: CType? {
        if case .pointer(let cType) = self {
            switch cType {
            case .void, .struct, .char:
                break
            default:
                return cType
            }
        }
        return nil
    }
    
    var isOptionSet: Bool {
        if case .struct(let structRef) = self, structRef.isOptionSet {
            return true
        }
        return false
    }
    
    var hasDifferingSwiftType: Bool {
        switch self {
        case .constPointer(to: .char),
                .pointer(to: .char),
                .imVec2,
                .imVec4:
            return true
        case .pointer(to: let type) where type.hasDifferingSwiftType:
            return true
        case .constPointer(to: let type) where type.hasDifferingSwiftType:
            return true
        case .struct(let type) where type.isOptionSet:
            return true
        default:
            return false
        }
    }
    
    func constructSwiftType(_ inputValue: String) -> String {
        if self.hasDifferingSwiftType {
            switch self {
            case .constPointer(to: .char),
                    .pointer(to: .char):
                return "String(cString: \(inputValue))"
            case .imVec2:
                return "SIMD2<Float>(\(inputValue))"
            case .imVec4:
                return "SIMD4<Float>(\(inputValue))"
            case .struct(let type):
                return "\(type.name)(rawValue: \(inputValue))"
            default:
                break
            }
        }
        return inputValue
    }
    
    func constructCType(_ inputValue: String) -> String {
        if self.hasDifferingSwiftType {
            switch self {
            case .imVec2:
                return "ImVec2(\(inputValue))"
            case .imVec4:
                return "ImVec4(\(inputValue))"
            case .struct:
                return "\(inputValue).rawValue"
            default:
                break
            }
        }
        return inputValue
    }
    
    mutating func translateDefaultValue(_ defaultValue: String) -> String {
        switch (self, defaultValue) {
        case (.struct(let structType), "0") where structType.isOptionSet:
            return "[]" // OptionSet
        case (.struct(let structType), let value) where structType.isOptionSet:
            return "\(structType.name)(rawValue: \(value))"
        case (.float, "FLT_MIN"):
            return ".leastNormalMagnitude"
        case (.float, "FLT_MAX"):
            return ".greatestFiniteMagnitude"
        case (.float, "-FLT_MIN"):
            return "-.leastNormalMagnitude"
        case (.float, "-FLT_MAX"):
            return "-.greatestFiniteMagnitude"
        case (.float, let value) where value.hasSuffix("f"):
            return String(value.dropLast())
        case (.pointer, "((void*)0)"),
             (.constPointer, "((void*)0)"):
            self = .optional(self)
            return "nil"
        case (.optional, "NULL"):
            return "nil"
        case (_, "NULL"):
            self = .optional(self)
            return "nil"
        case (_, "sizeof(float)"):
            return "Int32(MemoryLayout<Float>.stride)"
        case (.imVec2, _), (.imVec4, _):
            var underlyingType = CType.float
            let components = defaultValue
                .drop(while: { $0 != "("})
                .dropFirst()
                .prefix(while: { $0 != ")" })
                .split(separator: ",")
            if components.isEmpty {
                return "\(self.swiftTypeName(in: nil)).zero"
            }
            let componentsStr = components.map { component in
                return underlyingType.translateDefaultValue(String(component))
            }.joined(separator: ", ")
            return "\(self.swiftTypeName(in: nil))(\(componentsStr))"
            
        default:
            return defaultValue
        }
    }
}


extension CType: CustomStringConvertible {
    var description: String { return self.cTypeName(in: nil) }
}
