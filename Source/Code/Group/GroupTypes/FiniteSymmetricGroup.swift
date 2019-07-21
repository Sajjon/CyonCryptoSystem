//
//  SymmetricGroup.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-05-29.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

// MARK: FiniteSymmetricGroup
public protocol FiniteSymmetricGroup: FiniteGroup where
    Element: RandomAccessCollection,
    // where
    Element.Element == Permutation,
    // where
    Permutation.Element == PermutationElement
{
    associatedtype PermutationElement: CustomStringConvertible
    associatedtype Permutation: OrderedSetType
    var set: Permutation { get }
    func functionComposition(f: Element, g: Element) -> Element
}

// MARK: Default
public extension FiniteSymmetricGroup {
    var order: Int {
        return set.count
    }

    func operation(_ lhs: Element, _ rhs: Element) -> Element {
        return functionComposition(f: lhs, g: rhs)
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
}

// MARK: where PermutationElement: Comparable
public extension FiniteSymmetricGroup where PermutationElement: Comparable {

    // Potentially more efficient than naiv implementation
    func isElementInGroup(_ value: Element) -> Bool {
        return set.sorted() == value.flatMap { $0 }.sorted()
    }
}

