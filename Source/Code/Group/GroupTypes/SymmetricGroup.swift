//
//  SymmetricGroup.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-05-29.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

extension Int64: GroupElement {}
extension Array: GroupElement where Element: Equatable {}
extension Set: GroupElement {}
extension OrderedSet: GroupElement where Element: Equatable {}

public protocol FiniteSymmetricGroup: FiniteGroup where Element == OrderedSet<SetElement> {
    associatedtype SetElement: GroupElement & Hashable
    var set: Element { get }
    func functionComposition(f: Element, g: Element) -> Element
}

public extension FiniteSymmetricGroup {
    var order: Int64 {
        return Int64(set.count)
    }

    func operation(_ lhs: Element, _ rhs: Element) -> Element {
        return functionComposition(f: lhs, g: rhs)
    }

    func isElementInGroup(_ value: Element) -> Bool {
        implementMe
    }

    func inverse(of element: Element) -> Element {
        implementMe
    }
}

var implementMe: Never {
    fatalError("Implement me")
}

public struct SymmetricGroupInt64: FiniteSymmetricGroup {
    public typealias SetElement = Int64
    public typealias Element = OrderedSet<SetElement>

    public let identity: Element
    public let set: Element

    public init(size: Int64, set: Element) {
        identity = Element(Int64(1)...size)
        self.set = set
    }

    public func functionComposition(f: Element, g: Element) -> Element {

        // Example from: https://en.wikipedia.org/wiki/Symmetric_group#Multiplication
        // `f = (1 3)(4 5)`: [[1, 3], [4, 5]]
        // `g = (1 2 5)(3 4)`: [[1, 2, 5], [3, 4]]
        // `f ∘ g = (1 2 4)(3 5)`: [[1, 2, 4], [3, 5]]

        implementMe
    }

}
