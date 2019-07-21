//
//  CollectionCountedTests.swift
//  CyonCryptoSystemTests
//
//  Created by Alexander Cyon on 2019-07-21.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import XCTest

class CollectionCountedTests: XCTestCase {
    
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


}
