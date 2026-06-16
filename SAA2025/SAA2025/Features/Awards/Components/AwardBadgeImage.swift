//
//  AwardBadgeImage.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardBadgeImage

/// Round award-badge graphic shown at the top of the Award Information Block.
/// Pulls the imageset name (e.g. `AwardBadgeBG`) from the bound `Award`.
// mm:6885:10483 — mms_C2.1.3 award image
struct AwardBadgeImage: View {

    let assetName: String

    @EnvironmentObject private var localizer: Localizer

    /// Optional award title — when no PNG matches `assetName`, the fallback
    /// renders this title inside the gold ring instead.
    let fallbackTitle: String?

    init(assetName: String, fallbackTitle: String? = nil) {
        self.assetName = assetName
        self.fallbackTitle = fallbackTitle
    }

    var body: some View {
        Group {
            if UIImage(named: assetName) != nil {
                Image(assetName)
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        // Shared MM_MEDIA_Award BG has no text baked in —
                        // render the award title over the gold ring.
                        if assetName == Self.sharedBadgeBG, let title = fallbackTitle {
                            Text(title.uppercased())
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color("saaGold"))
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.6)
                                .lineLimit(2)
                                .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 1)
                                .padding(.horizontal, 30)
                        }
                    }
            } else {
                fallback
            }
        }
        .frame(width: 160, height: 160)
        .accessibilityLabel(Text(localizer.t("award.badge.accessibility_label")))
    }

    private static let sharedBadgeBG = "AwardBadgeBG"

    /// Gold ring + uppercase title — a synthesized stand-in until the real
    /// badge asset ships for awards beyond Top Project/Talent/Innovation.
    private var fallback: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0xF4 / 255.0, green: 0xC2 / 255.0, blue: 0x42 / 255.0),
                            Color(red: 0xB6 / 255.0, green: 0x82 / 255.0, blue: 0x10 / 255.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 4
                )

            Text((fallbackTitle ?? assetName).uppercased())
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(Color("saaGold"))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)
                .lineLimit(2)
                .padding(.horizontal, 24)
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0x00/255.0, green: 0x10/255.0, blue: 0x1A/255.0)
            .ignoresSafeArea()
        AwardBadgeImage(assetName: "AwardBadgeBG")
    }
    .environmentObject(Localizer())
}
