//
//  ProfileUserCard.swift
//  SAA2025
//

import SwiftUI

// MARK: - ProfileUserCard

/// Top member block on the Profile tab: circular avatar + display name +
/// employee code with an earned-badge pill alongside. The avatar uses
/// initials over a deterministic warm-gradient backdrop until a real
/// photo URL is plumbed through `ProfileUser`.
// mm:6885:10339 — mms_1.1_member
struct ProfileUserCard: View {

    let user: ProfileUser

    private static let avatarSize: CGFloat = 96

    var body: some View {
        VStack(spacing: 12) {
            avatar
            nameBlock
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }

    // mm:6885:10340 — mm_media_Avatar
    private var avatar: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors(for: user.employeeCode)),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: Self.avatarSize, height: Self.avatarSize)

            Text(user.initials)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .overlay(
            Circle()
                .stroke(Color.white.opacity(0.9), lineWidth: 2)
        )
    }

    /// Picks one of three warm gradients deterministically so the same
    /// sunner always reads with the same colors across the app.
    private func gradientColors(for seed: String) -> [Color] {
        let hash = abs(seed.hashValue)
        switch hash % 3 {
        case 0:
            return [
                Color(red: 0xE6 / 255.0, green: 0x7E / 255.0, blue: 0x2C / 255.0),
                Color(red: 0x8B / 255.0, green: 0x20 / 255.0, blue: 0x20 / 255.0)
            ]
        case 1:
            return [
                Color(red: 0xC9 / 255.0, green: 0xA0 / 255.0, blue: 0x40 / 255.0),
                Color(red: 0x6B / 255.0, green: 0x35 / 255.0, blue: 0x10 / 255.0)
            ]
        default:
            return [
                Color(red: 0xF0 / 255.0, green: 0xB0 / 255.0, blue: 0x60 / 255.0),
                Color(red: 0x9A / 255.0, green: 0x30 / 255.0, blue: 0x18 / 255.0)
            ]
        }
    }

    // mm:6885:10341 — mms_A.2_Name
    private var nameBlock: some View {
        VStack(spacing: 6) {
            Text(user.displayName)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            HStack(spacing: 8) {
                Text(user.employeeCode)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))

                badgePill
            }
        }
    }

    private var badgePill: some View {
        Text(user.badgeLabel)
            .font(.system(size: 11, weight: .heavy))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(user.badgeTier.pillColor)
            )
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)
            .ignoresSafeArea()
        ProfileUserCard(user: .mock)
    }
}
