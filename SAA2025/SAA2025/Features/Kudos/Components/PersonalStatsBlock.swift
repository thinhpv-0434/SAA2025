//
//  PersonalStatsBlock.swift
//  SAA2025
//

import SwiftUI

// MARK: - PersonalStatsBlock

// mm:6885:D.1: personal stats block — 5 stat rows
struct PersonalStatsBlock: View {

    let stats: KudosStats

    private static let bg = Color(red: 0x0E / 255.0, green: 0x16 / 255.0, blue: 0x22 / 255.0)
    private static let divider = Color.white.opacity(0.08)
    private static let valueGold = Color("saaGold")

    var body: some View {
        VStack(spacing: 0) {
            // mm:6885:D.1.2 — kudos received
            statRow(
                label: "Số Kudos bạn nhận được:",
                value: "\(stats.kudosReceived)",
                badge: nil
            )
            dividerLine

            // mm:6885:D.1.3 — kudos sent
            statRow(
                label: "Số Kudos bạn đã gửi:",
                value: "\(stats.kudosSent)",
                badge: nil
            )
            dividerLine

            // mm:6885:D.1.4 — hearts received (with x2 fire badge)
            statRow(
                label: "Số tim bạn nhận được:",
                value: "\(stats.heartsReceived)",
                badge: "x2"
            )
            dividerLine

            // mm:6885:D.1.5 — visual separator section break (no label)
            Divider()
                .background(Color.white.opacity(0.15))
                .padding(.vertical, 4)

            // mm:6885:D.1.6 — secret boxes opened
            statRow(
                label: "Số Secret Box bạn đã mở:",
                value: "\(stats.secretBoxOpened)",
                badge: nil
            )
            dividerLine

            // mm:6885:D.1.7 — secret boxes unopened
            statRow(
                label: "Số Secret Box chưa mở:",
                value: "\(stats.secretBoxUnopened)",
                badge: nil
            )
        }
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Self.bg)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Row

    private func statRow(label: String, value: String, badge: String?) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.85))

            Spacer()

            if let badge = badge {
                // x2 fire badge — Figma shows a flame/fire emoji badge
                HStack(spacing: 2) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 11))
                        .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.1))
                    Text(badge)
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.1))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(Color(red: 1.0, green: 0.55, blue: 0.1).opacity(0.15))
                )
            }

            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Self.valueGold)
                .monospacedDigit()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var dividerLine: some View {
        Rectangle()
            .fill(Self.divider)
            .frame(height: 1)
            .padding(.horizontal, 16)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        PersonalStatsBlock(stats: KudosStats(
            kudosReceived: 25,
            kudosSent: 25,
            heartsReceived: 25,
            secretBoxOpened: 25,
            secretBoxUnopened: 25
        ))
        .padding(.vertical, 16)
    }
}
