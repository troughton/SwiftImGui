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
    
    func printEnum(name: String, members: [ImGuiEnumMember]) -> String {
        let typeName = name.replacingOccurrences(of: "_", with: "")
        let result = """
        public struct \(typeName): OptionSet {
            public let rawValue: Int32
            
            public init(rawValue: Self.RawValue) {
                self.rawValue = rawValue
            }
            
            \(members.compactMap { member in
            if member.name.hasSuffix("_COUNT") { return nil }
            return "public static let \(toSwiftFunctionName(member.name.split(separator: "_").last!)) = \(typeName)(rawValue: \(member.calc_value))"
            }.joined(separator: "\n    "))
        }
        """
        return result
    }
}


