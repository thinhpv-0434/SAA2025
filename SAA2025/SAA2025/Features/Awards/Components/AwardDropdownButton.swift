//
//  AwardDropdownButton.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardDropdownStyle (shared visual tokens)

enum AwardDropdownStyle {
    static let borderColor = Color(red: 0x99/255.0, green: 0x8C/255.0, blue: 0x5F/255.0)
    static let backgroundColor = Color("saaGold").opacity(0.10)
    static let cornerRadius: CGFloat = 8
    static let textColor = Color("saaGold")
    static let chevronColor = Color("saaGold")
}

// MARK: - AwardDropdownButton

/// Presentational dropdown trigger. Renders the currently selected award name
/// + chevron in a bordered gold pill. The caller wraps it in a SwiftUI `Menu`
/// so item picking and selection logic stays in the parent view.
// mm:6885:10454 — mms_B.1_header dropdown trigger
struct AwardDropdownButton: View {

    let selectionTitle: String

    var body: some View {
        HStack(spacing: 8) {
            Text(selectionTitle)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AwardDropdownStyle.textColor)
                .lineLimit(1)

            Image(systemName: "chevron.down")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(AwardDropdownStyle.chevronColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: AwardDropdownStyle.cornerRadius)
                .fill(AwardDropdownStyle.backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AwardDropdownStyle.cornerRadius)
                .stroke(AwardDropdownStyle.borderColor, lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        Color(red: 0x00/255.0, green: 0x10/255.0, blue: 0x1A/255.0)
            .ignoresSafeArea()
        AwardDropdownButton(selectionTitle: "Top Project")
    }
}
