//
//  ProfileStatsBlock.swift
//  SAA2025
//

import SwiftUI

// MARK: - ProfileStatsBlock

/// Stats summary card on the Profile tab. Mirrors `PersonalStatsBlock` from
/// the Kudos tab but uses Profile's design tokens: white numerals (not gold),
/// thin row dividers, and the "Mở Secret Box" CTA tucked inside the card.
// mm:6885:10358 — mms_D.1_Thống kê tổng quát
struct ProfileStatsBlock: View {

    let stats: KudosStats
    let onOpenSecretBox: () -> Void

    @EnvironmentObject private var localizer: Localizer

    private static let cardBg = Color(red: 0x0E / 255.0, green: 0x16 / 255.0, blue: 0x22 / 255.0)
    private static let rowDivider = Color.white.opacity(0.08)
    private static let sectionDivider = Color.white.opacity(0.18)
    private static let secretBoxTint = Color(red: 0xFA / 255.0, green: 0xE6 / 255.0, blue: 0x86 / 255.0)

    var body: some View {
        VStack(spacing: 0) {
            row(label: localizer.t("kudos.stats.received"), value: stats.kudosReceived)
            divider
            row(label: localizer.t("kudos.stats.sent"), value: stats.kudosSent)
            divider
            row(label: localizer.t("kudos.stats.hearts"), value: stats.heartsReceived)

            Rectangle()
                .fill(Self.sectionDivider)
                .frame(height: 1)
                .padding(.horizontal, 16)
                .padding(.vertical, 4)

            row(label: localizer.t("kudos.stats.secret_box_opened"), value: stats.secretBoxOpened)
            divider
            row(label: localizer.t("kudos.stats.secret_box_unopened"), value: stats.secretBoxUnopened)

            secretBoxButton
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 16)
        }
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Self.cardBg)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }

    private func row(label: String, value: Int) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.9))

            Spacer()

            Text("\(value)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .monospacedDigit()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var divider: some View {
        Rectangle()
            .fill(Self.rowDivider)
            .frame(height: 1)
            .padding(.horizontal, 16)
    }

    // mm:6885:10386 — mms_Button "Mở Secret Box"
    private var secretBoxButton: some View {
        Button(action: onOpenSecretBox) {
            HStack(spacing: 8) {
                Text(localizer.t("kudos.btn.open_secret_box"))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 0x1A / 255.0, green: 0x14 / 255.0, blue: 0x0A / 255.0))

                Image(systemName: "giftcard.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0x1A / 255.0, green: 0x14 / 255.0, blue: 0x0A / 255.0))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Self.secretBoxTint)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        ProfileStatsBlock(
            stats: KudosStats(
                kudosReceived: 5,
                kudosSent: 25,
                heartsReceived: 25,
                secretBoxOpened: 25,
                secretBoxUnopened: 25
            ),
            onOpenSecretBox: {}
        )
        .environmentObject(Localizer())
    }
}
