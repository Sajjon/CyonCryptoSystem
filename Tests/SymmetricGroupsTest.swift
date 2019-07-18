//
//  SymmetricGroupsTest.swift
//  CyonCryptoSystemTests
//
//  Created by Alexander Cyon on 2019-07-17.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import XCTest
@testable import CyonCryptoSystem

private typealias S = SymmetricGroupOfIntegersOnCyclicNotation<UInt>

class SymmetricGroupsTest: XCTestCase {

    private let S5 = S(5)

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
    }

    func testFunctionCompositionOnOneLineNotation() {
        let f = S.Element(single: [3, 2, 1, 5, 4])
        let g = S.Element(single: [2, 5, 4, 3, 1])
        let f_o_g = S5.functionComposition(f: f, g: g)
        XCTAssertEqual(f_o_g, S.Element(single: [2, 4, 5, 1, 3]))
    }

    func testFunctionCompositionOnCycleNotation() {
        let f = S.Element(array: [[1, 3], [4, 5], [2]])
        let g = S.Element(array: [[1, 2, 5], [3, 4]])
        let f_o_g = S5.functionComposition(f: f, g: g)
        XCTAssertEqual(f_o_g, S.Element(single: [2, 4, 5, 1, 3]))
    }

    func testCollectionCountedElementsZero() {
        let array: [Int] = []
        switch array.countedElementsZeroOneTwoAndMany {
        case .zero: XCTAssert(true)
        default: XCTFail()
        }
    }

    func testCollectionCountedElementsOne() {
        let array: [Int] = [9]
        switch array.countedElementsZeroOneTwoAndMany {
        case .one(let single): XCTAssertEqual(single, 9)
        default: XCTFail()
        }
    }

    func testCollectionCountedElementsTwo() {
        let array: [Int] = [9, 8]
        switch array.countedElementsZeroOneTwoAndMany {
        case .two(let first, let secondAndLast):
            XCTAssertEqual(first, 9)
            XCTAssertEqual(secondAndLast, 8)
        default: XCTFail()
        }
    }

    func testCollectionCountedElementsThree() {
        let array: [Int] = [9, 8, 7]
        switch array.countedElementsZeroOneTwoAndMany {
        case .many(let first, let second, let last):
            XCTAssertEqual(first, 9)
            XCTAssertEqual(second, 8)
            XCTAssertEqual(last, 7)
        default: XCTFail()
        }
    }

    func testCollectionCountedElementsFour() {
        let array: [Int] = [7, 6, 5, 4]
        switch array.countedElementsZeroOneTwoAndMany {
        case .many(let first, let second, let last):
            XCTAssertEqual(first, 7)
            XCTAssertEqual(second, 6)
            XCTAssertEqual(last, 4)
        default: XCTFail()
        }
    }

    func testSlidingWindowEmpty() {
        func doTest(windowSize: Int) {
            let array = [Int]()
            XCTAssertEqual(array.slidingWindow(length: windowSize).count, 0)
        }
        doTest(windowSize: 0)
        doTest(windowSize: 1)
        doTest(windowSize: 2)
    }

    func testSlidingWindowSingleElement() {
        func doTest(windowSize: Int, expectedNumberOfWindows: Int) {
            let array: [Int] = [3]
            XCTAssertEqual(array.slidingWindow(length: windowSize).count, expectedNumberOfWindows)
        }
        doTest(windowSize: 0, expectedNumberOfWindows: 0)
        doTest(windowSize: 1, expectedNumberOfWindows: 0)
        doTest(windowSize: 2, expectedNumberOfWindows: 0)
    }

    func testSlidingWindowArrayOfTwoElements() {
        func doTest(windowSize: Int, expectedNumberOfWindows: Int) {
            let array: [Int] = [9, 8]
            XCTAssertEqual(array.slidingWindow(length: windowSize).count, expectedNumberOfWindows)
        }
        doTest(windowSize: 1, expectedNumberOfWindows: 0)
        doTest(windowSize: 2, expectedNumberOfWindows: 1)
        doTest(windowSize: 3, expectedNumberOfWindows: 0)
    }

    func testSlidingWindowArrayOfFourElements() {
        func doTest(windowSize: Int, expectedWindows: [[Int]]) {
            let array = [9, 8, 7, 6]
            doTestMany(windowSize: windowSize, array: array, expectedWindows: expectedWindows)
        }
        doTest(windowSize: 2, expectedWindows: [[9, 8], [8, 7], [7, 6]])
        doTest(windowSize: 3, expectedWindows: [[9, 8, 7], [8, 7, 6]])
    }

    private func doTestMany(windowSize: Int, array: [Int], expectedWindows: [[Int]]) {
        let windows: [[Int]] = array.slidingWindow(length: windowSize).map { Array($0) }
        print(windows)
        XCTAssertEqual(windows.count, expectedWindows.count)
        for index in 0..<expectedWindows.count {
            let actual: [Int] = windows[index]
            let expected: [Int] = expectedWindows[index]
            XCTAssertEqual(actual, expected)
        }
    }

    func testSlidingWindowArrayOf10Elements() {
        func doTest(windowSize: Int, expectedWindows: [[Int]]) {
            let array = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
            doTestMany(windowSize: windowSize, array: array, expectedWindows: expectedWindows)
        }
        doTest(windowSize: 4, expectedWindows: [
            [9, 8, 7, 6],
            [8, 7, 6, 5],
            [7, 6, 5, 4],
            [6, 5, 4, 3],
            [5, 4, 3, 2],
            [4, 3, 2, 1],
            [3, 2, 1, 0]
        ])
    }

    func testOnOneLineNotation() {
        // cycle: (1 3)(4 5)(2) <=> (1 3)(4 5)
        // one-line (3 2 1 5 4)
        let cycle = S.Element(array: [[1, 3], [4, 5], [2]])
        XCTAssertEqual(
            S5.toOneLine(from: cycle),
            S.Permutation(array: [3, 2, 1, 5, 4])
        )

    }

}
