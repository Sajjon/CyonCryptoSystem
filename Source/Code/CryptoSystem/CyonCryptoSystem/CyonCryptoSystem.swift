//
//  CyonCryptoSystem.swift
//  CyonCryptoSystem
//
//  Created by Alexander Cyon on 2019-07-21.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public struct CyonCryptoSystem: CryptoSystem {

    public typealias GroupUsed = SymmetricGroupOfIntegers
}

// MARK: CryptoSystem
public extension CyonCryptoSystem {
    func generateKeyPair() -> KeyPair { KeyGenerator().generateKeyPair() }

    func sign(message: Message, withKey privateKey: PrivateKey, scheme: SignatureScheme) -> Signature {
        MessageSigner().sign(message: message, withKey: privateKey, scheme: scheme)
    }

    func verifyThat(publicKey: PublicKey, signingMessage message: Message, indeedResultsInSignature signature: Signature) -> Bool {
        SignatureVerifier().verifyThat(publicKey: publicKey, signingMessage: message, indeedResultsInSignature: signature)
    }
}

// MARK: KeyGenerator
public extension CyonCryptoSystem {
    struct KeyGenerator: KeyGenerating {

    }
}

public extension CyonCryptoSystem.KeyGenerator {
    func generateKeyPair() -> KeyPair {
        implementMe
    }
}

// MARK: MessageSigner
public extension CyonCryptoSystem {
    struct MessageSigner: MessageSigning {

    }
}

public extension CyonCryptoSystem.MessageSigner {
    func sign(message: Message, withKey privateKey: PrivateKey, scheme: SignatureScheme) -> Signature {
        implementMe
    }
}


// MARK: SignatureVerifier
public extension CyonCryptoSystem {
    struct SignatureVerifier: SignatureVerifying {

    }
}

public extension CyonCryptoSystem.SignatureVerifier {
    func verifyThat(publicKey: PublicKey, signingMessage message: Message, indeedResultsInSignature signature: Signature) -> Bool {
        implementMe
    }
}
