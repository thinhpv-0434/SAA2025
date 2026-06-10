//
//  SectionHeader.swift
//  SAA2025
//

import SwiftUI

// MARK: - SectionHeader

/// Reusable two-line section header: small gold subtitle + large white title.
/// Used by B.2 (HIGHLIGHT KUDOS), B.6 (SPOTLIGHT BOARD), C.1 (ALL KUDOS).
struct SectionHeader: View {

    let subtitle: String   // e.g. "Sun* Annual Awards 2025"
    let title: String      // e.g. "HIGHLIGHT KUDOS"

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // mm:I*;75:1884 — small subtitle in gold
            Text(subtitle)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color("saaGold"))
                .kerning(1.2)
                .textCase(.uppercase)

            // mm:I*;75:1886 — large section title in white
            Text(title)
                .font(.system(size: 22, weight: .black))
                .foregroundColor(.white)
                .kerning(1.0)
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
