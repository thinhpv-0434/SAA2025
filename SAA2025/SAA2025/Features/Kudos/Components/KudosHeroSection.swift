//
//  KudosHeroSection.swift
//  SAA2025
//

import SwiftUI

// MARK: - KudosHeroSection

/// Hero section for the Sun*Kudos screen: keyvisual background + nav header +
/// tagline + KUDOS wordmark.
// mm:6885:9059 / mm:6885:9065
struct KudosHeroSection: View {

    var unreadCount: Int = 0
    var onSearch: () -> Void = {}
    var onBell: () -> Void = {}

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // mm:6885:9060 — top nav (SAA logo + language picker + search + bell)
            // Sits over the keyvisual so it scrolls with the hero per design.
            headerRow

            Spacer(minLength: 16)

            // mm:I6885:9064;75:2055 — tagline
            Text(localizer.t("kudos.hero.tagline"))
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white)
                .padding(.bottom, 6)

            // mm:I6885:9064;75:2058 — KUDOS wordmark (single asset containing
            // the red Sun* S-logo + KUDOS lettering; replaces the previous
            // SunBrandSShape + Text composition).
            Image("KudosBannerLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 52)
                .accessibilityLabel(Text(localizer.t("kudos.hero.title")))
                .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, minHeight: 220, alignment: .bottomLeading)
        // No internal background — the parent KudosTabView paints the shared
        // `KudosKeyvisualBackground` so the artwork extends past the hero.
    }

    // MARK: - Header row

    /// SAA logo on the left, language picker + search + bell on the right.
    /// Mirrors the AwardsScreenHeader layout (mm:6885:10434) so the two tabs
    /// share a visual idiom.
    private var headerRow: some View {
        HStack(alignment: .center, spacing: 12) {
            Image("SunAALogo")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 44)

            Spacer()

            LanguagePicker()

            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 32, height: 32)

            ZStack(alignment: .topTrailing) {
                Button(action: onBell) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(width: 32, height: 32)

                if unreadCount > 0 {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: 2, y: -2)
                }
            }
        }
        .padding(.top, 8)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        VStack {
            KudosHeroSection()
            Spacer()
        }
        .environmentObject(Localizer())
    }
}
