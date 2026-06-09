//
//  LoginViewModel.swift
//  SAA2025
//
//  Created by pham.van.thinh on 8/6/26.
//

import Foundation
import Combine

// MARK: - LoginViewModel

@MainActor
final class LoginViewModel: ObservableObject {

    // MARK: - Published State

    @Published private(set) var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published private(set) var errorMessage: String = ""

    // MARK: - Dependencies

    private let authService: AuthService
    private let tokenStore: TokenStore

    // MARK: - Init

    init(authService: AuthService = FakeAuthService(), tokenStore: TokenStore) {
        self.authService = authService
        self.tokenStore = tokenStore
    }

    // MARK: - Actions

    func signIn() {
        guard !isLoading else { return } // double-tap prevention
        isLoading = true

        Task {
            defer { isLoading = false }
            do {
                let token = try await authService.signIn()
                tokenStore.save(token)
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}
