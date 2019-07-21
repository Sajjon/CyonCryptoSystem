//
//  SymmetricGroup.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-05-29.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

extension Int: GroupElement {}
extension Int64: GroupElement {}

extension UInt8: GroupElement {}
extension UInt: GroupElement {}

extension Array: GroupElement where Element: Equatable {}
extension Set: GroupElement {}
extension OrderedSet: GroupElement where Element: Equatable {}

public protocol FiniteSymmetricGroup:
    FiniteGroup
where
Element: OrderedSetType,
Element.Element == Permutation,
Permutation.Element == PermutationElement
{
    associatedtype PermutationElement: GroupElement
    associatedtype Permutation: OrderedSetType
    var set: Permutation { get }
    func functionComposition(f: Element, g: Element) -> Element
}

public extension FiniteSymmetricGroup {
    var order: Int64 {
        return Int64(set.count)
    }

    func operation(_ lhs: Element, _ rhs: Element) -> Element {
        return functionComposition(f: lhs, g: rhs)
    }

    /// The `identity` of a symmetric group of `n` elements, on cycle notation, is just the single cycle (0, 1, 2, ..., `n-1`).
    var identity: Element {
        return Element(single: set)
    }

    func isElementInGroup(_ value: Element) -> Bool {
        var setToEnsureEachAtomOnlyUsedOnce = Permutation()
        for foo in value {
            for bar in foo {
                let wasInserted = setToEnsureEachAtomOnlyUsedOnce.append(bar)
                guard wasInserted else { return false }
            }
        }
        return true
    }

    /// Since the identity is the set of elements from 1 to N, where N is the order, i.e. the size of the set, the inverse permutation is the permutation resulting in the set of elements.
    ///
    /// Consider the permutation on One-Line notation: `(3 2 1 5 4)`,  the inverse is the permutation in reversed order, i.e. `(4 5 1 2 3)`:
    ///
    ///     (1 2 3 4 5) ∘ (1 2 3 4 5) = (1 2 3 4 5)
    ///     (3 2 1 5 4) ∘ (4 5 1 2 3) = (1 2 3 4 5)
    ///
    func inverse(of element: Element) -> Element {
        return Element(array: element.map { cycle in
            Permutation(array: cycle.reversed())
        })
    }
}

// MARK: where PermutationElement: Comparable
public extension FiniteSymmetricGroup where PermutationElement: Comparable {

    // Potentially more efficient than naiv implementation
    func isElementInGroup(_ value: Element) -> Bool {
        return set.sorted() == value.flatMap { $0 }.sorted()
    }
}

