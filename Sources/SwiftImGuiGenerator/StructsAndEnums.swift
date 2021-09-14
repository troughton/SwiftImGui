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
}


