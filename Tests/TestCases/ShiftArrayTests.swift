//
//  ShiftArrayTests.swift
//  CyonCryptoSystemTests
//
//  Created by Alexander Cyon on 2019-07-21.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import XCTest
@testable import CyonCryptoSystem

class ShiftArrayTests: XCTestCase {

    func testShiftArrayOneToTenRightByOne() {
        XCTAssertEqual(
            Array(1...10).shiftedLeft(by: 1),
            [2, 3, 4, 5, 6, 7, 8, 9, 10, 1]
        )

        XCTAssertNotEqual(
            Array(1...10).shiftedLeft(by: 1),
            Array(1...10).shiftedRight(by: 1)
        )
    }

    func testShiftArrayOneToTenRightBySeven() {
        XCTAssertEqual(
            Array(1...10).shiftedLeft(by: 7),
            [8, 9, 10, 1, 2, 3, 4, 5, 6, 7]
        )

        XCTAssertEqual(
            Array(1...10).shiftedLeft(by: 7),
            Array(1...10).shiftedRight(by: 3)
        )
    }

    func testShiftArrayOneToTenLeftByThree() {
        XCTAssertEqual(
            Array(1...10).shiftedRight(by: 8),
            [3, 4, 5, 6, 7, 8, 9, 10, 1, 2]
        )
    }

}
