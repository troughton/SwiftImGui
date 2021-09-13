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
}
