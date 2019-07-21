//
//  SymmetricGroupOfIntegers.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-07-15.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public struct SymmetricGroupOfIntegersOnCyclicNotation<PermutationElement>: FiniteSymmetricGroup
    where
PermutationElement: UnsignedInteger & FixedWidthInteger & GroupElement {

    public typealias Permutation = OrderedSet<PermutationElement>

    // The `set` contains an ordered set of elements contain in permutations
    public let set: Permutation

    /// The `size` of this finite symmetric group is equivalent to its `order`.
    public init(_ size: PermutationElement) {
        set = Permutation(array: .init(PermutationElement(1)...size))
    }
}

// MARK: FiniteSymmetricGroup
public extension SymmetricGroupOfIntegersOnCyclicNotation {

    /// Example from: https://en.wikipedia.org/wiki/Symmetric_group#Multiplication
    /// two-line notation:
    ///      f(x): (3 2 1 5 4)
    ///      g(x): (2 5 4 3 1)
    ///      f ∘ g = f(g(x)):
    ///          (1 2 3 4 5) ∘ (1 2 3 4 5)   =      (1 2 3 4 5)
    ///          (3 2 1 5 4)   (2 5 4 3 1)           (2 4 5 1 3)
    ///
    ///      g ∘ f = g(f(x)):
    ///         (1 2 3 4 5)  ∘ (1 2 3 4 5) =      (1 2 3 4 5)
    ///         (2 5 4 3 1)    (3 2 1 5 4)         (4 5 2 1 3 )
    ///
    /// cycle notation:
    ///      f(x): (1 3)(4 5)(2) <=> (1 3)(4 5)
    ///      g(x): (1 2 5)(3 4)
    ///      f ∘ g = f(g(x)):
    ///          (1 3)(4 5) ∘ (1 2 5)(3 4) = (1 2 4)(3 5)
    ///
    func functionComposition(
        f fOnCycleNotation: Element,
        g gOnCycleNotation: Element
    ) -> Element {
        let f = toOneLine(from: fOnCycleNotation)
        let g = toOneLine(from: gOnCycleNotation)
        let fog = functionCompositionUsingOneLineNotation(f: f, g: g)
        return Element(single: fog)
    }

    func functionCompositionUsingOneLineNotation(
        f: Permutation,
        g: Permutation
    ) -> Permutation {
        var product = Permutation()

        for setElement in set {
            let indexInFOneIndexed = g[toIndex(setElement)]
            let indexInF = toIndex(indexInFOneIndexed)
            let elementInF = f[indexInF]
            product.append(elementInF)
        }

        return product
    }
}

// MARK: Notation Conversion
public extension SymmetricGroupOfIntegersOnCyclicNotation {
    /// Transforms the provided  symetric group element on One-Line-Notation into Cycle Notation[1]
    ///
    /// **From:**
    ///
    ///     one-line notation:
    ///         (3 2 1 5 4)
    ///
    /// **Implicitly into:**
    ///
    ///     two-line notation:
    ///         (1 2 3 4 5)
    ///         (3 2 1 5 4)
    ///
    /// **Transformed to:**
    ///
    ///     cycle notation:
    ///         (1 3)(4 5)(2)
    ///
    /// [1]: https://en.wikipedia.org/wiki/Permutation#Cycle_notation
    func toCycleNotation(fromOneLineNotation permutation: Permutation) -> Element {
        var onCycleNotation = Element()
        for permutationElement in permutation {
            guard !onCycleNotation.contains(permutationElement: permutationElement) else { continue }
            var currentCycle: Permutation! = .init(single: permutationElement)
            while currentCycle != nil {
                let nextIndex = toIndex(permutationElement)
                let nextElement = permutation[nextIndex]
                if currentCycle.contains(nextElement) {
                    // close cycle and continue with next
                    onCycleNotation.append(currentCycle)
                    currentCycle = nil
                } else {
                    currentCycle.append(nextElement)
                }
            }
        }
        return toCyclicOnCanonicalForm(element: onCycleNotation)
    }

