//
//  ModularGroup.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-05-29.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public protocol ModularGroup: FiniteGroup {
    var modulus: (Self, Element) -> Element { get }
}

// MARK: - Public
public extension ModularGroup where Element: ModularElement {
    func modN(_ combineElements: () -> Element) -> Element {
        return modulus(self, combineElements())
    }
}

public protocol ModularElement: GroupElement {
    static func % (lhs: Self, mod: Self) -> Self
}
