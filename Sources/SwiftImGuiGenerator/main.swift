import Foundation

struct CImGuiArgument : Decodable {
    var name : String
    var type : CType
}

struct CImGuiFunction : Decodable {
    var args : String
    var argsT : [CImGuiArgument]
    var call_args : String
    var cimguiname : String
    var constructor : Bool?
    var destructor : Bool?
    var defaults : [String : String]
    var funcname : String?
    var ov_cimguiname : String
    var ret : CType?
    var signature : String
    var stname : String // The type on which this method belongs; may be empty for a free function.
    var namespace : String?
}

func toSwiftParameterName(_ parameterName: String) -> String {
    return parameterName.lowercased()
        .split(separator: "_")
        .enumerated()
        .map { $0.offset > 0 ? $0.element.capitalized : String($0.element) }
        .joined()
}

func toSwiftFunctionName<S: StringProtocol>(_ functionName: S) -> String {
    return functionName.prefix(1).lowercased() + functionName.dropFirst()
}

func printFunction(_ function: CImGuiFunction, indent: String) {
    if function.constructor ?? false {
        
    } else if function.destructor ?? false {
        
    } else if function.funcname!.lowercased().prefix(3) == "get" {
        
    } else {
        print(function.namespace != nil ? indent + "public static func " : indent + "public func", terminator: "")
        print(toSwiftFunctionName(function.funcname!), terminator: "(")
        for (i, arg) in function.argsT.enumerated() {
            var arg = arg
            
            // Translating the default value can mutate arg.type, so we need to do it early.
            let defaultValueStr = function.defaults[arg.name].map { arg.type.translateDefaultValue($0) }
            
            var argument = "\(toSwiftParameterName(arg.name)): \(arg.type.nameInArgumentPosition)"
            if let defaultValueStr = defaultValueStr {
                argument += " = \(defaultValueStr)"
            }
            print(argument, terminator: i == function.argsT.count - 1 ? "" : ", ")
        }
        print(") \(function.ret.map { "-> \($0.name)" } ?? "") {")
        
        let parameters = function.argsT.map { toSwiftParameterName($0.name) }.joined(separator: ", ")
        print(indent + "    return \(function.ov_cimguiname)(\(parameters))")
        print(indent + "}\n")
    }
}

let directory = URL(fileURLWithPath: CommandLine.arguments[1])

let decoder = JSONDecoder()

let typedefs = try decoder.decode([String: String].self, from: try! Data(contentsOf: directory.appendingPathComponent("typedefs_dict.json")))
for (typedefName, typeName) in typedefs {
    if typedefName.contains("Flags") { continue }
    if let type = CType(string: typeName, addToDictIfMissing: false) {
        CType.knownTypes[typedefName] = CType(string: typeName)
    }
}

let structsAndEnums = try decoder.decode(ImGuiStructsAndEnums.self, from: try! Data(contentsOf: directory.appendingPathComponent("structs_and_enums.json")))

for (enumName, enumMembers) in structsAndEnums.enums {
    print(structsAndEnums.printEnum(name: enumName, members: enumMembers))
}

let imguiDefinitions = try decoder.decode([String : [CImGuiFunction]].self, from: try! Data(contentsOf: directory.appendingPathComponent("definitions.json")))

var namespaces = [String : [CImGuiFunction]]()
var types = [String : [CImGuiFunction]]()

for (name, functions) in imguiDefinitions {
    for function in functions {
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
