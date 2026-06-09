//
//  TokenStore.swift
//  SAA2025
//
//  Created by pham.van.thinh on 8/6/26.
//

import Foundation
import Combine

// MARK: - TokenStore

/// Persists the auth token to UserDefaults.
/// NOTE: UserDefaults is used as a stub. Migrate to Keychain for production.
final class TokenStore: ObservableObject {

    private let key = "auth.token"

    @Published private(set) var token: String?

    init() {
        restore()
    }

    // MARK: - Public API

    func save(_ token: String) {
        #if DEBUG
        // Stub: UserDefaults is NOT production-safe for tokens. Migrate to Keychain
        // before swapping FakeAuthService for a real OAuth token.
        print("[TokenStore] WARNING: saving token to UserDefaults — not production-safe")
        #endif
        self.token = token
        UserDefaults.standard.set(token, forKey: key)
    }

    func clear() {
        token = nil
        UserDefaults.standard.removeObject(forKey: key)
    }

    // MARK: - Private

    private func restore() {
        token = UserDefaults.standard.string(forKey: key)
    }
}
