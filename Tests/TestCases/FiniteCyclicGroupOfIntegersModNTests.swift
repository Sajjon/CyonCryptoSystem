//
//  FiniteCyclicGroupOfIntegersModNTests.swift
//  CyonCryptoSystemTests
//
//  Created by Alexander Cyon on 2019-05-28.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import XCTest
@testable import CyonCryptoSystem


class FiniteCyclicGroupOfIntegersModNTests: XCTestCase {

    private let z5 = IntegersModN(n: 5)
    private lazy var zero = z5.element(0)
    private lazy var one = z5.element(1)
    private lazy var two = z5.element(2)
    private lazy var three = z5.element(3)
    private lazy var four = z5.element(4)

    func testIdentityIs0() {
        XCTAssertEqual(z5.identity, zero)
    }

    func testSymmetricGroup() {
        
    }

    
    func testInverseOfZ5() {
        XCTAssertEqual(z5.inverse(of: one), four)
        XCTAssertEqual(z5.inverse(of: two), three)
        XCTAssertEqual(z5.inverse(of: three), two)
        XCTAssertEqual(z5.inverse(of: four), one)
    }
    
    func testOrder() {
        XCTAssertEqual(z5.order, 5)
    }
    
    func testIdentityDoesNotChangeElement() {
        func testThatOperationBetween<G>(_ elementInGroup: G.Element, andIdentityInGroupDoesNotChangeTheElement group: G) where G: Group {
            
            XCTAssertEqual(
                group.operation(elementInGroup, group.identity),
                elementInGroup
            )
        }


        testThatOperationBetween(one, andIdentityInGroupDoesNotChangeTheElement: z5)
        testThatOperationBetween(two, andIdentityInGroupDoesNotChangeTheElement: z5)
        testThatOperationBetween(three, andIdentityInGroupDoesNotChangeTheElement: z5)
        testThatOperationBetween(four, andIdentityInGroupDoesNotChangeTheElement: z5)

    }
}

private extension XCTestCase {
    func thatOperationBetween<G>(
        _ a: G.Element,
        andIdentityInGroupDoesNotChangeTheElement group: G
    ) where G: Group {
        
        doTestOperationBetween(a,
                               and: group.identity,
                               in: group,
                               expectedResult: a)
    }
    
    func doTestOperationBetween<G>(
        _ a: G.Element,
        and b: G.Element,
        in group: G,
        expectedResult: G.Element
    ) where G: Group {
        
        XCTAssertTrue(group.isElementInGroup(a))
        XCTAssertTrue(group.isElementInGroup(b))
        
        XCTAssertEqual(
            group.operation(a, b),
            expectedResult
        )
    }
}
