//
//  AppRoot.swift
//  SAA2025
//
//  Created by pham.van.thinh on 8/6/26.
//

import SwiftUI

// MARK: - AppRoot

/// Root entry point that routes between LoginView and HomeView
/// based on whether a token is present in TokenStore.
struct AppRoot: View {

    @StateObject private var tokenStore = TokenStore()

    var body: some View {
        Group {
            if tokenStore.token != nil {
                HomeView()
                    .environmentObject(tokenStore)
            } else {
                LoginView(tokenStore: tokenStore)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: tokenStore.token)
    }
}

#Preview {
    AppRoot()
}
