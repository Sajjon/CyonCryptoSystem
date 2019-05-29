//
//  FiniteGroup.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-05-29.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public protocol FiniteGroup: Group {
    var order: Int64 { get }
}
