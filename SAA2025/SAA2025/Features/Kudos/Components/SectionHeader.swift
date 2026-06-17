//
//  SectionHeader.swift
//  SAA2025
//

import SwiftUI

// MARK: - SectionHeader

/// Reusable two-line section header: small white subtitle, 1px separator,
/// then the gold section title. Matches the same Figma pattern used by the
/// Home awards section. Used by B.2 (HIGHLIGHT KUDOS), B.6 (SPOTLIGHT BOARD),
/// C.1 (ALL KUDOS).
struct SectionHeader: View {

    let subtitle: String   // e.g. "Sun* Annual Awards 2025"
    let title: String      // e.g. "HIGHLIGHT KUDOS"

    private static let titleGold = Color(red: 0xFF / 255.0, green: 0xEA / 255.0, blue: 0x9E / 255.0)
    private static let separator = Color(red: 0x2E / 255.0, green: 0x39 / 255.0, blue: 0x40 / 255.0)

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // mm:I*;75:1884 — subtitle: Montserrat 12 / regular / white
            Text(subtitle)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white)

            // mm:I*;75:1885 — 1px separator
            Rectangle()
                .fill(Self.separator)
                .frame(height: 1)

            // mm:I*;75:1886 — section title: 22 / medium / gold
            Text(title)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(Self.titleGold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        VStack(spacing: 20) {
            SectionHeader(subtitle: "Sun* Annual Awards 2025", title: "HIGHLIGHT KUDOS")
            SectionHeader(subtitle: "Sun* Annual Awards 2025", title: "SPOTLIGHT BOARD")
            SectionHeader(subtitle: "Sun* Annual Awards 2025", title: "ALL KUDOS")
        }
    }
}
