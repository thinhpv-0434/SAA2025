//
//  NotFoundView.swift
//  SAA2025
//
//  Screen: [iOS] Not Found — sn2mdavs1a
//  Design: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/sn2mdavs1a
//

import SwiftUI

// MARK: - NotFoundView

/// 404 fallback shown for missing resources / unreachable deep links.
/// Layout: chevron-back top bar, gold "NOT FOUND" header + subtitle,
/// composed "404 robot" illustration, divider, and a gold
/// "Go back to Home" CTA that pops the navigation stack.
// mm:6885:9448 — [iOS] Not Found
struct NotFoundView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizer: Localizer

    private static let dividerColor = Color.white.opacity(0.20)
    private static let buttonColor = Color(red: 0xFA / 255.0, green: 0xE6 / 255.0, blue: 0x86 / 255.0)

    var body: some View {
        ZStack(alignment: .top) {
            AwardsBackground()

            VStack(spacing: 0) {
                topBar

                Spacer(minLength: 12)

                header

                Spacer(minLength: 24)

                NotFoundIllustration()

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

    private var header: some View {
        VStack(spacing: 14) {
            Text(localizer.t("not_found.title"))
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(Color("saaGold"))
                .kerning(1.0)

            Rectangle()
                .fill(Self.dividerColor)
                .frame(height: 1)
                .padding(.horizontal, 24)

            Text(localizer.t("not_found.subtitle"))
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }

    private var goBackButton: some View {
        Button(action: { dismiss() }) {
            Text(localizer.t("access_denied.btn.go_home"))
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(red: 0x1A / 255.0, green: 0x14 / 255.0, blue: 0x0A / 255.0))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Self.buttonColor)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack { NotFoundView() }
        .environmentObject(Localizer())
}
