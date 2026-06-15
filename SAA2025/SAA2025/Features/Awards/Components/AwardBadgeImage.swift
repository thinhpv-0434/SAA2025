//
//  AwardBadgeImage.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardBadgeImage

/// Round award-badge graphic shown at the top of the Award Information Block.
/// Pulls the imageset name (e.g. `TopProjectBadge`) from the bound `Award`.
// mm:6885:10483 — mms_C2.1.3 award image
struct AwardBadgeImage: View {

    let assetName: String

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
            .frame(width: 160, height: 160)
            .accessibilityLabel(Text(localizer.t("award.badge.accessibility_label")))
    }
}

#Preview {
    ZStack {
        Color(red: 0x00/255.0, green: 0x10/255.0, blue: 0x1A/255.0)
            .ignoresSafeArea()
        AwardBadgeImage(assetName: "TopProjectBadge")
    }
    .environmentObject(Localizer())
}
