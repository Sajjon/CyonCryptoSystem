//
//  Collection_Extension.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-07-18.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public extension Collection {

    var countedElementsZeroOneTwoAndMany: ZeroOneTwoAndMany<Element> {
        if isEmpty {
            return .zero
        } else {
            let firstElement = first!
            if count == 1 {
                return .one(single: firstElement)
            } else {
                let second = self.dropFirst().first!
                if count == 2 {
                    return .two(first: firstElement, secondAndLast: second)
                } else {
                    let last = self.suffix(1).first!
                    return .many(first: firstElement, second: second, last: last)
                }
            }

        }
    }

    func slidingWindow(length: Int) -> AnyRandomAccessCollection<SubSequence> {
        guard !isEmpty, length > 1, length <= count else { return AnyRandomAccessCollection([]) }

        let windows = sequence(first: (startIndex, index(startIndex, offsetBy: length)),
                               next: { (start, end) in
                                guard end != self.endIndex else { return nil }
                                let nextStart = self.index(after: start)
                                let nextEnd = self.index(after: end)
                                return (nextStart, nextEnd)
        })

        return AnyRandomAccessCollection(
            windows.lazy.map{ (start, end) in
                self[start..<end]
            }
        )
    }
}
