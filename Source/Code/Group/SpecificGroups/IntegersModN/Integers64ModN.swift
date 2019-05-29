//
//  Integers64ModN.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-05-29.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

extension Int64: ModularElement {}

public struct Integers64ModN: FiniteCyclicGroup, ModularGroup {
    public typealias Element = Int64
    public let modulus: Element
    
    public init(n modulus: Element) {
        self.modulus = modulus
    }
}

// MARK: - Group
public extension Integers64ModN {
    
    var identity: Element { return 0 }
 
    func isElementInGroup(_ value: Element) -> Bool {
        // Iff *strictly* less
        return value < modulus
    }
    
    func inverse(of element: Element) -> Element {
        return modN { modulus - element }
    }
    
    func operation(_ lhs: Element, _ rhs: Element) -> Element {
        return modN { lhs + rhs }
    }
}

// MARK: - CyclicGroup
public extension Integers64ModN {
    var generator: Element { return 1 }
    
    // Default naive implementation of a generate function
    ///
    /// - Parameter power: The number of times to perform the group operation on the `generator` (`G`) element
    /// - Returns: Returns the element G^power
    func generate(power: Int) -> Element {
        return modN { Element(power) }
    }
}
