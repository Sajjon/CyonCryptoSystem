//
//  FiniteCyclicGroupOfIntegersModNTests.swift
//  CyonCryptoSystemTests
//
//  Created by Alexander Cyon on 2019-05-28.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import XCTest
@testable import CyonCryptoSystem

private typealias IntegersModN = Integers64ModN

class FiniteCyclicGroupOfIntegersModNTests: XCTestCase {

    private let z3 = IntegersModN(n: 3)
    private let z5 = IntegersModN(n: 5)

    func testIdentityIs0() {
        [z3, z5].forEach {
            XCTAssertEqual($0.identity, 0)
        }
    }
    
    func testInverseOfZ3() {
        XCTAssertEqual(z3.inverse(of: 1), 2)
        XCTAssertEqual(z3.inverse(of: 2), 1)
    }
    
    func testInverseOfZ5() {
        XCTAssertEqual(z5.inverse(of: 1), 4)
        XCTAssertEqual(z5.inverse(of: 2), 3)
        XCTAssertEqual(z5.inverse(of: 3), 2)
        XCTAssertEqual(z5.inverse(of: 4), 1)
    }
    
    func testOrder() {
        XCTAssertEqual(z3.order, 3)
        XCTAssertEqual(z5.order, 5)
    }
    
    func testIdentityDoesNotChangeElement() {
        func testThatOperationBetween<G, Element>(_ elementInGroup: Element, andIdentityInGroupDoesNotChangeTheElement group: G) where G: Group, Element == G.Element {
            
            XCTAssertEqual(
                group.operation(elementInGroup, group.identity),
                elementInGroup
            )
        }
        testThatOperationBetween(1, andIdentityInGroupDoesNotChangeTheElement: z3)
        testThatOperationBetween(2, andIdentityInGroupDoesNotChangeTheElement: z3)

        testThatOperationBetween(1, andIdentityInGroupDoesNotChangeTheElement: z5)
        testThatOperationBetween(2, andIdentityInGroupDoesNotChangeTheElement: z5)
        testThatOperationBetween(3, andIdentityInGroupDoesNotChangeTheElement: z5)
        testThatOperationBetween(4, andIdentityInGroupDoesNotChangeTheElement: z5)

    }
}

private extension XCTestCase {
    func thatOperationBetween<G, Element>(
        _ a: Element,
        andIdentityInGroupDoesNotChangeTheElement group: G
    ) where G: Group, Element == G.Element {
        
        doTestOperationBetween(a,
                               and: group.identity,
                               in: group,
                               expectedResult: a)
    }
    
    func doTestOperationBetween<G, Element>(
        _ a: Element,
        and b: Element,
        in group: G,
        expectedResult: Element
    ) where G: Group, Element == G.Element {
        
        XCTAssertTrue(group.isElementInGroup(a))
        XCTAssertTrue(group.isElementInGroup(b))
        
        XCTAssertEqual(
            group.operation(a, b),
            expectedResult
        )
    }
}
