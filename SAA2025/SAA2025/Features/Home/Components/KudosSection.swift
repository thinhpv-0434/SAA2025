//
//  KudosSection.swift
//  SAA2025
//

import SwiftUI

// MARK: - KudosSection

// mm:6885:9039
struct KudosSection: View {

    let info: KudosInfo
    let onDetailsTap: () -> Void

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        content(info)
    }

    // MARK: - Private

    private func content(_ info: KudosInfo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // mm:6885:9040
            sectionHeader

            // mm:6885:9041
            KudosBanner()
                .padding(.horizontal, 20)

            // mm:6885:9053
            noteBlock(info)

            // mm:6885:9055
            detailsButton
        }
        .padding(.vertical, 16)
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            // mm:I6885:9040;75:1884
            Text(localizer.t("home.kudos.subtitle"))
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color("saaGold"))
                .kerning(1.2)
                .textCase(.uppercase)
            // mm:I6885:9040;75:1886
            Text(localizer.t("home.kudos.title"))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
    }

    private func noteBlock(_ info: KudosInfo) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            // mm:6885:9054
            Text(info.badgeText)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color("saaGold"))
                .kerning(0.8)
            Text(info.descriptionText)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.85))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 20)
    }

    private var detailsButton: some View {
        // Match the "Chi tiết" CTA on the Awards screen
        // (AwardsSunKudosSection.ctaButton): gold fill + dark navy text + arrow,
        // 4pt corner radius, 16/10 padding.
        Button(action: onDetailsTap) {
            HStack(spacing: 8) {
                // mm:I6885:9055;28:1998
                Text(localizer.t("home.kudos.btn.details"))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Self.darkNavy)
                // mm:I6885:9055;28:1997
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Self.darkNavy)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(minWidth: 160)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("saaGold"))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }

    // #00101A — matches the "Chi tiết" CTA foreground on the Awards screen
    private static let darkNavy = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ScrollView {
            KudosSection(
                info: KudosInfo(
                    isAvailable: true,
                    bannerImageName: "KudosBanner",
                    descriptionText: "Hoạt động ghi nhận và cảm ơn đồng nghiệp.",
                    badgeText: "ĐIỂM MỚI CỦA SAA 2025"
                ),
                onDetailsTap: {}
            )
            .environmentObject(Localizer())
        }
    }
}
