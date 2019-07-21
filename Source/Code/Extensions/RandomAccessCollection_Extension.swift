//
//  RandomAccessCollection.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-07-21.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public extension RandomAccessCollection
    where
    Element: Comparable,
    Self.Index == Int
{

    func rotatedSoThatLargestElementIsFirst() -> [Element] {
        switch countedElementsZeroOneTwoAndMany {
        case .zero: return []
        case .one(let single): return [single]
        case .two(let a, let b): return [Swift.max(a, b), Swift.min(a, b)]
        case .many:
            let indexOfMax = firstIndex(of: self.max()!)!
            if indexOfMax < count/2 {
                return shiftedLeft(by: indexOfMax)
            } else {
                return shiftedRight(by: indexOfMax.distance(to: self.endIndex))
            }
        }
    }
}

public extension RandomAccessCollection where
    Self.Index == Int {

    /// [1...10].shiftedLeft(by: 1) => [2, 3, 4, 5, 6, 7, 8, 9, 10, 1]
    /// [1...10].shiftedLeft(by: 7) => [8, 9, 10, 1, 2, 3, 4, 5, 6, 7]
    func shiftedLeft(by rawOffset: Int = 1) -> [Element] {
        let clampedAmount = rawOffset % count
        let offset = clampedAmount < 0 ? count + clampedAmount : clampedAmount
        return Array(self[offset ..< count]) + Array(self[0 ..< offset])
    }


    func shiftedRight(by rawOffset: Int = 1) -> [Element] {
        return self.shiftedLeft(by: -rawOffset)
    }

    static func << (c: Self, offset: Int) -> [Element] { c.shiftedLeft(by: offset) }
    static func >> (c: Self, offset: Int) -> [Element] { c.shiftedRight(by: offset) }
}

public extension RandomAccessCollection where
    Self: RangeReplaceableCollection,
    Self.Index == Int {

    mutating func shiftLeft(by rawOffset: Int = 1) {
        self = Self.init(shiftedLeft(by: rawOffset))
    }

    mutating func shiftRight(by rawOffset: Int = 1) {
        self = Self.init(self.shiftedRight(by: rawOffset))
    }

    static func <<= (c: inout Self, offset: Int) { c.shiftLeft(by: offset) }
    static func >>= (c: inout Self, offset: Int) { c.shiftRight(by: offset) }
}
