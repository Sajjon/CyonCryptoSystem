//
//  S16Tests.swift
//  CyonCryptoSystemTests
//
//  Created by Alexander Cyon on 2019-07-22.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import XCTest
@testable import CyonCryptoSystem

/// |S| = 16 => 16! elements => log2(16!) bits  => 24 bits security. Well dats bad, but enough for testing. Ought to use S44 => 267 bits security at least. If one wants to use a binary number as size, S64 yields 720 bits of security.
private let S16 = SymmetricGroupOfIntegers(oneThrough: 16)
private let S5 = SymmetricGroupOfIntegers(oneThrough: 5)
private let S4 = SymmetricGroupOfIntegers(oneThrough: 4)
private let S3 = SymmetricGroupOfIntegers(oneThrough: 3)
private let S2 = SymmetricGroupOfIntegers(oneThrough: 2)

func pow(_ x: Int, _ y: Int) -> Int {
  var result = 1
  for _ in 0..<y {
    result *= x
  }
  return result
}

private extension SymmetricGroupOfIntegers.Element {

    /// For any permutation (element) `X ∈ SN = { x1, x2, ..., xn-1, xn }`
    /// this function, `f(X) -> a, a ∈ ℕ `, is defined as:
    /// `(x{1}m^2 - x{2}m) + (x{3}m^2 - x{4}m) + ... + (x{n-1}m^2 - x{n}m)` where if order is odd, `(x{n-1}m^2 - x{n}m)` results in just `(x{n}m^2)` instead.
    /// where `m = (x{1}^2 - x{2}) + (x{3}^2 - x{4}) + ... + (x{n-1}^2 - x{n})`
    var publicKeyInteger: Int {
        let permutation = self.asOneLine()
        var result: Int = 0

        func combine(operation: (Int, Int, Int) -> Int) -> Int {
            return permutation.enumerated().reduce(0, { (acculumated, next) -> Int in
                let nextElement = next.element
                return operation(next.offset, acculumated, nextElement)
            })
        }

        let magicNumber = combine { offset, accumulated, number -> Int in
            if offset % 2 == 0 {
                return accumulated - number
            } else {
                return accumulated + pow(number, 2)
            }
        }

        return combine { offset, accumulated, number -> Int in
            if offset % 2 == 0 {
                return accumulated - number*magicNumber
            } else {
                return accumulated + number*pow(magicNumber, 2)
            }
        }
    }

    static func randomElement(inGroup group: SymmetricGroupOfIntegers) -> SymmetricGroupOfIntegers.Element {
        let order = group.order
        guard order < UInt8.max else { orderLargerThan255NotSupported }
        var permutation = SymmetricGroupOfIntegers.Permutation()
        while permutation.count < order {
            permutation.append(Int.random(in: 1...order))
        }
        return SymmetricGroupOfIntegers.Element(permutation, inGroup: group)
    }
}

private var orderLargerThan255NotSupported: Never {
    fatalError("using 8 bit ints as permutation element, thus order cannot be larger than 255, since the permutation element 256 would not fit in an 8 bit int.")
}

extension SymmetricGroupOfIntegers {

    func randomElement() -> SymmetricGroupOfIntegers.Element {
        return .randomElement(inGroup: self)
    }
}

extension Data {
    static func secureRandomGenerate(byteCount: Int) -> Data {
        var bytes = [UInt8](repeating: 0, count: byteCount)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)

        guard status == errSecSuccess else {
            fatalError("Error: \(status)")
        }

        return Data(bytes)
    }
}

class S16Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testGenerateRandom() {
        for _ in 0...100 {
            let element = S16.randomElement()
            print(element)
            XCTAssertTrue(S16.isElementInGroup(element))
        }
    }

    func testMagicS2() {
        let oneTwo = S2.oneLine([1, 2])
        let twoOne = S2.oneLine([2, 1])
    }

    func testMagic() {
        /// some randomly generated element of S16
        let element = S16.oneLine([13, 2, 10, 3, 7, 11, 9, 4, 1, 8, 6, 5, 15, 16, 14, 12])
        XCTAssertEqual(element.publicKeyInteger, 12)
    }

}

