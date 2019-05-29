//
//  CyclicGroup.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-05-29.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public protocol CyclicGroup: Group {
    var generator: Element { get }
    
    /// Calculates the resulting element of performing the group operation `power` times
    /// - Parameter power: The number of times to perform the group operation on the `generator` (`G`) element
    /// - Returns: Returns the element G^power
    func generate(power: Int) -> Element
}
