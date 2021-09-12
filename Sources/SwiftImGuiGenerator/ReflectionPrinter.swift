//
//  File.swift
//  File
//
//  Created by Thomas Roughton on 11/09/21.
//

import Foundation

struct ReflectionPrinter {
    static let tab = "    "
    
    var buffer = ""
    var indent = 0
    
    private mutating func printLine(_ string: String) {
        for _ in 0..<self.indent {
            self.buffer += ReflectionPrinter.tab
        }
        self.buffer += string
        self.buffer += "\n"
    }
    
    mutating func print(_ string: String) {
        let lines = string.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespaces) }
        
        for line in lines {
            let scopeBegins = line.lazy.filter { $0 == "{" || $0 == "(" }.count
            let scopeEnds = line.lazy.filter { $0 == "}" || $0 == ")" }.count
            let delta = scopeBegins - scopeEnds
            let lineDelta = line.lazy.prefix(while: { $0 != "{" }).filter({ $0 == "}" }).count + line.lazy.prefix(while: { $0 != "(" }).filter({ $0 == ")" }).count
            
            self.indent = max(0, self.indent - lineDelta)
            
            printLine(line)
            
            self.indent = max(0, self.indent + delta + lineDelta)
        }
    }
    
    mutating func newLine() {
        self.buffer += "\n"
    }
    
    func write(to url: URL) throws {
        try self.buffer.write(to: url, atomically: true, encoding: .utf8)
    }
    
}
