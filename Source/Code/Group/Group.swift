//
//  Group.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-05-29.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public protocol GroupElement: Equatable, CustomStringConvertible {}

public protocol Group {
    
    /// The type of elements in the group. Must conform to `Equatable`
    associatedtype Element: GroupElement
   
    /// The identity element of the group, e.g. `0` under addition of Integers, or `1` under multiplication of integers.
    var identity: Element { get }
    
    /// Returns inverse of element
    ///
    /// - Parameter element: Element to invert
    /// - Returns: Inverse of `element`
    func inverse(of element: Element) -> Element
    
    
    /// Checks if value is an `element` in the group.
    ///
    /// - Parameter value: Value to check if is an element in the group.
    /// - Returns: returns `true` iff the value is an element in the group
    func isElementInGroup(_ value: Element) -> Bool
    
    
    /// The group operation to be performed between two elements in the group, returning
    /// an element which is also in the group.
    ///
    /// - Parameters:
    ///   - lhs: Element in group
    ///   - rhs: another element in group
    /// - Returns: Element in the group, being the result of this operation
    func operation(_ lhs: Element, _ rhs: Element) -> Element
}
