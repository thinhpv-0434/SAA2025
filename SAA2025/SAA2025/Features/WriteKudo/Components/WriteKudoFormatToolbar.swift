//
//  WriteKudoFormatToolbar.swift
//  SAA2025
//
//  C.1–C.6 Formatting toolbar (visual-only for v1)
//

import SwiftUI

// MARK: - WriteKudoFormatToolbar

// mm:6885:9306 — toolbar container
struct WriteKudoFormatToolbar: View {

    let onAwardsInfoTap: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            // mm:6885:9307 — Bold
            toolbarButton(label: "B", weight: .bold)

            // mm:6885:9309 — Italic
            toolbarButton(label: "I", weight: .regular, italic: true)

            // mm:6885:9311 — Strike
            toolbarButton(systemImage: "strikethrough")

            // mm:6885:9313 — Numbered list
            toolbarButton(systemImage: "list.number")

            // mm:6885:9315 — Link
            toolbarButton(systemImage: "link")

            // mm:6885:9317 — Quote
            toolbarButton(systemImage: "quote.bubble")

            Spacer(minLength: 8)

            // mm:6885:9303 — community standards link
            WriteKudoCommunityStandardsLink(onTap: onAwardsInfoTap)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .fill(Color.white)
                .overlay(
                    Rectangle()
                        .stroke(WriteKudoFieldStyle.borderColor, lineWidth: WriteKudoFieldStyle.borderWidth)
                )
        )
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: WriteKudoFieldStyle.cornerRadius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: WriteKudoFieldStyle.cornerRadius
            )
        )
    }

    // MARK: - Reusable buttons

    @ViewBuilder
    private func toolbarButton(label: String, weight: Font.Weight = .regular, italic: Bool = false) -> some View {
        Button(action: {}) {
            Text(label)
                .font(italic
                      ? .system(size: 14, weight: weight).italic()
                      : .system(size: 14, weight: weight))
                .foregroundColor(WriteKudoFieldStyle.labelColor)
                .frame(width: 28, height: 24)
        }
        .buttonStyle(PlainButtonStyle())
    }

    @ViewBuilder
    private func toolbarButton(systemImage: String) -> some View {
        Button(action: {}) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(WriteKudoFieldStyle.labelColor)
                .frame(width: 28, height: 24)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    WriteKudoFormatToolbar(onAwardsInfoTap: {})
        .padding()
        .background(Color(red: 0xFF / 255.0, green: 0xF8 / 255.0, blue: 0xE1 / 255.0))
}
