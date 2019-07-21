//
//  CryptoSystem.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-07-21.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public protocol PrivateKey {}

public protocol PublicKey {
    init(privateKey: PrivateKey)
}

public protocol KeyPair {
    var privateKey: PrivateKey { get }
    var publicKey: PublicKey { get }
}

public protocol Message {}
public protocol Signature {
    var producedByScheme: SignatureScheme { get }
}
public protocol SignatureScheme {}

public protocol CryptoSystem {
    associatedtype GroupUsed: Group

    func generateKeyPair() -> KeyPair
    func sign(message: Message, withKey: PrivateKey, scheme: SignatureScheme) -> Signature

    func verifyThat(
        publicKey: PublicKey,
        signingMessage message: Message,
        indeedResultsInSignature signature: Signature
    ) -> Bool
}
