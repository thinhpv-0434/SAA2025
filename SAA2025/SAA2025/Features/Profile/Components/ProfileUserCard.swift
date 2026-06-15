//
//  ProfileUserCard.swift
//  SAA2025
//

import SwiftUI

// MARK: - ProfileUserCard

/// Top member block on the Profile tab: circular avatar + display name +
/// employee code with an earned-badge pill alongside.
// mm:6885:10339 — mms_1.1_member
struct ProfileUserCard: View {

    let user: ProfileUser

    private static let avatarSize: CGFloat = 96
    private static let badgeRed = Color(red: 0x8B / 255.0, green: 0x20 / 255.0, blue: 0x20 / 255.0)

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
                .fill(Color.white.opacity(0.18))
                .frame(width: Self.avatarSize, height: Self.avatarSize)

            Image(systemName: user.avatarSystemName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white.opacity(0.85))
                .frame(width: Self.avatarSize - 4, height: Self.avatarSize - 4)
                .clipShape(Circle())
        }
        .overlay(
            Circle()
                .stroke(Color.white.opacity(0.9), lineWidth: 2)
        )
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
                    .fill(Self.badgeRed)
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
