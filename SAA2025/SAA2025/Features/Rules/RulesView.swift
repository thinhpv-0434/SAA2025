//
//  RulesView.swift
//  SAA2025
//
//  Screen: [iOS] Thể lệ — zIuFaHAid4
//  Design: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/zIuFaHAid4
//

import SwiftUI

// MARK: - RulesView

/// Awards & Kudos rules explainer reached from the Home Hero "ABOUT KUDOS"
/// button (and the Profile/Awards "Chi tiết" CTAs). Walks the reader through
/// the Hero-tier ladder for kudo receivers, the icon-collection rewards for
/// kudo senders, and the "Kudos Quốc dân" community pick.
// mm:6885:10860 — [iOS] Thể lệ
struct RulesView: View {

    let onWriteKudo: () -> Void

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizer: Localizer

    init(onWriteKudo: @escaping () -> Void = {}) {
        self.onWriteKudo = onWriteKudo
    }

    private static let divider = Color.white.opacity(0.18)

    var body: some View {
        ZStack(alignment: .top) {
            AwardsBackground()

            VStack(spacing: 0) {
                topBar

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        sectionTitle("rules.h1", large: true)

                        receiverSection
                        senderSection
                        kudosQuocDanSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }

                Rectangle().fill(Self.divider).frame(height: 1)

                bottomBar
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Top bar

    private var topBar: some View {
        ZStack {
            Text(localizer.t("rules.nav.title"))
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color("saaGold"))

            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
                Spacer()
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 4)
    }

    // MARK: - Receiver section (Hero tiers)

    private var receiverSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            uppercaseHeading("rules.receiver.heading")

            paragraph("rules.receiver.intro")

            Rectangle().fill(Self.divider).frame(height: 1)

            heroTier(
                pill: tierPill(label: "New Hero", tint: heroTint(.new)),
                bold: localizer.t("rules.tier.new.headline"),
                body: localizer.t("rules.tier.new.body")
            )
            heroTier(
                pill: tierPill(label: "Rising Hero", tint: heroTint(.rising)),
                bold: localizer.t("rules.tier.rising.headline"),
                body: localizer.t("rules.tier.rising.body")
            )
            heroTier(
                pill: tierPill(label: "Super Hero", tint: heroTint(.sup)),
                bold: localizer.t("rules.tier.super.headline"),
                body: localizer.t("rules.tier.super.body")
            )
            heroTier(
                pill: tierPill(label: "Legend Hero", tint: heroTint(.legend)),
                bold: localizer.t("rules.tier.legend.headline"),
                body: localizer.t("rules.tier.legend.body")
            )
        }
    }

    private func heroTier(pill: AnyView, bold: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            pill
            Text(bold)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            Text(body)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.85))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func tierPill(label: String, tint: Color) -> AnyView {
        AnyView(
            Text(label)
                .font(.system(size: 11, weight: .heavy))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .background(
                    Capsule().fill(tint)
                )
        )
    }

    private enum HeroTier { case new, rising, sup, legend }

    private func heroTint(_ t: HeroTier) -> Color {
        switch t {
        case .new:    return Color(red: 0x5B / 255.0, green: 0x9B / 255.0, blue: 0xFF / 255.0)
        case .rising: return Color(red: 0xE6 / 255.0, green: 0x7E / 255.0, blue: 0x2C / 255.0)
        case .sup:    return Color(red: 0x77 / 255.0, green: 0x44 / 255.0, blue: 0xE6 / 255.0)
        case .legend: return Color(red: 0x8B / 255.0, green: 0x20 / 255.0, blue: 0x20 / 255.0)
        }
    }

    // MARK: - Sender section (badge collection)

    private var senderSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            uppercaseHeading("rules.sender.heading")
            paragraph("rules.sender.intro")
            ProfileBadgeShowcase()
                .padding(.vertical, 4)
            paragraph("rules.sender.outro")
        }
    }

    // MARK: - Kudos Quốc dân

    private var kudosQuocDanSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("rules.kudos_quoc_dan.title", large: false)
            paragraph("rules.kudos_quoc_dan.body")
        }
    }

    // MARK: - Bottom bar

    private var bottomBar: some View {
        HStack(spacing: 12) {
            Button(action: { dismiss() }) {
                Text(localizer.t("rules.btn.close"))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: {
                dismiss()
                onWriteKudo()
            }) {
                Text(localizer.t("rules.btn.write_kudo"))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(red: 0x1A / 255.0, green: 0x14 / 255.0, blue: 0x0A / 255.0))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0xFA / 255.0, green: 0xE6 / 255.0, blue: 0x86 / 255.0))
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    // MARK: - Helpers

    private func sectionTitle(_ key: String, large: Bool) -> some View {
        Text(localizer.t(key))
            .font(.system(size: large ? 22 : 16, weight: .bold))
            .foregroundColor(.white)
            .padding(.top, large ? 4 : 0)
    }

    private func uppercaseHeading(_ key: String) -> some View {
        Text(localizer.t(key))
            .font(.system(size: 14, weight: .heavy))
            .foregroundColor(Color("saaGold"))
            .kerning(0.6)
    }

    private func paragraph(_ key: String) -> some View {
        Text(localizer.t(key))
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(.white.opacity(0.9))
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    NavigationStack { RulesView() }
        .environmentObject(Localizer())
}
