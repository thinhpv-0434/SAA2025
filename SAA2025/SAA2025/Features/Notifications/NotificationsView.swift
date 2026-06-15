//
//  NotificationsView.swift
//  SAA2025
//
//  Created by pham.van.thinh on 9/6/26.
//

import SwiftUI

struct NotificationsView: View {

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        VStack(spacing: 12) {
            Text(localizer.t("notifications.title"))
                .font(.title2.bold())
            Text(localizer.t("stub.coming_soon"))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(localizer.t("notifications.nav.title"))
    }
}

#Preview {
    NavigationStack { NotificationsView() }
        .environmentObject(Localizer())
}
