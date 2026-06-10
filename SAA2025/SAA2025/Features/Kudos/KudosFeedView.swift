//
//  KudosFeedView.swift
//  SAA2025
//
//  Created by pham.van.thinh on 9/6/26.
//

import SwiftUI

struct KudosFeedView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Kudos Feed")
                .font(.title2.bold())
            Text("Coming soon (stub)")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Kudos Feed")
    }
}

#Preview {
    NavigationStack { KudosFeedView() }
}
