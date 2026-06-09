//
//  HomeView.swift
//  SAA2025
//
//  Created by pham.van.thinh on 8/6/26.
//

import SwiftUI

// MARK: - HomeView (Stub)

/// Placeholder home screen. Replace with real dashboard in a follow-up task.
struct HomeView: View {

    @EnvironmentObject private var tokenStore: TokenStore

    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to SAA 2025")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Button("Logout") {
                tokenStore.clear()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    HomeView()
        .environmentObject(TokenStore())
}
