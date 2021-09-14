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
    var location: String?
    var templated: Bool?
    var is_static_function: Bool?
    
    var isComputedVariable: Bool {
        return self.argsT.lazy.filter { $0.name != "self" }.isEmpty &&
        (self.ret.map { if case .void = $0 { return false } else { return true } } ?? false) &&
        (self.funcname.map { $0.starts(with: "Is") || $0.starts(with: "Has") } ?? false)
    }
}

func toSwiftParameterName<S: StringProtocol>(_ parameterName: S) -> String {
    switch parameterName {
    case "v":
        return "value"
    case "pos":
        return "position"
    case "pos_min":
        return "minPosition"
    case "pos_max":
        return "maxPosition"
    case "fmt":
        return "format"
    case "p_open":
        return "isOpen"
    case "p_visible":
        return "isVisible"
    case "defaultVal":
        return "defaultValue"
    case _ where parameterName.starts(with: "v_"):
        return toSwiftParameterName(parameterName.dropFirst(2))
    default:
        return parameterName.lowercased()
            .split(separator: "_")
            .map { comp -> String in
                switch comp {
                case "buf":
                    return "buffer"
                case "desc":
                    return "description"
                case "col":
                    return "color"
                case "bg":
                    return "background"
                default:
                    return String(comp)
                }
            }
            .enumerated()
            .map { (offset, element) in
                if offset > 0 {
                    if element == "uv" || element == "io" {
                        return element.uppercased()
                    }
                    return element.capitalized
                } else {
                    return String(element)
                }
            }
            .joined()
        
    }
}

func toSwiftFunctionName<S: StringProtocol>(_ functionName: S) -> String {
    if functionName == "HSV" {
        return "hsv"
    }
    let functionName = functionName.drop(while: { $0 == "_" })
    
    var name = functionName.prefix(1).lowercased() + functionName.dropFirst()
    if name.hasSuffix("Ex") {
        name.removeLast(2)
    }
    if !name.hasSuffix("UV") &&
        !functionName.hasSuffix("HSV") &&
        name.hasSuffix("V") {
        name.removeLast()
    }
    
    if name.count == 2 {
        name = name.lowercased()
    }
    
    if ["repeat", "while", "super", "default"].contains(name) {
        return "`\(name)`"
    }
    
    return name
}

func toSwiftMemberName<S: StringProtocol>(_ memberName: S) -> String {
    let name = memberName.prefix(1).lowercased() + memberName.dropFirst()
    
    if ["repeat", "while", "super", "default"].contains(name) {
        return "`\(name)`"
    }
    return name
}

let directory = URL(fileURLWithPath: CommandLine.arguments[1])

let decoder = JSONDecoder()

let structsAndEnums = try decoder.decode(ImGuiStructsAndEnums.self, from: try! Data(contentsOf: directory.appendingPathComponent("structs_and_enums.json")))

for (enumName, enumMembers) in structsAndEnums.enums {
    let type = CTypeStruct.named(enumName, isOptionSetOrEnum: true)
    type.members.append(.init(name: "rawValue", type: .int32, isStatic: false, computedPropertyText: nil))
    type.members.append(contentsOf: enumMembers.prefix(while: { !$0.name.hasSuffix("_COUNT") }).compactMap { member in
        return CTypeStruct.Member(name: toSwiftMemberName(member.name.split(separator: "_").last!), type: .struct(type), isStatic: true, rawValue: member.calc_value)
    })
    if type.isEnum {
        type.members.removeFirst()
    }
    if type.isOptionSet, let zeroIndex = type.members.firstIndex(where: { $0.rawValue == 0 }) {
        type.members.remove(at: zeroIndex)
    }
}

let typedefs = try decoder.decode([String: String].self, from: try! Data(contentsOf: directory.appendingPathComponent("typedefs_dict.json")))
for (typedefName, typeName) in typedefs {
    if typedefName.contains("Flags") || CTypeStruct.namedTypes[typedefName] != nil { continue }
    if let type = CTypeStruct.namedTypes[typeName] {
        CTypeStruct.namedTypes[typedefName] = type
    }
}

