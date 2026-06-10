//
//  AccessDeniedView.swift
//  SAA2025
//
//  Created by pham.van.thinh on 9/6/26.
//

import SwiftUI

struct AccessDeniedView: View {

    @EnvironmentObject private var tokenStore: TokenStore

    var body: some View {
        VStack(spacing: 12) {
            Text("Access Denied")
                .font(.title2.bold())
            Text("Coming soon (stub)")
                .foregroundStyle(.secondary)
            Button("Back to Login") {
                tokenStore.clear()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Access Denied")
    }
}

#Preview {
    NavigationStack { AccessDeniedView() }
        .environmentObject(TokenStore())
}