/// ceil(log2(n!))
private let lookupTableForLog2Factorial = [
    0: 0,
    1: 0,
    2: 1,
    3: 3,
    4: 5,
    5: 7,
    6: 10,
    7: 13,
    8: 16,
    9: 19,
    10: 22,
    11: 26,
    12: 29,
    13: 33,
    14: 37,
    15: 41,
    16: 45,
    17: 49,
    18: 53,
    19: 57,
    20: 62,
    21: 66,
    22: 70,
    23: 75,
    24: 80,
    25: 84,
    26: 89,
    27: 94,
    28: 98,
    29: 103,
    30: 108,
    31: 113,
    32: 118,
    33: 123,
    34: 128,
    35: 133,
    36: 139,
    37: 144,
    38: 149,
    39: 154,
    40: 160,
    41: 165,
    42: 170,
    43: 176,
    44: 181,
    45: 187,
    46: 192,
    47: 198,
    48: 203,
    49: 209,
    50: 215,
    51: 220,
    52: 226,
    53: 232,
    54: 238,
    55: 243,
    56: 249,
    57: 255,
    58: 261,
    59: 267,
    60: 273,
    61: 279,
    62: 285,
    63: 290,
    64: 296,
    65: 303,
    66: 309,
    67: 315,
    68: 321,
    69: 327,
    70: 333,
    71: 339,
    72: 345,
    73: 351,
    74: 358,
    75: 364,
    76: 370,
    77: 376,
    78: 383,
    79: 389,
    80: 395,
    81: 402,
    82: 408,
    83: 414,
    84: 421,
    85: 427,
    86: 434,
    87: 440,
    88: 447,
    89: 453,
    90: 459,
    91: 466,
    92: 473,
    93: 479,
    94: 486,
    95: 492,
    96: 499,
    97: 505,
    98: 512,
    99: 519
]

/// ceil( log2(n!) / 8)
private let lookupTableForLog2FactorialOctets = [
    0: 0,
    1: 0,
    2: 1,
    3: 1,
    4: 1,
    5: 1,
    6: 2,
    7: 2,
    8: 2,
    9: 3,
    10: 3,
    11: 4,
    12: 4,
    13: 5,
    14: 5,
    15: 6,
    16: 6,
    17: 7,
    18: 7,
    19: 8,
    20: 8,
    21: 9,
    22: 9,
    23: 10,
    24: 10,
    25: 11,
    26: 12,
    27: 12,
    28: 13,
    29: 13,
    30: 14,
    31: 15,
    32: 15,
    33: 16,
    34: 16,
    35: 17,
    36: 18,
    37: 18,
    38: 19,
    39: 20,
    40: 20,
    41: 21,
    42: 22,
    43: 22,
    44: 23,
    45: 24,
    46: 24,
    47: 25,
    48: 26,
    49: 27,
    50: 27,
    51: 28,
    52: 29,
    53: 29,
    54: 30,
    55: 31,
    56: 32,
    57: 32,
    58: 33,
    59: 34,
    60: 35,
    61: 35,
    62: 36,
    63: 37,
    64: 37,
    65: 38,
    66: 39,
    67: 40,
    68: 41,
    69: 41,
    70: 42,
    71: 43,
    72: 44,
    73: 44,
    74: 45,
    75: 46,
    76: 47,
    77: 47,
    78: 48,
    79: 49,
    80: 50,
    81: 51,
    82: 51,
    83: 52,
    84: 53,
    85: 54,
    86: 55,
    87: 55,
    88: 56,
    89: 57,
    90: 58,
    91: 59,
    92: 60,
    93: 60,
    94: 61,
    95: 62,
    96: 63,
    97: 64,
    98: 64,
    99: 65
]
