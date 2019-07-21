//
//  RotateArrayTests.swift
//  CyonCryptoSystemTests
//
//  Created by Alexander Cyon on 2019-07-21.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import XCTest
@testable import CyonCryptoSystem

class RotateArrayTests: XCTestCase {

    func testRotateArrayEmpty() {
          XCTAssertEqual(
              Array<Int>.init().rotatedSoThatLargestElementIsFirst(),
              Array<Int>.init()
          )
      }

      func testRotateArraySingleElement() {
          XCTAssertEqual(
              Array<Int>.init([1]).rotatedSoThatLargestElementIsFirst(),
              Array<Int>.init([1])
          )
      }

      func testRotateArrayOfThree() {
          XCTAssertEqual([1, 2, 3].rotatedSoThatLargestElementIsFirst(), [3, 1, 2])
      }

      func testRotateArrayOfTen() {
          XCTAssertEqual(
              Array(1...10).shiftedRight(by: 1),
              [10, 1, 2, 3, 4, 5, 6, 7, 8, 9]
          )
          XCTAssertEqual(
              Array(1...10).rotatedSoThatLargestElementIsFirst(),
              [10, 1, 2, 3, 4, 5, 6, 7, 8, 9]
          )
          XCTAssertEqual(
              Array(1...10).rotatedSoThatLargestElementIsFirst(),
              Array(1...10).shiftedRight(by: 1)
          )
      }

}
