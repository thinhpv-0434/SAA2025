//
//  AccessDeniedView.swift
//  SAA2025
//
//  Screen: [iOS] Access denied — k-7zJk2B7s
//  Design: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/k-7zJk2B7s
//

import SwiftUI

// MARK: - AccessDeniedView

/// Permission-denied screen pushed when a service returns 403. Layout:
/// gold "Access Denied" title + subtitle, blocked-screen illustration, and
/// a "Go back to Home" CTA that pops the navigation stack back to whoever
/// pushed us (Home, Awards, etc).
// mm:6885:9490 — [iOS] Access denied
struct AccessDeniedView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizer: Localizer

    private static let dividerColor = Color.white.opacity(0.20)

    var body: some View {
        ZStack(alignment: .top) {
            AwardsBackground()

            VStack(spacing: 0) {
                topBar

                Spacer(minLength: 12)

                AccessDeniedHeader()

                Spacer(minLength: 24)

                AccessDeniedIllustration()

                Spacer(minLength: 24)

                Rectangle()
                    .fill(Self.dividerColor)
                    .frame(height: 1)
                    .padding(.horizontal, 24)

                goBackButton
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

                Spacer()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Top bar (back chevron only)

    private var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(width: 44, height: 44)

            Spacer()
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Go-back CTA

    private var goBackButton: some View {
        Button(action: { dismiss() }) {
            Text(localizer.t("access_denied.btn.go_home"))
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(red: 0x1A / 255.0, green: 0x14 / 255.0, blue: 0x0A / 255.0))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0xFA / 255.0, green: 0xE6 / 255.0, blue: 0x86 / 255.0))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack { AccessDeniedView() }
        .environmentObject(Localizer())
}
