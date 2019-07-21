//
//  SymmetricGroupOfIntegers.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-07-15.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

// MARK: SymmetricGroupOfIntegers
public struct SymmetricGroupOfIntegers: FiniteSymmetricGroup {
    public typealias PermutationElement = Int
    public typealias Permutation = OrderedSet<PermutationElement>

    // The `set` contains an ordered set of elements contain in permutations
    public let set: Permutation

    /// The `size` of this finite symmetric group is equivalent to its `order`.
    public init(_ size: PermutationElement) {
        set = Permutation(array: .init(PermutationElement(1)...size))
    }
}

// MARK: FiniteSymmetricGroup
public extension SymmetricGroupOfIntegers {

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
        f fUnknownNotation: Element,
        g gUnknownNotation: Element
    ) -> Element {
        let f = fUnknownNotation.asOneLine()
        let g = gUnknownNotation.asOneLine()

        var resultOnOneLineNotation = Permutation()

        for setElement in set {
            let indexInFOneIndexed = g[SymmetricGroupOfIntegers.toIndex(setElement)]
            let indexInF = SymmetricGroupOfIntegers.toIndex(indexInFOneIndexed)
            let elementInF = f[indexInF]
            resultOnOneLineNotation.append(elementInF)
        }

        return Element(resultOnOneLineNotation)
    }
}

// MARK: Private
private extension SymmetricGroupOfIntegers {
    static func toIndex(_ permutationElement: PermutationElement, shouldSubtractOneBecauseOfZeroIndexing: Bool = true) -> Permutation.Index {
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
public extension SymmetricGroupOfIntegers {
    enum Element: GroupElement, RandomAccessCollection & OrderedSetInitializable & OrderedSetArrayInitializable & ExpressibleByArrayLiteral {
        public typealias OneCycle = Permutation
        public typealias Cycles = OrderedSet<OneCycle>
        public typealias Element = Permutation

        case oneLineNotation(OneCycle)
        case cyclicNotation(Cycles)
    }
}

// MARK: Element Public
public extension SymmetricGroupOfIntegers.Element {

    init(array: [Element]) {
        self = .cyclicNotation(Cycles.init(array: array))
    }

    // MARK: OrderedSetArrayInitializable
    init(orderedSetArray: [OneCycle]) {
        switch orderedSetArray.countedElementsZeroOneTwoAndMany {
        case .one(let single): self.init(single)
        default: self.init(array: orderedSetArray)
        }

    }

    // MARK: OrderedSetInitializable
    init(orderedSet: OneCycle) {
        self = .oneLineNotation(orderedSet)
    }

    // MARK: ExpressibleByArrayLiteral
    init(arrayLiteral elements: Element...) {
        self.init(array: elements)
    }

    init(_ oneCycle: OneCycle) {
        self = .oneLineNotation(oneCycle)
    }

    init(_ cycles: Cycles, ensureCanonicalForm: Bool = true) {
        var cycles = cycles
        if ensureCanonicalForm {
            cycles = SymmetricGroupOfIntegers.Element.toCanonical(cycles: cycles)
        }
        self = .cyclicNotation(cycles)
    }

    // MARK: CustomStringConvertible
    var description: String {
        switch self {
        case .cyclicNotation(let cycles):
            return """
            CyclicNotation(\(cycles.description))
            """
        case .oneLineNotation(let cycle):
            return """
            OneLineNotation(\(cycle.description))
            """
        }
    }

    // MARK: RandomAccessCollection
    var startIndex: Int { return underlyingCycles.contents.startIndex }
    var endIndex: Int { return underlyingCycles.contents.endIndex }
    subscript(index: Int) -> Element {
        return underlyingCycles.contents[index]
    }
}

// MARK: Notation Conversion
public extension SymmetricGroupOfIntegers.Element {

    func onOneLineNotation() -> SymmetricGroupOfIntegers.Element {
        return SymmetricGroupOfIntegers.Element.oneLineNotation(asOneLine())
    }

    func onCyclicNotation() -> SymmetricGroupOfIntegers.Element {
        return SymmetricGroupOfIntegers.Element.cyclicNotation(asCycles())
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
    func asOneLine() -> OneCycle {

        switch self {
        case .oneLineNotation(let cycle): return cycle
        case .cyclicNotation(let cycles):
            var dictionary = [SymmetricGroupOfIntegers.PermutationElement: SymmetricGroupOfIntegers.PermutationElement]()

            for cycle in cycles {
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
            return OneCycle(array: dictionary.sorted(by: { $0.key < $1.key }).map { $0.value })
        }
    }

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
    func asCycles() -> Cycles {

        switch self {
        case .cyclicNotation(let cycles): return cycles
        case .oneLineNotation(let cycle):

            var onCyclicNotation = Cycles()
            for permutationElement in cycle {
                guard !onCyclicNotation.contains(permutationElement: permutationElement) else { continue }
                var currentCycle: OneCycle! = .init(single: permutationElement)
                while currentCycle != nil {
                    let nextIndex = SymmetricGroupOfIntegers.toIndex(permutationElement)
                    let nextElement = cycle[nextIndex]
                    if currentCycle.contains(nextElement) {
                        // close cycle and continue with next
                        onCyclicNotation.append(currentCycle)
                        currentCycle = nil
                    } else {
                        currentCycle.append(nextElement)
                    }
                }
            }
            return SymmetricGroupOfIntegers.Element.toCanonical(cycles: onCyclicNotation)
        }
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
    static func toCanonical(cycles: Cycles) -> Cycles {
        return Cycles(array:
            cycles.map { cycle in
                assert(!cycle.isEmpty)
                return OneCycle(array: cycle.rotatedSoThatLargestElementIsFirst())
            }.sorted(by: { $0.first! < $1.first! })
        )
    }
}

// MARK: Element Private
private extension SymmetricGroupOfIntegers.Element {
    var underlyingCycles: Cycles {
        switch self {
        case .cyclicNotation(let cycles): return cycles
        case .oneLineNotation(let cycle): return Cycles(single: cycle)
        }
    }
}
