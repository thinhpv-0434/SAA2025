//
//  AppRoot.swift
//  SAA2025
//
//  Created by pham.van.thinh on 8/6/26.
//

import SwiftUI

// MARK: - AppRoot

/// Root entry point that routes between LoginView and MainTabView
/// based on whether a token is present in TokenStore.
struct AppRoot: View {

    @StateObject private var tokenStore = TokenStore()
    @StateObject private var localizer = Localizer()
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            if tokenStore.token != nil {
                MainTabView()
                    .environmentObject(tokenStore)
                    .environmentObject(coordinator)
            } else {
                LoginView(tokenStore: tokenStore)
            }
        }
        .environmentObject(localizer)
        .animation(.easeInOut(duration: 0.3), value: tokenStore.token)
    }
}

#Preview {
    AppRoot()
}
