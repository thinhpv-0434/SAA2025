//
//  AuthService.swift
//  SAA2025
//
//  Created by pham.van.thinh on 8/6/26.
//

import Foundation

// MARK: - Protocol

protocol AuthService {
    func signIn() async throws -> String
}

// MARK: - Fake Implementation (Stub)

/// FakeAuthService: stub OAuth that simulates a 1-second sign-in and returns a fake token.
/// Replace with real Google Sign-In SDK when OAuth integration is ready.
final class FakeAuthService: AuthService {
    func signIn() async throws -> String {
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        return "fake-token-\(UUID().uuidString)"
    }
}
