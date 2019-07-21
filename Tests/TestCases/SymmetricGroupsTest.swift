//
//  SymmetricGroupsTest.swift
//  CyonCryptoSystemTests
//
//  Created by Alexander Cyon on 2019-07-17.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import XCTest
@testable import CyonCryptoSystem

private typealias S = SymmetricGroupOfIntegers

class SymmetricGroupsTest: XCTestCase {

    private let S5 = S(5)

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
    }

    func testElementNoInGroup() {
        XCTAssertFalse(
            S5.isElementInGroup(S5.oneLine([1, 2, 3, 4, 5, 6]))
        )
    }
    func testInverseOfSymmetricGroup() {
        let f = S5.oneLine([3, 2, 1, 5, 4])

        // `f` in reversed order
        let expectedInverse = S5.oneLine([4, 5, 1, 2, 3])

        let inverse = S5.inverse(of: f)
        XCTAssertEqual(inverse, expectedInverse)
    }

    func testFunctionCompositionOnOneLineNotation() {
        let f = S5.oneLine([3, 2, 1, 5, 4])
        let g = S5.oneLine([2, 5, 4, 3, 1])
        let f_o_g = S5.functionComposition(f: f, g: g)
        XCTAssertEqual(f_o_g, S5.oneLine([2, 4, 5, 1, 3]))
        XCTAssertEqual(f_o_g, f * g)
    }

    func testFunctionCompositiononCyclicNotation() {
        let f = S5.cyclic([[1, 3], [4, 5], [2]])
        let g = S5.cyclic([[1, 2, 5], [3, 4]])
        let f_o_g = S5.functionComposition(f: f, g: g)
        XCTAssertEqual(f_o_g, S5.oneLine([2, 4, 5, 1, 3]))
    }

    func testFunctionCompositionWithIdentityResultsInElement() {
        let f = S5.oneLine([3, 2, 1, 5, 4])
        let f_o_g = S5.functionComposition(f: f, g: S5.identity)
        XCTAssertEqual(f_o_g, f)
    }


    // MARK: Notation Conversion
    func testOnOneLineNotation() {
        let cycle = S5.cyclic([[2], [3, 1], [5, 4]])

        let oneLine = S5.oneLine([3, 2, 1, 5, 4])

        XCTAssertEqual(
            cycle.onOneLineNotation(),
            oneLine
        )

        XCTAssertEqual(
            cycle.onOneLineNotation(),
            oneLine
        )

        XCTAssertEqual(
            oneLine.onCyclicNotation(),
            cycle
        )
    }

    func testCanonicalCycleNotation() {
        XCTAssertEqual(
            S.Element([[1, 3], [4, 5], [2]], inGroup: S5, ensureCanonicalForm: true),
            S.Element([[2], [3, 1], [5, 4]], inGroup: S5, ensureCanonicalForm: false)
        )
    }
}
