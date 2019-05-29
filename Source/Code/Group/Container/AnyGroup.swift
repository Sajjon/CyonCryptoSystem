//
//  AnyGroup.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-05-29.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public protocol AnyGroupConvertible {
    
    var anIdentity: Any { get }
    
    func anInverse(of element: Any) -> Any
    func isAnElementInGroup(_ element: Any) -> Bool
    func anOperation(_ lhs: Any, _ rhs: Any) -> Any
}


/// A fully type-erased container for any group
public struct AnyGroup: AnyGroupConvertible {
    
    public let anIdentity: Any
    
    private let _inverse: (Any) -> Any
    private let _inGroup: (Any) -> Bool
    private let _operation: (Any, Any) -> Any
    
    init<Concrete>(_ group: Concrete) where Concrete: Group {
        self.anIdentity = group.identity
        
        func unsafeMap(_ any: Any) -> Concrete.Element {
            guard let element = any as? Concrete.Element else {
                fatalError("Wrong element type")
            }
            return element
        }
        
        self._inverse = { group.inverse(of: unsafeMap($0)) }
        self._inGroup = { group.isElementInGroup(unsafeMap($0)) }
        self._operation = { group.operation(unsafeMap($0), unsafeMap($1)) }
    }
}

public extension AnyGroup {
    func anInverse(of element: Any) -> Any {
        return _inverse(element)
    }
    
    func isAnElementInGroup(_ element: Any) -> Bool {
        return _inGroup(element)
    }
    
    func anOperation(_ lhs: Any, _ rhs: Any) -> Any {
        return _operation(lhs, rhs)
    }
}
