//
//  File.swift
//  
//
//  Created by Thomas Roughton on 9/05/20.
//

import Foundation

class CTypeStruct {
    let name: String
    var members: [(name: String, type: CType)] = []
    
    init(name: String) {
        self.name = name
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
    
    case vector(element: CType, length: Int)
    case packedVector(element: CType, length: Int)
    case matrix(element: CType, rows: Int, columns: Int)
    case array(element: CType, length: Int)
    case `struct`(CTypeStruct)
    case constPointer(to: CType)
    case pointer(to: CType)
    case union
    case optional(CType)
    
    static var knownTypes = [String: CType]()
    
    init?<S: StringProtocol>(string: S, addToDictIfMissing: Bool = true) {
        let string = string.trimmingCharacters(in: .whitespaces)
        if string == "..." {
            self = .variadic
            return
        }
        
        if string.last == "*" || string.last == "&" {
            if string.hasPrefix("const") {
                guard let type = CType(string: string.dropLast().replacingOccurrences(of: "const", with: ""), addToDictIfMissing: addToDictIfMissing) else { return nil }
                self = .constPointer(to: type)
            } else {
                guard let type = CType(string: string.dropLast(), addToDictIfMissing: addToDictIfMissing) else { return nil }
                self = .pointer(to: type)
            }
        } else {
            if string.hasPrefix("const") || string.hasSuffix("const") {
                if let type = CType(string: string.replacingOccurrences(of: "const", with: ""), addToDictIfMissing: addToDictIfMissing) {
                    self = type
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
                    if arrayLength == 0 {
                        self = .pointer(to: type)
                    } else if arrayLength == 2 || arrayLength == 3 || arrayLength == 4 || arrayLength == 8 || arrayLength == 16 {
                        self = .vector(element: type, length: arrayLength)
                    } else {
                        self = .array(element: type, length: arrayLength)
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
            case "uint64_t":
                self = .uint64
            case "size_t":
                self = .sizeT
            case "ImVec2":
                self = .vector(element: .float, length: 2)
            case "ImVec4":
                self = .vector(element: .float, length: 4)
            default:
                if let type = Self.knownTypes[string] {
                    self = type
                } else if addToDictIfMissing {
                    self = .struct(CTypeStruct(name: string)) // Point to a class that we'll fill in later.
                    Self.knownTypes[string] = self
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
    
    var name : String {
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
        case .packedVector(let element, let length):
            return "PackedVector\(length)<\(element)>"
        case .vector(.half, let length):
            return "Vector\(length)h" // FIXME: use SIMD once Float16 is a native Swift type.
        case .vector(let element, let length):
            return "SIMD\(length)<\(element)>"
        case .matrix(let element, 4, 3):
            return "AffineMatrix<\(element)>"
        case .matrix(let element, let rows, let columns):
            return "Matrix\(rows)x\(columns)<\(element)>"
        case .array(let element, let length):
            return "(\(repeatElement(element.name, count: length).joined(separator: ", ")))"
        case .constPointer(let cType):
            if case .void = cType {
                return "UnsafeRawPointer"
            } else if case .char = cType {
                return "String"
            } else if case .struct = cType {
                return "OpaquePointer"
            }
            return "UnsafePointer<\(cType.name)>?"
        case .pointer(let cType):
            if case .void = cType {
                return "UnsafeMutableRawPointer"
            } else if case .struct = cType {
                return "OpaquePointer"
            }
            return "UnsafeMutablePointer<\(cType.name)>"
        case .struct(let structRef):
            return structRef.name
        case .union:
            fatalError()
        case .optional(let underlyingType):
            return underlyingType.name + "?"
        }
    }
    
    var nameInArgumentPosition: String {
        if case .pointer(let cType) = self {
            switch cType {
            case .void, .struct:
                break
            default:
                return "inout \(cType.name)"
            }
        }
        return self.name
    }
    
    mutating func translateDefaultValue(_ defaultValue: String) -> String {
        switch (self, defaultValue) {
        case (.struct, "0"):
            return "[]" // OptionSet
        case (.float, "FLT_MAX"):
            return ".greatestFiniteMagnitude"
        case (.float, let value) where value.hasSuffix("f"):
            return String(value.dropLast())
        case (.pointer, "((void*)0)"),
             (.constPointer, "((void*)0)"):
            self = .optional(self)
            return "nil"
        case (_, "NULL"):
            return "nil"
        default:
            return defaultValue
        }
    }
}


extension CType: CustomStringConvertible {
    var description: String { return self.name }
}
