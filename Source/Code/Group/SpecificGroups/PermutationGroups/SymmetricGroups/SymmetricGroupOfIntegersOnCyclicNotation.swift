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
//    public typealias Element = OrderedSet<Permutation>

    public struct Element: OrderedSetType, ExpressibleByArrayLiteral, GroupElement {
        public typealias Element = Permutation
        private var underlyingSet: OrderedSet<Permutation>
        public init() {
            underlyingSet = OrderedSet<Permutation>()
        }
    }

    // The `set` contains an ordered set of elements contain in permutations
    public let set: Permutation

    /// The `size` of this finite symmetric group is equivalent to its `order`.
    public init(_ size: PermutationElement) {
        set = Permutation(array: .init(PermutationElement(1)...size))
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
    public func functionComposition(
        f fOnCycleNotation: Element,
        g gOnCycleNotation: Element
    ) -> Element {

        print("f cyc: \(fOnCycleNotation)")
        print("g cyc: \(gOnCycleNotation)")
        let f = toOneLine(from: fOnCycleNotation)
        let g = toOneLine(from: gOnCycleNotation)
        print("f: \(f)")
        print("g: \(g)")
        var product = Permutation()

        func toIndex(_ permutationElement: PermutationElement, shouldSubtractOneBecauseOfZeroIndexing: Bool = true) -> Permutation.Index {
            guard var index = Permutation.Index(exactly: permutationElement) else {
                fatalError("should be able to create \(Permutation.Index.self) from PermutationElement(\(permutationElement))")
            }
            if shouldSubtractOneBecauseOfZeroIndexing {
                index -= 1
            }
            return index
        }

        for setElement in set {
            let indexInFOneIndexed = g[toIndex(setElement)]
            let indexInF = toIndex(indexInFOneIndexed)
            let elementInF = f[indexInF]
            print("g(\(setElement)): \(indexInFOneIndexed) => f(\(indexInFOneIndexed)): \(elementInF)")
            product.append(elementInF)
        }

        return Element(single: product)
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
    static func toCyclicOnCanonicalForm(from element: Element) -> Element {
//        return Element(array:
//            element.map { cycle in
//                assert(!cycle.isEmpty)
//                return cycle.sorted(by: { $0 > $1 })
//            }.sorted(by: { $0.first! < $1.first! })
//        )
        implementMe
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
}

public extension SymmetricGroupOfIntegersOnCyclicNotation {
    enum Notation {
        case oneLine(Permutation)
        case cycle(Element)
    }
}

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

public enum ZeroOneTwoAndMany<Element> {
    case zero
    case one(single: Element)
    case two(first: Element, secondAndLast: Element)
    case many(first: Element, second: Element, last: Element)
}
