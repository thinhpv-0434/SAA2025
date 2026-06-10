//
//  ProfileTabView.swift
//  SAA2025
//
//  Created by pham.van.thinh on 9/6/26.
//

import SwiftUI

struct ProfileTabView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Profile Tab")
                .font(.title2.bold())
            Text("Coming soon (stub)")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack { ProfileTabView() }
}
