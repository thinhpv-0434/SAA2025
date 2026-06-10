//
//  NotificationsView.swift
//  SAA2025
//
//  Created by pham.van.thinh on 9/6/26.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Notifications")
                .font(.title2.bold())
            Text("Coming soon (stub)")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Notifications")
    }
}

#Preview {
    NavigationStack { NotificationsView() }
}
