//
//  OrderedSetInitializable.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-07-21.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public protocol OrderedSetInitializable {
    associatedtype TypeOfOrderedSet: OrderedSetType
    init(orderedSet: TypeOfOrderedSet)
}

public extension OrderedSetInitializable where Self: OrderedSetType, Self.TypeOfOrderedSet == Self.Element {
    init(orderedSet: TypeOfOrderedSet) {
        self.init(single: orderedSet)
    }
}
