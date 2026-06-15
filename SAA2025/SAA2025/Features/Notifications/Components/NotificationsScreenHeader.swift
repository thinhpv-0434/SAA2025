//
//  NotificationsScreenHeader.swift
//  SAA2025
//

import SwiftUI

// MARK: - NotificationsScreenHeader

/// Header for the Notifications screen — chevron-back on the left, centered
/// "Notifications" title. Unlike `AwardsScreenHeader`, there is no language
/// picker / search / bell here (you are already inside notifications).
// mm:6885:9374 — TopNavigation
struct NotificationsScreenHeader: View {

    let onBack: () -> Void

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        ZStack {
            Text(localizer.t("notifications.nav.title"))
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)

            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)

                Spacer()
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 4)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        NotificationsScreenHeader(onBack: {})
            .environmentObject(Localizer())
    }
}
