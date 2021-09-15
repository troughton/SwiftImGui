//
//  File.swift
//  File
//
//  Created by Thomas Roughton on 13/09/21.
//

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

extension ImGui {

    @discardableResult
    public static func combo(label: String, currentIndex: inout Int, items: [String]) -> Bool {
        return self.combo(label: label, currentItem: &currentIndex, itemsSeparatedByZeros: items.joined(separator: "\0") + "\0", popupMaxHeightInItems: items.count)
    }
    
    @discardableResult
    public static func combo<T : Equatable>(label: String, currentItem: inout T, items: [T], itemToString: (T) -> String = { String(describing: $0) }) -> Bool {
        var currentIndex = items.firstIndex(of: currentItem) ?? 0
        defer {
            currentItem = items[currentIndex]
        }
        return self.combo(label: label, currentItem: &currentIndex, itemsSeparatedByZeros: items.map(itemToString).joined(separator: "\0") + "\0", popupMaxHeightInItems: items.count)
    }
    
    public static func listBox(label: String, currentItem: inout Int, items: [String], heightInItems: Int = -1) -> Bool {
        return withArrayOfCStrings(items) { (array) -> Bool in
            return self.listBox(label: label, currentItem: &currentItem, items: array, itemsCount: items.count, heightInItems: heightInItems)
        }
    }
    
    @discardableResult
    public static func inputText(label: String, string: inout String, callback: ImGuiInputTextCallback? = nil, userData: UnsafeMutableRawPointer? = nil, flags: InputTextFlags = []) -> Bool {
        let bufferSize = 256
        var buffer = [CChar](repeating: 0, count: bufferSize)
        string.withCString { cString in
            buffer.withUnsafeMutableBytes { buffer in
                buffer.baseAddress?.copyMemory(from: string, byteCount: strlen(cString))
            }
        }
        
        let shouldUpdate = igInputText(label, &buffer, bufferSize, flags.rawValue, callback, userData)
        
        if shouldUpdate {
            buffer.withUnsafeBufferPointer { buffer in
                let buffer = UnsafeRawPointer(buffer.baseAddress!).assumingMemoryBound(to: UInt8.self)
                string = String(cString: buffer)
            }
        }
        return shouldUpdate
    }
    
    public static func pushID(_ identifier: AnyObject)  {
        self.pushID(Unmanaged.passUnretained(identifier).toOpaque())
    }
    
    public static func treeNode(_ identifier: AnyObject, text: String, flags: TreeNodeFlags = []) -> Bool {
        return self.treeNode(UnsafeRawPointer(Unmanaged.passUnretained(identifier).toOpaque()), text: text, flags: flags)
    }
    
    public static func treeNode(_ identifier: Int, text: String, flags: TreeNodeFlags = []) -> Bool {
        return self.treeNode(UnsafeRawPointer(bitPattern: identifier), text: text, flags: flags)
    }
    
    @discardableResult
    public static func drag(label: String, value vTemp: inout SIMD2<Int>, speed v_speed: Float = 1.0, min v_min: Int = 0, max v_max: Int = 0, format: String = "%d", flags: SliderFlags = []) -> Bool {
        var v = SIMD2<Int32>(truncatingIfNeeded: vTemp)
        defer { vTemp = SIMD2<Int>(truncatingIfNeeded: v) }
        return self.drag(label: label, value: &v, speed: v_speed, min: v_min, max: v_max, format: format, flags: flags)
    }

    @discardableResult
    public static func drag(label: String, value vTemp: inout SIMD3<Int>, speed v_speed: Float = 1.0, min v_min: Int = 0, max v_max: Int = 0, format: String = "%d", flags: SliderFlags = []) -> Bool {
        var v = SIMD3<Int32>(truncatingIfNeeded: vTemp)
        defer { vTemp = SIMD3<Int>(truncatingIfNeeded: v) }
        return self.drag(label: label, value: &v, speed: v_speed, min: v_min, max: v_max, format: format, flags: flags)
    }

    @discardableResult
    public static func drag(label: String, value vTemp: inout SIMD4<Int>, speed v_speed: Float = 1.0, min v_min: Int = 0, max v_max: Int = 0, format: String = "%d", flags: SliderFlags = []) -> Bool {
        var v = SIMD4<Int32>(truncatingIfNeeded: vTemp)
        defer { vTemp = SIMD4<Int>(truncatingIfNeeded: v) }
        return self.drag(label: label, value: &v, speed: v_speed, min: v_min, max: v_max, format: format, flags: flags)
    }
    
    @discardableResult
    public static func input(label: String, value vTemp: inout SIMD2<Int>, flags: InputTextFlags = []) -> Bool {
        var v = SIMD2<Int32>(truncatingIfNeeded: vTemp)
        defer { vTemp = SIMD2<Int>(truncatingIfNeeded: v) }
        return self.input(label: label, value: &v, flags: flags)
    }

    @discardableResult
    public static func input(label: String, value vTemp: inout SIMD3<Int>, flags: InputTextFlags = []) -> Bool {
        var v = SIMD3<Int32>(truncatingIfNeeded: vTemp)
        defer { vTemp = SIMD3<Int>(truncatingIfNeeded: v) }
        return self.input(label: label, value: &v, flags: flags)
    }

    @discardableResult
    public static func input(label: String, value vTemp: inout SIMD4<Int>, flags: InputTextFlags = []) -> Bool {
        var v = SIMD4<Int32>(truncatingIfNeeded: vTemp)
        defer { vTemp = SIMD4<Int>(truncatingIfNeeded: v) }
        return self.input(label: label, value: &v, flags: flags)
    }
    
    @discardableResult
    public static func slider(label: String, value vTemp: inout SIMD2<Int>, min v_min: Int, max v_max: Int, format: String = "%d", flags: SliderFlags = []) -> Bool {
        var v = SIMD2<Int32>(truncatingIfNeeded: vTemp)
        defer { vTemp = SIMD2<Int>(truncatingIfNeeded: v) }
        return self.slider(label: label, value: &v, min: v_min, max: v_max, format: format, flags: flags)
    }

    @discardableResult
    public static func slider(label: String, value vTemp: inout SIMD3<Int>, min v_min: Int, max v_max: Int, format: String = "%d", flags: SliderFlags = []) -> Bool {
        var v = SIMD3<Int32>(truncatingIfNeeded: vTemp)
        defer { vTemp = SIMD3<Int>(truncatingIfNeeded: v) }
        return self.slider(label: label, value: &v, min: v_min, max: v_max, format: format, flags: flags)
    }

    @discardableResult
    public static func slider(label: String, value vTemp: inout SIMD4<Int>, min v_min: Int, max v_max: Int, format: String = "%d", flags: SliderFlags = []) -> Bool {
        var v = SIMD4<Int32>(truncatingIfNeeded: vTemp)
        defer { vTemp = SIMD4<Int>(truncatingIfNeeded: v) }
        return self.slider(label: label, value: &v, min: v_min, max: v_max, format: format, flags: flags)
    }
}

extension ImGuiTextBuffer {
    public mutating func append(stringStart str_start: UnsafePointer<CChar>, stringEnd str_end: UnsafePointer<CChar>? = nil) -> Void {
        ImGuiTextBuffer_append(&self, str_start, str_end)
    }
}
