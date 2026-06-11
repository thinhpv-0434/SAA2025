//
//  KudoSenderReceiverHighlight.swift
//  SAA2025
//
//  mm:6885:10149 — B.3 trao nhận (sender → arrow → receiver)
//

import SwiftUI

// MARK: - KudoSenderReceiverHighlight

/// B.3 — Sender ➜ Receiver highlight row with avatars, names, and badge pills.
// mm:6885:10148 — mms_B.3_KUDO - Highlight (parent container)
struct KudoSenderReceiverHighlight: View {

    let sender: KudosUser
    let receiver: KudosUser

    // Design tokens from KudosCard (re-declared locally; DRY refactor deferred)
    private static let textDark = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)
    private static let textMid  = Color(red: 0x99 / 255.0, green: 0x99 / 255.0, blue: 0x99 / 255.0)
    private static let badgeRising = Color(red: 0xE6 / 255.0, green: 0x7E / 255.0, blue: 0x2C / 255.0)
    private static let badgeLegend = Color(red: 0x8B / 255.0, green: 0x20 / 255.0, blue: 0x20 / 255.0)

    var body: some View {
        // mm:6885:10149 — trao nhận row: sender | arrow | receiver
        HStack(alignment: .center, spacing: 8) {
            // mm:I6885:10150 — Infor (sender)
            userBlock(user: sender, isSender: true)

            // mm:6885:10151 — mms_B.3.4_Icon mũi tên
            Image(systemName: "arrow.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Self.textMid)
                .frame(width: 20)

            // mm:I6885:10153 — Infor (receiver)
            userBlock(user: receiver, isSender: false)
        }
    }

    // MARK: - User Block

    private func userBlock(user: KudosUser, isSender: Bool) -> some View {
        VStack(alignment: isSender ? .leading : .trailing, spacing: 4) {
            // Avatar — 40pt circle (design spec)
            // mm:I6885:10150;89:2598 — sender avatar / mm:I6885:10153;89:2717 — receiver avatar
            ZStack {
                Circle()
                    .fill(isSender
                          ? Color(red: 0.6, green: 0.4, blue: 0.2)
                          : Color(red: 0.3, green: 0.5, blue: 0.7))
                    .frame(width: 40, height: 40)
                Image(systemName: "person.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }

            // mm:I6885:10150;89:2600 / mm:I6885:10153;89:2600 — name
            Text(user.name)
                .font(.custom("Montserrat", size: 10))
                .fontWeight(.regular)
                .foregroundColor(Self.textDark)
                .lineLimit(1)

            // mm:I6885:10150;89:2602 / mm:I6885:10153;89:2602 — employee code
            Text(user.employeeCode)
                .font(.custom("Montserrat", size: 10))
                .fontWeight(.medium)
                .foregroundColor(Self.textMid)
                .lineLimit(1)

            // mm:I6885:10150;89:2697 / mm:I6885:10153;89:2697 — badge pill (color from tier)
            if let label = user.badgeLabel {
                badgePill(label: label, tier: user.badgeTier)
            }
        }
        .frame(maxWidth: .infinity, alignment: isSender ? .leading : .trailing)
    }

    private func badgePill(label: String, tier: KudosBadgeTier) -> some View {
        Text(label)
            .font(.custom("Montserrat", size: 6))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(badgeColor(for: tier))
            )
    }

    private func badgeColor(for tier: KudosBadgeTier) -> Color {
        switch tier {
        case .none, .one: return Self.badgeRising   // Rising Hero
        case .two:        return Self.badgeRising   // mid-tier shares Rising visual for now
        case .three:      return Self.badgeLegend   // Legend Hero
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color(red: 0xF5 / 255.0, green: 0xF0 / 255.0, blue: 0xDC / 255.0).ignoresSafeArea()
        KudoSenderReceiverHighlight(
            sender: KudoDetailFixtures.senderUser,
            receiver: KudoDetailFixtures.receiverUser
        )
        .padding(12)
    }
}
