//
//  KudosCard.swift
//  SAA2025
//

import SwiftUI

// MARK: - KudosCard

/// Reusable kudos card used in both the Highlight carousel (B.3/B.4) and the
/// All Kudos feed (C.3). The `isHighlight` flag on the data drives the active/
/// faded carousel appearance; `isFeedVariant` removes the fixed carousel width.
// mm:6885:9083 (highlight) / mm:6885:9263 (feed)
struct KudosCard: View {

    let card: KudosCardData
    /// When true the card is shown inside the carousel at a fixed width.
    let isCarouselVariant: Bool
    let onCopyLink: () -> Void
    let onDetail: () -> Void
    let onHashtagTap: (String) -> Void
    let onHeartTap: () -> Void

    private static let cardBg = Color(red: 0xF5 / 255.0, green: 0xF0 / 255.0, blue: 0xDC / 255.0)
    private static let textDark = Color(red: 0x1A / 255.0, green: 0x14 / 255.0, blue: 0x0A / 255.0)
    private static let textMid = Color(red: 0x4A / 255.0, green: 0x3E / 255.0, blue: 0x28 / 255.0)
    private static let badgeRising = Color(red: 0xE6 / 255.0, green: 0x7E / 255.0, blue: 0x2C / 255.0)
    private static let badgeLegend = Color(red: 0x8B / 255.0, green: 0x20 / 255.0, blue: 0x20 / 255.0)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // mm:6885:B.3 — sender ▶ receiver header row
            headerRow
                .padding(.horizontal, 12)
                .padding(.top, 12)
                .padding(.bottom, 10)

            Divider()
                .background(Color.black.opacity(0.08))

            // mm:6885:B.4 — content: timestamp, category, message, hashtags, actions
            contentArea
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
        }
        .background(Self.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
        .frame(width: isCarouselVariant ? 300 : nil)
        .opacity(isCarouselVariant && !card.isHighlight ? 0.55 : 1.0)
    }

    // MARK: - Header Row

    private var headerRow: some View {
        HStack(alignment: .top, spacing: 8) {
            // mm:6885:B.3.1 — sender avatar + info
            userBlock(user: card.sender, isSender: true)

            // mm:6885:B.3.4 — arrow icon
            Image(systemName: "play.fill")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Self.textMid.opacity(0.5))
                .padding(.top, 14)

            // mm:6885:B.3.5 / B.3.6 — receiver avatar + info
            userBlock(user: card.receiver, isSender: false)
        }
    }

    private func userBlock(user: KudosUser, isSender: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // Avatar placeholder (SF Symbol circle)
            ZStack {
                Circle()
                    .fill(isSender
                          ? Color(red: 0.6, green: 0.4, blue: 0.2)
                          : Color(red: 0.3, green: 0.5, blue: 0.7))
                    .frame(width: 36, height: 36)
                Image(systemName: "person.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }

            // Name
            Text(user.name)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Self.textDark)
                .lineLimit(1)

            // Employee code
            Text(user.employeeCode)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(Self.textMid)

            // Badge label
            if let label = user.badgeLabel {
                badgePill(label: label, isSender: isSender)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func badgePill(label: String, isSender: Bool) -> some View {
        Text(label)
            .font(.system(size: 9, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(isSender ? Self.badgeRising : Self.badgeLegend)
            )
    }

    // MARK: - Content Area

    private var contentArea: some View {
        VStack(alignment: .leading, spacing: 6) {
            // mm:6885:B.4.1 — timestamp
            Text(card.timestamp)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(Self.textMid.opacity(0.7))

            // mm:6885:B.4.2 — category title + message
            VStack(alignment: .leading, spacing: 3) {
                Text(card.categoryTitle)
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(Self.textDark)
                    .kerning(0.5)
                Text(card.message)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Self.textMid)
                    .lineLimit(isCarouselVariant ? 3 : 5)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // mm:6885:B.4.3 — hashtag chips (max 5, 1 line)
            hashtagRow

            // mm:6885:B.4.4 — action row
            actionRow
        }
    }

    private var hashtagRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(Array(card.hashtags.prefix(5)), id: \.self) { tag in
                    HashtagChip(tag: tag) { onHashtagTap(tag) }
                }
            }
        }
    }

    private var actionRow: some View {
        HStack(spacing: 0) {
            // Heart count + toggle button (TC_FUN_007/008)
            Button(action: onHeartTap) {
                HStack(spacing: 4) {
                    Image(systemName: card.isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 13))
                        .foregroundColor(card.isLiked
                            ? Color(red: 0xE6 / 255.0, green: 0x4A / 255.0, blue: 0x2C / 255.0)
                            : Self.textMid)
                    Text(card.heartCountDisplay)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Self.textDark)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(card.isOwn)
            .opacity(card.isOwn ? 0.6 : 1.0)

            Spacer()

            // Copy Link
            Button(action: onCopyLink) {
                HStack(spacing: 4) {
                    Text("Copy Link")
                        .font(.system(size: 11, weight: .medium))
                    Image(systemName: "link")
                        .font(.system(size: 10))
                }
                .foregroundColor(Self.textMid)
            }
            .buttonStyle(PlainButtonStyle())

            Text("  ")

            // Xem chi tiết
            Button(action: onDetail) {
                HStack(spacing: 4) {
                    Text("Xem chi tiết")
                        .font(.system(size: 11, weight: .semibold))
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 10, weight: .semibold))
                }
                .foregroundColor(Color("saaGold"))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.top, 4)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        ScrollView {
            VStack(spacing: 16) {
                KudosCard(
                    card: KudosViewModel.mockHighlightCards[0],
                    isCarouselVariant: false,
                    onCopyLink: {},
                    onDetail: {},
                    onHashtagTap: { _ in },
                    onHeartTap: {}
                )
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 16)
        }
    }
}
