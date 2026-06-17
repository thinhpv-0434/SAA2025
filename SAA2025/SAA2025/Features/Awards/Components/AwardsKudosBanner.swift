//
//  AwardsKudosBanner.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardsKudosBanner

/// Decorative Kudos branding strip shown at the top of the Awards tab.
/// Distinct from `Features/Home/Components/KudosBanner.swift` (which is a raster
/// graphic) — this variant is the wordmark composition seen on screen
/// `[iOS] Award_Top project` and shares the Montserrat-medium gold subtext +
/// fire-icon + KUDOS wordmark used elsewhere in the Awards/Kudos flow.
// mm:6885:10436 — mms_A_KV Kudos
struct AwardsKudosBanner: View {

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        VStack(spacing: 6) {
            // Subtext
            Text(localizer.t("kudos.hero.tagline"))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("saaGold"))
                .multilineTextAlignment(.center)

            // Logo row — fire icon + KUDOS wordmark
            HStack(spacing: 8) {
                Image("KudosBannerLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 52)
                    .accessibilityLabel(Text(localizer.t("kudos.hero.title")))
                    .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00/255.0, green: 0x10/255.0, blue: 0x1A/255.0)
            .ignoresSafeArea()
        AwardsKudosBanner()
    }
    .environmentObject(Localizer())
}
