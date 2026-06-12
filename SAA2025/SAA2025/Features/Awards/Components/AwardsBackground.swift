//
//  AwardsBackground.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardsBackground

/// Awards-tab background: navy base with the SAA `KeyvisualBG` artwork bleeding
/// down from the top edge, fading to opaque navy by ~60%. Mirrors the pattern
/// used by `KudosKeyvisualBackground` so the two screens share a visual language.
// mm:6885:10430 — Awards screen background (mm_media_bg group)
struct AwardsBackground: View {

    private static let navy = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)

    var body: some View {
        ZStack {
            Self.navy.ignoresSafeArea()

            Image("KeyvisualBG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 460, alignment: .top)
                .clipped()
                .ignoresSafeArea(edges: .top)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Self.navy.opacity(0.0), location: 0.0),
                    .init(color: Self.navy.opacity(0.85), location: 0.40),
                    .init(color: Self.navy, location: 0.65)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    AwardsBackground()
}
