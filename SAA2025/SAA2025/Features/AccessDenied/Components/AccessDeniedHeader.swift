//
//  AccessDeniedHeader.swift
//  SAA2025
//

import SwiftUI

// MARK: - AccessDeniedHeader

/// Centered title + thin divider + subtitle block at the top of the Access
/// Denied screen.
// mm:6885:9523 — mms_Header
struct AccessDeniedHeader: View {

    @EnvironmentObject private var localizer: Localizer

    private static let divider = Color.white.opacity(0.20)

    var body: some View {
        VStack(spacing: 14) {
            Text(localizer.t("access_denied.title"))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color("saaGold"))
                .multilineTextAlignment(.center)

            Rectangle()
                .fill(Self.divider)
                .frame(height: 1)
                .padding(.horizontal, 24)

            Text(localizer.t("access_denied.subtitle"))
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        AccessDeniedHeader()
            .environmentObject(Localizer())
    }
}
