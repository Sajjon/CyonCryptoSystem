//
//  IntegersModN.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-05-29.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public struct IntegersModN: FiniteCyclicGroup, ModularGroup, Equatable {
    public let modulus: (IntegersModN, Element) -> Element
    public let order: Int
    public init(n order: Element.Value) {
        self.modulus = { Element($1.value % order, in: $0) }
        self.order = order
    }
}

public extension IntegersModN {
    static func == (lhs: IntegersModN, rhs: IntegersModN) -> Bool {
        return lhs.order == rhs.order
    }
}

// MARK: Element
public extension IntegersModN {
    struct Element: ModularElement, Comparable, Equatable {
        public typealias Value = Int
        public typealias InGroup = IntegersModN

        fileprivate let value: Value
        public let inGroup: InGroup

        init(_ value: Value, in group: InGroup) {
            self.value = value
            self.inGroup = group
        }
    }

    func element(_ value: Element.Value) -> Element {
        return Element(value, in: self)
    }
}

public extension IntegersModN.Element {

    // MARK: CustomStringConvertible
    var description: String { value.description }

    // MARK: Equatable
    static func == (lhs: IntegersModN.Element, rhs: IntegersModN.Element) -> Bool { lhs.value == rhs.value }

    // MARK: Comparable
    static func < (lhs: IntegersModN.Element, rhs: IntegersModN.Element) -> Bool {
        return IntegersModN.compare(lhs, with: rhs) { $0 < $1 }
    }

    static func <= (lhs: IntegersModN.Element, rhs: IntegersModN.Element) -> Bool {
        return IntegersModN.compare(lhs, with: rhs) { $0 <= $1 }
    }

    static func > (lhs: IntegersModN.Element, rhs: IntegersModN.Element) -> Bool {
        return IntegersModN.compare(lhs, with: rhs) { $0 > $1 }
    }

    static func >= (lhs: IntegersModN.Element, rhs: IntegersModN.Element) -> Bool {
        return IntegersModN.compare(lhs, with: rhs) { $0 >= $1 }
    }

    static func % (lhs: IntegersModN.Element, mod: IntegersModN.Element) -> IntegersModN.Element {
        return IntegersModN.combine(lhs, with: mod) { $0 % $1 }
    }

    static func + (lhs: IntegersModN.Element, rhs: IntegersModN.Element) -> IntegersModN.Element {
        return IntegersModN.combine(lhs, with: rhs) { $0 + $1 }
    }

    static func - (lhs: IntegersModN.Element, rhs: IntegersModN.Element) -> IntegersModN.Element {
        return IntegersModN.combine(lhs, with: rhs) { $0 - $1 }
    }
}

private extension IntegersModN {
    static func compare(
        _ lhs: IntegersModN.Element,
        with rhs: IntegersModN.Element,
        _ comparison: (IntegersModN.Element.Value, IntegersModN.Element.Value) -> Bool
    ) -> Bool {
        return comparison(lhs.value, rhs.value)
    }

    static func combine(
        _ lhs: IntegersModN.Element,
        with rhs: IntegersModN.Element,
        _ combine: (IntegersModN.Element.Value, IntegersModN.Element.Value) -> IntegersModN.Element.Value
    ) -> IntegersModN.Element {
        let combinedValue = combine(lhs.value, rhs.value)
        return Element(combinedValue, in: lhs.inGroup)
    }
}

// MARK: Group
public extension IntegersModN {
    
    var identity: Element { return Element(0, in: self) }
 
    func isElementInGroup(_ element: Element) -> Bool {
        // Iff *strictly* less
        return element.value < order
    }
    
    func inverse(of element: Element) -> Element {
        return modN { Element(order - element.value, in: self) }
    }
    
    func operation(_ lhs: Element, _ rhs: Element) -> Element {
        return modN { lhs + rhs }
    }
}

// MARK: - CyclicGroup
public extension IntegersModN {
    var generator: Element { return Element(1, in: self) }
    
    // Default naive implementation of a generate function
    ///
    /// - Parameter power: The number of times to perform the group operation on the `generator` (`G`) element
    /// - Returns: Returns the element G^power
    func generate(power: Int) -> Element {
        return modN { Element(power, in: self) }
    }
}
