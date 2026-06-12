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

    var body: some View {
        VStack(spacing: 6) {
            // Subtext "Hệ thống ghi nhận và cảm ơn"
            Text("Hệ thống ghi nhận và cảm ơn")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("saaGold"))
                .multilineTextAlignment(.center)

            // Logo row — fire icon + KUDOS wordmark
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(red: 0xFF/255.0, green: 0x6A/255.0, blue: 0x1A/255.0))

                Text("KUDOS")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(Color("saaGold"))
                    .kerning(2)
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
}
