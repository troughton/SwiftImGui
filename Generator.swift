import Foundation

struct CImGuiArgument : Codable {
    var name : String
    var type : String
}

struct CImGuiFunction : Codable {
    var args : String
    var argsT : [CImGuiArgument]
    var call_args : String
    var cimguiname : String
    var constructor : Bool?
    var destructor : Bool?
    var defaults : [String : String]
    var funcname : String?
    var ov_cimguiname : String
    var ret : String?
    var signature : String
    var stname : String // The type on which this method belongs; may be empty for a free function.
    var namespace : String?
}

func toSwiftType(_ typename: String) -> String {
    switch typename {
    case "const char*":
        return "String"
    case "unsigned int":
        return "UInt32"
    case _ where typename.suffix(1) == "*":
        return "inout " + toSwiftType(String(typename.dropLast()))
    default:
        return typename.prefix(1).uppercased() + typename.dropFirst()
    }
}

func toSwiftParameterName(_ parameterName: String) -> String {
    return parameterName.lowercased()
        .split(separator: "_")
        .enumerated()
        .map { $0.offset > 0 ? $0.element.capitalized : String($0.element) }
        .joined()
}

func toSwiftFunctionName(_ functionName: String) -> String {
    return functionName.prefix(1).lowercased() + functionName.dropFirst()
}

func toSwiftDefaultValue(_ defaultValue: String) -> String {
    switch defaultValue {
    case "FLT_MAX":
        return ".greatestFiniteMagnitude"
    case "((void*)0)":
        return "\"\""
    case _ where defaultValue.suffix(1) == "f":
        return String(defaultValue.dropLast())
    default:
        return defaultValue
    }
}

func printFunction(_ function: CImGuiFunction, indent: String) {
    if function.constructor ?? false {
        
    } else if function.destructor ?? false {
        
    } else if function.funcname!.lowercased().prefix(3) == "get" {
        
    } else {
        print(function.namespace != nil ? indent + "public static func " : indent + "public func", terminator: "")
        print(toSwiftFunctionName(function.funcname!), terminator: "(")
        for (i, arg) in function.argsT.enumerated() {
            var argument = "\(toSwiftParameterName(arg.name)): \(toSwiftType(arg.type))"
            if let defaultValue = function.defaults[arg.name] {
                argument += " = \(toSwiftDefaultValue(defaultValue))"
            }
            print(argument, terminator: i == function.argsT.count - 1 ? "" : ", ")
        }
        print(") \(function.ret.map { "-> \(toSwiftType($0))" } ?? "") {")
        
        let parameters = function.argsT.map { toSwiftParameterName($0.name) }.joined(separator: ", ")
        print(indent + "    return \(function.ov_cimguiname)(\(parameters))")
        print(indent + "}\n")
    }
}

let json = try! Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))

let decoder = JSONDecoder()
let imguiDefinitions = try decoder.decode([String : [CImGuiFunction]].self, from: json)

var namespaces = [String : [CImGuiFunction]]()
var types = [String : [CImGuiFunction]]()

for (name, functions) in imguiDefinitions {
    for function in functions {
        if function.
        if let namespace = function.namespace {
            namespaces[namespace, default: []].append(function)
        } else {
            types[function.stname, default: []].append(function)
        }
    }
}

for (namespace, functions) in namespaces {
    print("public enum \(namespace) {")
    for function in functions {
        printFunction(function, indent: "    ")
    }
    print("}\n")
}

//for (type, functions) in types {
//    print("public extension \(type) {")
//    for function in functions {
//        printFunction(function, indent: "    ")
//    }
//    print("}\n")
//}
