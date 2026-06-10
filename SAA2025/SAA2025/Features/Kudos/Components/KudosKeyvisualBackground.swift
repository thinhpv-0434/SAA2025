//
//  KudosKeyvisualBackground.swift
//  SAA2025
//

import SwiftUI

// MARK: - KudosKeyvisualBackground

/// Dark navy base with the SAA `KeyvisualBG` artwork bleeding into the top portion,
/// fading to opaque navy by ~60% down. Used as the All Kudos screen background.
// mm:6891:15995 — keyvisual artwork (top) fading into dark navy
struct KudosKeyvisualBackground: View {

    private static let navy = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)

    var body: some View {
        ZStack {
            Self.navy.ignoresSafeArea()

            Image("KeyvisualBG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 420, alignment: .top)
                .clipped()
                .ignoresSafeArea(edges: .top)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Self.navy.opacity(0), location: 0.0),
                    .init(color: Self.navy.opacity(0.85), location: 0.35),
                    .init(color: Self.navy, location: 0.6)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}
