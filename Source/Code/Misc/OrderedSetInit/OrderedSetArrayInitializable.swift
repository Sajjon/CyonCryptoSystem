//
//  OrderedSetArrayInitializable.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-07-21.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public protocol OrderedSetArrayInitializable {
    associatedtype TypeOfOrderedSet: OrderedSetType
    init(orderedSetArray: [TypeOfOrderedSet])
}

public extension OrderedSetArrayInitializable where Self: OrderedSetType, Self.TypeOfOrderedSet == Self.Element {
    init(orderedSetArray: [TypeOfOrderedSet]) {
        self.init(array: orderedSetArray)
    }
}
