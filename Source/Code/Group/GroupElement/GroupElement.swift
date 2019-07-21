//
//  GroupElement.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-07-21.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public protocol GroupElement: Equatable, CustomStringConvertible where InGroup.Element == Self {
    associatedtype InGroup: Group
    var inGroup: InGroup { get }
}


public extension GroupElement {
    static func * (lhs: Self, rhs: Self) -> Self {
        assert(lhs.inGroup == rhs.inGroup)
        let group = lhs.inGroup
        return group.operation(lhs, rhs)
    }
}
