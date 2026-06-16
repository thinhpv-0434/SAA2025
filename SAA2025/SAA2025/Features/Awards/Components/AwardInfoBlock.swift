//
//  AwardInfoBlock.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardInfoBlock

/// Section C of the Awards tab. Shows the selected award's badge, title row
/// (trophy icon + title), long description paragraph, and two stat rows
/// (quantity + value) separated by a navy divider.
// mm:6885:10462 — mms_C award info group (container)
struct AwardInfoBlock: View {

    let award: Award

    @EnvironmentObject private var localizer: Localizer

    private static let divider = Color(red: 0x2E/255.0, green: 0x39/255.0, blue: 0x40/255.0)

    var body: some View {
        VStack(spacing: 18) {
            // mm:6885:10483 — badge (falls back to a synthesised gold-ring
            // wordmark for awards whose PNG asset hasn't shipped yet)
            AwardBadgeImage(assetName: award.imageName, fallbackTitle: award.title)
                .padding(.top, 4)

            // mm:6885:10467 — title row (trophy icon + title)
            HStack(spacing: 8) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("saaGold"))

                Text(award.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("saaGold"))
            }

            // mm:6885:10468 — long description
            if !award.longDescription.isEmpty {
                Text(award.longDescription)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 4)
            }

            // Stat rows
            VStack(spacing: 0) {
                // mm:6885:10473 (label) / mm:6885:10475 (value) — quantity
                AwardStatRow(
                    iconSystemName: "diamond.fill",
                    label: localizer.t("award.stat.quantity.label"),
                    primaryValue: award.quantity.isEmpty ? "—" : award.quantity
                )

                Rectangle()
                    .fill(Self.divider)
                    .frame(height: 1)

                // mm:6885:10476 (label) / mm:6885:10481 (value) — value
                AwardStatRow(
                    iconSystemName: "flag.fill",
                    label: localizer.t("award.stat.value.label"),
                    primaryValue: award.awardValue.isEmpty ? "—" : award.awardValue,
                    secondaryValue: award.awardValue.isEmpty ? nil : localizer.t("award.stat.value.suffix")
                )
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 32)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00/255.0, green: 0x10/255.0, blue: 0x1A/255.0)
            .ignoresSafeArea()
        ScrollView {
            AwardInfoBlock(award: Award(
                id: UUID(),
                title: "Top Project",
                shortDescription: "",
                imageName: "AwardBadgeBG",
                longDescription: "Giải thưởng Top Project vinh danh các tập thể dự án xuất sắc với kết quả kinh doanh vượt kỳ vọng; hiệu quả vận hành tối ưu và tinh thần làm việc tận tâm...",
                quantity: "02 Tập thể",
                awardValue: "15.000.000 VNĐ"
            ))
        }
    }
    .environmentObject(Localizer())
}
