//
//  ProfileBadgeShowcase.swift
//  SAA2025
//

import SwiftUI

// MARK: - ProfileEarnedBadge

/// One earned-badge tile (colored disc + label below).
struct ProfileEarnedBadge: Hashable, Identifiable {
    var id: String { name }
    let name: String
    let centerColor: Color
    let edgeColor: Color
    let hasInnerDot: Bool

    static let showcase: [ProfileEarnedBadge] = [
        ProfileEarnedBadge(
            name: "REVIVAL",
            centerColor: Color(red: 0xEC / 255.0, green: 0xE6 / 255.0, blue: 0xDC / 255.0),
            edgeColor: Color(red: 0xB8 / 255.0, green: 0xAE / 255.0, blue: 0x98 / 255.0),
            hasInnerDot: false
        ),
        ProfileEarnedBadge(
            name: "TOUCH OF LIGHT",
            centerColor: Color(red: 0xF8 / 255.0, green: 0xE8 / 255.0, blue: 0xB2 / 255.0),
            edgeColor: Color(red: 0xE5 / 255.0, green: 0xC2 / 255.0, blue: 0x70 / 255.0),
            hasInnerDot: false
        ),
        ProfileEarnedBadge(
            name: "STAY GOLD",
            centerColor: Color(red: 0xF4 / 255.0, green: 0xC2 / 255.0, blue: 0x42 / 255.0),
            edgeColor: Color(red: 0xB6 / 255.0, green: 0x82 / 255.0, blue: 0x10 / 255.0),
            hasInnerDot: false
        ),
        ProfileEarnedBadge(
            name: "FLOW TO HORIZON",
            centerColor: Color(red: 0xF1 / 255.0, green: 0xA2 / 255.0, blue: 0xA2 / 255.0),
            edgeColor: Color(red: 0xB6 / 255.0, green: 0x37 / 255.0, blue: 0x3D / 255.0),
            hasInnerDot: true
        ),
        ProfileEarnedBadge(
            name: "BEYOND THE BOUNDARY",
            centerColor: Color(red: 0xE6 / 255.0, green: 0x6D / 255.0, blue: 0x35 / 255.0),
            edgeColor: Color(red: 0x8E / 255.0, green: 0x2A / 255.0, blue: 0x10 / 255.0),
            hasInnerDot: true
        ),
        ProfileEarnedBadge(
            name: "ROOT FURTHER",
            centerColor: Color(red: 0x6E / 255.0, green: 0x1A / 255.0, blue: 0x1A / 255.0),
            edgeColor: Color(red: 0x35 / 255.0, green: 0x08 / 255.0, blue: 0x08 / 255.0),
            hasInnerDot: false
        )
    ]
}

// MARK: - ProfileBadgeShowcase

/// Earned-badge strip used on the "view someone else's profile" screen —
/// six colored discs with names underneath. Replaces `ProfileIconCollection`'s
/// placeholder slots because here the badges are real earned rewards.
// mm:6885:10411 — mms_3_list
struct ProfileBadgeShowcase: View {

    let badges: [ProfileEarnedBadge]

    init(badges: [ProfileEarnedBadge] = ProfileEarnedBadge.showcase) {
        self.badges = badges
    }

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            ForEach(badges) { badge in
                badgeCell(badge)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }

    private func badgeCell(_ badge: ProfileEarnedBadge) -> some View {
        VStack(spacing: 6) {
            disc(badge: badge)
            Text(badge.name)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .frame(height: 24, alignment: .top)
        }
        .frame(maxWidth: .infinity)
    }

    private func disc(badge: ProfileEarnedBadge) -> some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [badge.centerColor, badge.edgeColor]),
                        center: .center,
                        startRadius: 2,
                        endRadius: 22
                    )
                )
                .frame(width: 42, height: 42)
                .overlay(
                    Circle().stroke(Color.white.opacity(0.35), lineWidth: 1)
                )

            if badge.hasInnerDot {
                Circle()
                    .fill(Color(red: 0xB4 / 255.0, green: 0x2A / 255.0, blue: 0x2A / 255.0))
                    .frame(width: 6, height: 6)
            }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        ProfileBadgeShowcase()
    }
}