let allTypes = Set(CTypeStruct.namedTypes.values.filter { !$0.members.isEmpty })

var reflectionPrinter = ReflectionPrinter()

reflectionPrinter.print(
"""
import CImGui

extension SIMD2 where Scalar == Float {
    @inlinable
    init(_ imVec: ImVec2) {
        self.init(imVec.x, imVec.y)
    }
}

extension SIMD4 where Scalar == Float {
    @inlinable
    init(_ imVec: ImVec4) {
        self.init(imVec.x, imVec.y, imVec.z, imVec.w)
    }
}

extension ImVec2 {
    @inlinable
    init(_ v: SIMD2<Float>) {
        self.init(x: v.x, y: v.y)
    }
}

extension ImVec4 {
    @inlinable
    init(_ v: SIMD4<Float>) {
        self.init(x: v.x, y: v.y, z: v.z, w: v.w)
    }
}

extension SIMD {
    @inlinable
    mutating func withMutableMemberPointer<R>(_ perform: (UnsafeMutablePointer<Scalar>) -> R) -> R {
        return withUnsafeMutableBytes(of: &self) { buffer in
            perform(buffer.baseAddress!.assumingMemoryBound(to: Scalar.self))
        }
    }
}

@inlinable
func withMutableMembers<T, R>(of tuple: inout (T, T),  _ perform: (UnsafeMutablePointer<T>) -> R) -> R {
    return withUnsafeMutableBytes(of: &tuple) { buffer in
        perform(buffer.baseAddress!.assumingMemoryBound(to: T.self))
    }
}

""")

for type in allTypes.filter { $0.namespace == nil }.sorted(by: { $0.name < $1.name }) {
    type.print(to: &reflectionPrinter)
    reflectionPrinter.newLine()
}

let imguiDefinitions = try decoder.decode([String : [CImGuiFunction]].self, from: try! Data(contentsOf: directory.appendingPathComponent("definitions.json")))

var namespaces = [String : [ImGuiFunction]]()
var types = [String : [ImGuiFunction]]()

for (name, functions) in imguiDefinitions.sorted(by: { $0.key < $1.key }) {
    for function in functions {
        guard let converted = ImGuiFunction(function) else { continue }
        if let namespace = function.namespace {
            namespaces[namespace, default: []].append(converted)
        } else {
            types[function.stname, default: []].append(converted)
        }
    }
}

func processSettersInFunctionList(_ functionList: [ImGuiFunction]) {
    let functionsByName = Dictionary(functionList.lazy.filter { $0.isComputedVariable }.map { ($0.name.lowercased(), $0) }, uniquingKeysWith: { a, b in a })
    for function in functionList {
        if function.arguments.count == 1,
           case .normal(.void) = function.returnType,
            function.name.starts(with: "set"),
            let getter = functionsByName[function.name.dropFirst(3).lowercased()] {
            getter.setterFunction = function
            function.isComputedVariable = true
        }
    }
}

for functionList in namespaces.values {
    processSettersInFunctionList(functionList)
}

for functionList in types.values {
    processSettersInFunctionList(functionList)
}

for (namespace, functions) in namespaces.sorted(by: { $0.key < $1.key }) {
    reflectionPrinter.print("public enum \(namespace) {")
    
    for type in allTypes.filter { $0.namespace == namespace }.sorted(by: { $0.name < $1.name }) {
        type.print(to: &reflectionPrinter)
        reflectionPrinter.newLine()
    }
    
    for function in functions.sorted(by: { $0.name < $1.name }) {
        function.print(to: &reflectionPrinter, namespace: namespace)
    }
    reflectionPrinter.print("}")
    reflectionPrinter.newLine()
}

for (type, functions) in types.sorted(by: { $0.key < $1.key }) {
    reflectionPrinter.print("extension \(type) {")
    for function in functions.sorted(by: { $0.name < $1.name }) {
        function.print(to: &reflectionPrinter, namespace: type)
    }
    reflectionPrinter.print("}")
    reflectionPrinter.newLine()
}

print(reflectionPrinter.buffer)
