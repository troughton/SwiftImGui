//
//  File.swift
//  
//
//  Created by Thomas Roughton on 9/05/20.
//

import Foundation

struct ImGuiEnumMember: Codable {
    var calc_value: Int
    var name: String
}

struct ImGuiStructMember: Decodable {
    var name: String
    var type: CType
}

struct ImGuiStructsAndEnums: Decodable {
    var enums: [String: [ImGuiEnumMember]]
    var structs: [String: [ImGuiStructMember]]
    
    func printEnum(to reflectionPrinter: inout ReflectionPrinter, name: String, members: [ImGuiEnumMember]) {
        let typeName = name.replacingOccurrences(of: "_", with: "")
        let result = """
        public struct \(typeName): OptionSet {
            public let rawValue: Int32
            
            public init(rawValue: Self.RawValue) {
                self.rawValue = rawValue
            }
            
            \(members.compactMap { member in
            if member.name.hasSuffix("_COUNT") { return nil }
            if member.calc_value == 0 { return nil }
            return "public static var \(toSwiftFunctionName(member.name.split(separator: "_").last!)): \(typeName) { \(typeName)(rawValue: \(member.calc_value)) }"
            }.joined(separator: "\n    "))
        }
        """
        reflectionPrinter.print(result)
    }
}


