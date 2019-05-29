//
//  SomeGroup.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-05-29.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

/// Container for some group
public struct SomeGroup<Element: GroupElement>: Group {
    public let identity: Element
    
    private let _inverse: (Element) -> Element
    private let _inGroup: (Element) -> Bool
    private let _operation: (Element, Element) -> Element
    
    init<Concrete>(_ group: Concrete) where Concrete: Group, Concrete.Element == Element {
        self.identity = group.identity
        self._inverse = { group.inverse(of: $0) }
        self._inGroup = { group.isElementInGroup($0) }
        self._operation = { group.operation($0, $1) }
    }
}

public extension SomeGroup {
    func inverse(of element: Element) -> Element {
        return _inverse(element)
    }
    
    func isElementInGroup(_ value: Element) -> Bool {
        return _inGroup(value)
    }
    
    func operation(_ lhs: Element, _ rhs: Element) -> Element {
        return _operation(lhs, rhs)
    }
}
