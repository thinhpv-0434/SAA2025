//
//  KudosHeroSection.swift
//  SAA2025
//

import SwiftUI

// MARK: - KudosHeroSection

/// Hero section for the Sun*Kudos screen: keyvisual background + tagline + KUDOS wordmark.
// mm:6885:9059 / mm:6885:9065
struct KudosHeroSection: View {

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Spacer(minLength: 40)

            // mm:I6885:9064;75:2055 — tagline
            Text(localizer.t("kudos.hero.tagline"))
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white)

            // mm:I6885:9064;75:2058 — KUDOS wordmark
            HStack(alignment: .center, spacing: 10) {
                // mm:I6885:9064;75:2061 — S-logo (Sun* brand mark in red)
                SunBrandSShape()
                    .fill(Color(red: 0xE6 / 255.0, green: 0x4A / 255.0, blue: 0x2C / 255.0))
                    .frame(width: 32, height: 30)

                // mm:I6885:9064;75:2064
                Text(localizer.t("kudos.hero.title"))
                    .font(.system(size: 52, weight: .black))
                    .foregroundColor(.white)
                    .kerning(2)
                    .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, minHeight: 200, alignment: .bottomLeading)
        .background(alignment: .topTrailing) {
            // mm:6885:9061 — MM_MEDIA_Keyvisual BG (reuse Home KeyvisualBG asset)
            Image("KeyvisualBG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0), location: 0.0),
                            .init(color: Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).opacity(0.0), location: 0.6)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        .background(Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0))
        .clipped()
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
