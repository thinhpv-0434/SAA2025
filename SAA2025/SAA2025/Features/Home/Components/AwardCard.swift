//
//  AwardCard.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardCard

// mm:6885:9033
struct AwardCard: View {

    let award: Award
    let onTap: () -> Void

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // mm:I6885:9033;72:2115 — badge image with gold border + glow
                awardImage

                // mm:I6885:9033;72:2049 — title + description
                textBlock

                // mm:I6885:9033;72:2052 — "Chi tiết" button
                detailsButton
            }
            .frame(width: Self.cardWidth, alignment: .leading)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Subviews

    private var awardImage: some View {
        Image(award.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: Self.cardWidth, height: Self.cardWidth)
            .clipShape(RoundedRectangle(cornerRadius: 11.43))
            .overlay(
                RoundedRectangle(cornerRadius: 11.43)
                    .stroke(Self.gold, lineWidth: 0.5)
            )
            .shadow(color: Self.gold.opacity(0.6), radius: 6)
    }

    private var textBlock: some View {
        VStack(alignment: .leading, spacing: 2) {
            // mm:I6885:9033;72:2050
            Text(award.title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Self.gold)
                .lineLimit(1)
            // mm:I6885:9033;72:2051
            Text(award.shortDescription)
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.white)
                .lineLimit(3)
                .truncationMode(.tail)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: Self.cardWidth, alignment: .leading)
    }

    private var detailsButton: some View {
        HStack(spacing: 8) {
            // mm:I6885:9033;72:2052;72:2029
            Text(localizer.t("card.award.btn.details"))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
            Image(systemName: "arrow.up.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.vertical, 6)
    }

    // #FFEA9E — design token "Details / Text Primary 1"
    private static let gold = Color(red: 0xFF / 255.0, green: 0xEA / 255.0, blue: 0x9E / 255.0)
    private static let cardWidth: CGFloat = 160
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AwardCard(
            award: Award(
                id: UUID(),
                title: "Top Talent",
                shortDescription: "Giải thưởng Top Talent vinh danh những cá nhân xuất ...",
                imageName: "TopTalentBadge"
            ),
            onTap: {}
        )
        .padding()
        .environmentObject(Localizer())
    }
}