    /// Returns this symetric group on [One-Line notation][1]
    ///
    ///     cycle notation:
    ///         (1 3)(4 5)(2) <=> (1 3)(4 5)
    ///         (3 1)(2)(4 5) =>
    ///
    ///     two-line notation:
    ///         (1 2 3 4 5)
    ///         (3 2 1 5 4)
    ///
    ///     one-line notation:
    ///         (3 2 1 5 4)
    ///
    /// [1]: https://en.wikipedia.org/wiki/Permutation#One-line_notation
    func toOneLine(from element: Element) -> Permutation {
        guard element.count > 1 else { return element.first! }
        var dictionary = [PermutationElement: PermutationElement]()

        for cycle in element {
            switch cycle.countedElementsZeroOneTwoAndMany {
            case .zero: fatalError("Cycles should never be empty")
            case .one(let single):
                assert(dictionary.updateValue(single, forKey: single) == nil)
            case .two(let first, let secondAndLast):
                assert(dictionary.updateValue(secondAndLast, forKey: first) == nil)
                assert(dictionary.updateValue(first, forKey: secondAndLast) == nil)

            case .many(let first, _, let last):
                for tuple in cycle.slidingWindow(length: 2) {
                    let firstInTuple = tuple.first!
                    let secondInTuple = tuple.last!
                    assert(dictionary.updateValue(secondInTuple, forKey: firstInTuple) == nil)
                }
                // Wrap around
                assert(dictionary.updateValue(first, forKey: last) == nil)

            }
        }
        return Permutation(array: dictionary.sorted(by: { $0.key < $1.key }).map { $0.value })
    }

    /// Returns a permutation on cyclic notation to its [canonical form][1].
    ///
    /// Following these two simple rules:
    /// 1. "in each cycle the largest element is listed first"
    /// 2. "the cycles are sorted in increasing order of their first element"
    ///
    /// Example:
    ///     `(3 1 2)(5 4)(8)(9 7 6)`
    ///
    /// [1]: https://en.wikipedia.org/wiki/Permutation#Canonical_cycle_notation_(a.k.a._standard_form)
    func toCyclicOnCanonicalForm(element: Element) -> Element {
        return Element(array:
            element.map { cycle in
                assert(!cycle.isEmpty)
                return Permutation(array: cycle.rotatedSoThatLargestElementIsFirst())
            }.sorted(by: { $0.first! < $1.first! })
        )
    }
}

// MARK: Private
private extension SymmetricGroupOfIntegersOnCyclicNotation {
    func toIndex(_ permutationElement: PermutationElement, shouldSubtractOneBecauseOfZeroIndexing: Bool = true) -> Permutation.Index {
        guard var index = Permutation.Index(exactly: permutationElement) else {
            fatalError("should be able to create \(Permutation.Index.self) from PermutationElement(\(permutationElement))")
        }
        if shouldSubtractOneBecauseOfZeroIndexing {
            index -= 1
        }
        return index
    }
}

// MARK: Element
public extension SymmetricGroupOfIntegersOnCyclicNotation {
    struct Element: OrderedSetType, ExpressibleByArrayLiteral, GroupElement {

        public typealias Element = Permutation
        private var underlyingSet: OrderedSet<Permutation>
        public init() {
            underlyingSet = OrderedSet<Permutation>()
        }
    }
}

public extension SymmetricGroupOfIntegersOnCyclicNotation.Element {
    init(array: [Element]) {
        self.init()
        for element in array {
            append(element)
        }
    }

    /// Creates an ordered set with the contents of `set`.
    init(set: Set<Element>) {
        self.init()
        for element in set {
            append(element)
        }
    }

    init(arrayLiteral elements: Element...) {
        self.init(array: elements)
    }

    @discardableResult
    mutating func append(_ newElement: Element) -> Bool {
        return underlyingSet.append(newElement)
    }

    func contains(_ member: Element) -> Bool {
        return underlyingSet.contains(member)
    }

    // MARK: RandomAccessCollection
    var startIndex: Int { return underlyingSet.startIndex }
    var endIndex: Int { return underlyingSet.endIndex }
    subscript(index: Int) -> Element {
        return underlyingSet[index]
    }

    // MARK: CustomStringConvertible
    var description: String {
        return underlyingSet.description
    }

    var contents: [Element] {
        return underlyingSet.contents
    }
}
