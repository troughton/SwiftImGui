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
            .map { $0 == "buf" ? "buffer" : $0}
            .enumerated()
            .map { $0.offset > 0 ? $0.element.capitalized : String($0.element) }
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
    if ["repeat", "while", "super"].contains(name) {
        return "`\(name)`"
    }
    
    return name
}

func toSwiftMemberName<S: StringProtocol>(_ memberName: S) -> String {
    let name = memberName.prefix(1).lowercased() + memberName.dropFirst()
    
    if ["repeat", "while", "super"].contains(name) {
        return "`\(name)`"
    }
    return name
}

let directory = URL(fileURLWithPath: CommandLine.arguments[1])

let decoder = JSONDecoder()

let structsAndEnums = try decoder.decode(ImGuiStructsAndEnums.self, from: try! Data(contentsOf: directory.appendingPathComponent("structs_and_enums.json")))

for (enumName, enumMembers) in structsAndEnums.enums {
    let type = CTypeStruct.named(enumName, isOptionSet: true)
    type.members.append(.init(name: "rawValue", type: .int32, isStatic: false, computedPropertyText: nil))
    type.members.append(contentsOf: enumMembers.compactMap { member in
        if member.name.hasSuffix("_COUNT") { return nil }
        if member.calc_value == 0 { return nil }
        
        return CTypeStruct.Member(name: toSwiftMemberName(member.name.split(separator: "_").last!), type: .struct(type), isStatic: true, computedPropertyText: "\(type.name)(rawValue: \(member.calc_value))")
    })
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

func scan<
    S : Sequence, U
    >(_ seq: S, _ initial: U, _ combine: (U, S.Iterator.Element) -> U) -> [U] {
    var result: [U] = []
    result.reserveCapacity(seq.underestimatedCount)
    var runningResult = initial
    for element in seq {
        runningResult = combine(runningResult, element)
        result.append(runningResult)
    }
    return result
}

func withArrayOfCStrings<R>(
    _ args: [String], _ body: ([UnsafePointer<CChar>?]) -> R
) -> R {
    let argsCounts = Array(args.map { $0.utf8.count + 1 })
    let argsOffsets = [ 0 ] + scan(argsCounts, 0, +)
    let argsBufferSize = argsOffsets.last!
    
    var argsBuffer: [UInt8] = []
    argsBuffer.reserveCapacity(argsBufferSize)
    for arg in args {
        argsBuffer.append(contentsOf: arg.utf8)
        argsBuffer.append(0)
    }
    
    return argsBuffer.withUnsafeMutableBufferPointer {
        (argsBuffer) in
        let ptr = UnsafeMutableRawPointer(argsBuffer.baseAddress!).bindMemory(
            to: CChar.self, capacity: argsBuffer.count)
        var cStrings: [UnsafeMutablePointer<CChar>?] = argsOffsets.map { ptr + $0 }
        cStrings[cStrings.count - 1] = nil
        return body(cStrings)
    }
}

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

reflectionPrinter.print(
"""
extension ImGui {
    public final class RenderData {
        public let vertexBuffer : UnsafeMutableBufferPointer<ImDrawVert>
        public let indexBuffer : UnsafeMutableBufferPointer<ImDrawIdx>
        public let drawCommands : [DrawCommand]
        public let displayPosition : SIMD2<Float>
        public let displaySize : SIMD2<Float>
        public let clipScaleFactor : Float
        
        init(vertexBuffer: UnsafeMutableBufferPointer<ImDrawVert>, indexBuffer: UnsafeMutableBufferPointer<ImDrawIdx>, drawCommands : [DrawCommand], displayPosition: SIMD2<Float>, displaySize: SIMD2<Float>, clipScaleFactor: Float) {
            self.vertexBuffer = vertexBuffer
            self.indexBuffer = indexBuffer
            self.drawCommands = drawCommands
            self.displayPosition = displayPosition
            self.displaySize = displaySize
            self.clipScaleFactor = clipScaleFactor
        }
        
        deinit {
            self.vertexBuffer.baseAddress?.deallocate()
            self.indexBuffer.baseAddress?.deallocate()
        }
    }
    
    public struct DrawCommand {
        public var vertexBufferByteOffset = 0
        public var indexBufferByteOffset = 0
        public var subCommands = [ImDrawCmd]()
    }
    
    public struct DrawList {
        private let imList : UnsafeMutablePointer<ImDrawList>
        
        init(_ imList: UnsafeMutablePointer<ImDrawList>) {
            self.imList = imList
        }
        
        public var vertexBufferSize : Int {
            return Int(imList.pointee.VtxBuffer.Size)
        }
        
        public subscript(vertex n: Int) -> ImDrawVert {
            get {
                return imList.pointee.VtxBuffer.Data[n]
            }
            set {
                imList.pointee.VtxBuffer.Data[n] = newValue
            }
        }
        
        public subscript(vertexPtr n: Int) -> UnsafeMutablePointer<ImDrawVert> {
            return imList.pointee.VtxBuffer.Data.advanced(by: n)
        }
        
        public var indexBufferSize : Int {
            return Int(self.imList.pointee.IdxBuffer.Size)
        }
        
        public subscript(index n: Int) -> ImDrawIdx {
            get {
                return self.imList.pointee.IdxBuffer.Data[n]
            }
            set {
                self.imList.pointee.IdxBuffer.Data[n] = newValue
            }
        }
        
        public subscript(indexPtr n: Int) -> UnsafeMutablePointer<ImDrawIdx> {
            return self.imList.pointee.IdxBuffer.Data.advanced(by: n)
        }
        
        public var commandSize : Int {
            return Int(self.imList.pointee.CmdBuffer.Size)
        }
        
        public subscript(command n: Int) -> ImDrawCmd {
            get {
                return self.imList.pointee.CmdBuffer.Data[n]
            }
            set {
                self.imList.pointee.CmdBuffer.Data[n] = newValue
            }
        }
        
        public func addText(_ text: String, position: SIMD2<Float>, color: SIMD4<Float>) {
            self.addText(text, position: position, color: ImGui.colorConvertFloat4ToU32(color))
        }
        
        public func addText(_ text: String, position: SIMD2<Float>, color: UInt32) {
            text.withCString { text in
                self.addText(text, position: position, color: color)
            }
        }
        
        public func addText(_ text: UnsafePointer<CChar>, position: SIMD2<Float>, color: UInt32) {
            ImDrawList_AddText_Vec2(self.imList, ImVec2(position), color, text, text + strlen(text))
        }
        
        public func clearFreeMemory() {
            ImDrawList__ClearFreeMemory(self.imList)
        }
    }
    
    public static func renderData(drawData: UnsafeMutablePointer<ImDrawData>, clipScale: Float) -> RenderData {
        if clipScale != 1.0 {
            drawData.pointee.scaleClipRects(fbScale: SIMD2<Float>(repeating: clipScale))
        }
        
        let vertexBufferCount = Int(drawData.pointee.TotalVtxCount)
        let indexBufferCount = Int(drawData.pointee.TotalIdxCount)
        
        let vertexBuffer = UnsafeMutableBufferPointer(start: UnsafeMutablePointer<ImDrawVert>.allocate(capacity: vertexBufferCount), count: vertexBufferCount)
        let indexBuffer = UnsafeMutableBufferPointer(start: UnsafeMutablePointer<ImDrawIdx>.allocate(capacity: indexBufferCount), count: indexBufferCount)
        
        var drawCommands : [DrawCommand] = []
        
        var vertexBufferOffset = 0
        var indexBufferOffset = 0
        
        var drawCommand = DrawCommand()
        
        // Render command lists
        for n in 0..<Int(drawData.pointee.CmdListsCount) {
            let cmdList = ImGui.DrawList(drawData.pointee.CmdLists[n]!)
            
            let vertexBufferSize = cmdList.vertexBufferSize
            let indexBufferSize = cmdList.indexBufferSize
            
            vertexBuffer.baseAddress!.advanced(by: vertexBufferOffset).initialize(from: cmdList[vertexPtr: 0], count: vertexBufferSize)
            indexBuffer.baseAddress!.advanced(by: indexBufferOffset).initialize(from: cmdList[indexPtr: 0], count: indexBufferSize)
            
            for cmdI in 0..<cmdList.commandSize {
                let pcmd = cmdList[command: cmdI]
                drawCommand.subCommands.append(pcmd)
            }
            
            drawCommands.append(drawCommand)
            
            vertexBufferOffset += vertexBufferSize
            indexBufferOffset += indexBufferSize
            
            drawCommand = DrawCommand()
            drawCommand.vertexBufferByteOffset = vertexBufferOffset * MemoryLayout<ImDrawVert>.stride
            drawCommand.indexBufferByteOffset = indexBufferOffset * MemoryLayout<ImDrawIdx>.stride
        }
        
        let displayPosition = SIMD2<Float>(drawData.pointee.DisplayPos)
        let displaySize = SIMD2<Float>(drawData.pointee.DisplaySize.x, drawData.pointee.DisplaySize.y)
        
        return RenderData(vertexBuffer: vertexBuffer, indexBuffer: indexBuffer, drawCommands: drawCommands, displayPosition: displayPosition, displaySize: displaySize, clipScaleFactor: clipScale)
    }
}

""")

try! reflectionPrinter.write(to: URL(fileURLWithPath: "/Users/Thomas/troughton Repositories/SwiftImGui/Sources/ImGui/ImGui.swift"))
print(reflectionPrinter.buffer)
