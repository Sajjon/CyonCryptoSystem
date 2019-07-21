//
//  ZeroOneTwoAndMany.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-07-18.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public enum ZeroOneTwoAndMany<Element> {
    case zero
    case one(single: Element)
    case two(first: Element, secondAndLast: Element)
    case many(first: Element, second: Element, last: Element)
}
