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

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                // mm:I6885:9033;72:2115
                awardImage

                // mm:I6885:9033;72:2052
                cardFooter
            }
            .frame(width: 180)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Subviews

    private var awardImage: some View {
        ZStack {
            // mm:I6885:9033;72:2115;72:2079
            Image(award.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 180, height: 160)
                .clipped()
        }
        .frame(width: 180, height: 160)
        .background(Color(red: 0.12, green: 0.08, blue: 0.08))
    }

    private var cardFooter: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(award.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            Text(award.shortDescription)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(2)
            HStack(spacing: 4) {
                Text("Chi tiết")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color("saaGold"))
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(Color("saaGold"))
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AwardCard(
            award: Award(
                id: UUID(),
                title: "Top Talent",
                shortDescription: "Vinh danh cá nhân xuất sắc nhất.",
                imageName: "TopTalentBadge"
            ),
            onTap: {}
        )
        .padding()
    }
}
