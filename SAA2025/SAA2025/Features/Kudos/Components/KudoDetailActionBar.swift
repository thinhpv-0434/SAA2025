//
//  KudoDetailActionBar.swift
//  SAA2025
//
//  mm:6885:10176 — mms_B.4.4_Action (heart + count | Copy Link | Xem chi tiết)
//

import SwiftUI

// MARK: - KudoDetailActionBar

/// B.4.4 — Action bar: heart+count on left, Copy Link + Xem chi tiết on right.
// mm:6885:10176 — mms_B.4.4_Action
struct KudoDetailActionBar: View {

    let heartCount: Int
    let isLiked: Bool
    /// TC_FUN_008: when true the heart button is disabled (sender == current user).
    var isOwn: Bool = false
    /// When false, the "Xem chi tiết" button is hidden. The detail screen passes false here
    /// because the user is already on the detail (per clarifications.md). The card variant
    /// would pass true.
    var showsDetailButton: Bool = true
    let onHeartTap: () -> Void
    let onCopyLink: () -> Void
    var onDetail: () -> Void = {}

    private static let textDark = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)
    private static let textMid  = Color(red: 0x4A / 255.0, green: 0x3E / 255.0, blue: 0x28 / 255.0)
    private static let heartRed = Color(red: 0xE6 / 255.0, green: 0x4A / 255.0, blue: 0x2C / 255.0)

    var body: some View {
        // mm:6885:10176 — flex-row, space-between
        HStack(spacing: 0) {

            // mm:6885:10177 — Hearts (count + icon). TC_FUN_008: disabled when isOwn.
            Button(action: onHeartTap) {
                HStack(spacing: 4) {
                    // mm:6885:10178 — "10"
                    Text("\(heartCount)")
                        .font(.custom("Montserrat", size: 10))
                        .fontWeight(.regular)
                        .foregroundColor(Self.textDark)
                    // mm:6885:10179 — mm_media_IC (heart icon)
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 13))
                        .foregroundColor(isLiked ? Self.heartRed : Self.textMid)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isOwn)
            .opacity(isOwn ? 0.6 : 1.0)

            Spacer()

            // mm:6885:10180 — Buttons (Copy Link + Xem chi tiết)
            HStack(spacing: 4) {

                // mm:6885:10181 — Button: Copy Link
                // mm:6885:10184 — "Copy Link" text
                // mm:6885:10185 — mm_media_IC (link icon)
                Button(action: onCopyLink) {
                    HStack(spacing: 4) {
                        Text("Copy Link")
                            .font(.custom("Montserrat", size: 10))
                            .fontWeight(.medium)
                        Image(systemName: "link")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(Self.textMid)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 4)
                }
                .buttonStyle(PlainButtonStyle())

                // mm:6885:10186 — Button: Xem chi tiết (hidden on detail screen)
                if showsDetailButton {
                    Button(action: onDetail) {
                        HStack(spacing: 4) {
                            Text("Xem chi tiết")
                                .font(.custom("Montserrat", size: 10))
                                .fontWeight(.medium)
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .foregroundColor(Color("saaGold"))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color(red: 0xF5 / 255.0, green: 0xF0 / 255.0, blue: 0xDC / 255.0).ignoresSafeArea()
        KudoDetailActionBar(
            heartCount: 10,
            isLiked: true,
            showsDetailButton: false,
            onHeartTap: {},
            onCopyLink: {}
        )
        .padding(12)
    }
}
