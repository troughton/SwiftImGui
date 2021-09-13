//
//  File.swift
//  File
//
//  Created by Thomas Roughton on 13/09/21.
//

import CImGui

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
