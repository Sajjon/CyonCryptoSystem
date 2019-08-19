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
    public init(oneThrough size: PermutationElement) {
        set = Permutation(array: .init(PermutationElement(1)...size))
    }
}

// MARK: FiniteSymmetricGroup
public extension SymmetricGroupOfIntegers {

    /// The `identity` of a symmetric group of `n` elements, on cycle notation, is just the single cycle (0, 1, 2, ..., `n-1`).
     var identity: Element {
         return Element(set, inGroup: self)
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
        }, inGroup: self)
    }

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

        return Element(resultOnOneLineNotation, inGroup: self)
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
    enum Element: GroupElement, RandomAccessCollection, Equatable {
        public typealias InGroup = SymmetricGroupOfIntegers
        public typealias OneCycle = Permutation
        public typealias Cycles = OrderedSet<OneCycle>
        public typealias Element = Permutation

        case oneLineNotation(OneCycle, inGroup: InGroup)
        case cyclicNotation(Cycles, inGroup: InGroup)
    }

    func oneLine(_ oneCycle: Element.OneCycle) -> Element {
        return Element(oneCycle, inGroup: self)
    }

    func cyclic(_ cycles: Element.Cycles) -> Element {
        return Element(cycles, inGroup: self)
    }
}

// MARK: Element Public
public extension SymmetricGroupOfIntegers.Element {

    var inGroup: InGroup {
        switch self {
        case .cyclicNotation(_, let inGroup): return inGroup
        case .oneLineNotation(_, let inGroup): return inGroup
        }
    }

    init(array: [Element], inGroup: InGroup) {
        self = .cyclicNotation(Cycles.init(array: array), inGroup: inGroup)
    }

    init(_ oneCycle: OneCycle, inGroup: InGroup) {
        self = .oneLineNotation(oneCycle, inGroup: inGroup)
    }

    init(_ cycles: Cycles, inGroup: InGroup, ensureCanonicalForm: Bool = true) {
        var cycles = cycles
        if ensureCanonicalForm {
            cycles = SymmetricGroupOfIntegers.Element.toCanonical(cycles: cycles)
        }
        self = .cyclicNotation(cycles, inGroup: inGroup)
    }

    // MARK: Equatable
    static func == (lhs: SymmetricGroupOfIntegers.Element, rhs: SymmetricGroupOfIntegers.Element) -> Bool {
        guard lhs.inGroup == rhs.inGroup else { return false }
        return lhs.underlyingCycles == rhs.underlyingCycles
    }

    // MARK: CustomStringConvertible
    var description: String {
        switch self {
        case .cyclicNotation(let cycles, _):
            return """
            CyclicNotation(\(cycles.description))
            """
        case .oneLineNotation(let cycle, _):
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
        return SymmetricGroupOfIntegers.Element.oneLineNotation(asOneLine(), inGroup: self.inGroup)
    }

    func onCyclicNotation() -> SymmetricGroupOfIntegers.Element {
        return SymmetricGroupOfIntegers.Element.cyclicNotation(asCycles(), inGroup: self.inGroup)
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
        case .oneLineNotation(let cycle, _): return cycle
        case .cyclicNotation(let cycles, _):
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
        case .cyclicNotation(let cycles, _): return cycles
        case .oneLineNotation(let cycle, _ ):

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
        case .cyclicNotation(let cycles, _): return cycles
        case .oneLineNotation(let cycle, _): return Cycles(single: cycle)
        }
    }
}
