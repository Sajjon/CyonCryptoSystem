//
//  SlidingWindowTests.swift
//  CyonCryptoSystemTests
//
//  Created by Alexander Cyon on 2019-07-21.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import XCTest
@testable import CyonCryptoSystem

class SlidingWindowTests: XCTestCase {

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
}

private extension SlidingWindowTests {

    func doTestMany(windowSize: Int, array: [Int], expectedWindows: [[Int]]) {
        let windows: [[Int]] = array.slidingWindow(length: windowSize).map { Array($0) }
        print(windows)
        XCTAssertEqual(windows.count, expectedWindows.count)
        for index in 0..<expectedWindows.count {
            let actual: [Int] = windows[index]
            let expected: [Int] = expectedWindows[index]
            XCTAssertEqual(actual, expected)
        }
    }

}
