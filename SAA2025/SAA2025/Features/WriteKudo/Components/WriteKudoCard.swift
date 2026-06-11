//
//  WriteKudoCard.swift
//  SAA2025
//
//  Cream card container for the Write Kudo form.
//

import SwiftUI

// MARK: - WriteKudoCard

/// Shared cream card background used by the composer form.
/// Background `#FFF8E1`, corner radius `10.72pt`, padding 18/12.
struct WriteKudoCard<Content: View>: View {

    private let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            content()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10.72)
                .fill(Color(red: 0xFF / 255.0, green: 0xF8 / 255.0, blue: 0xE1 / 255.0))
        )
    }
}

// MARK: - Field style helpers (shared by sub-components)

enum WriteKudoFieldStyle {
    static let borderColor: Color = Color(red: 0x99 / 255.0, green: 0x8C / 255.0, blue: 0x5F / 255.0)
    static let borderWidth: CGFloat = 0.447
    static let cornerRadius: CGFloat = 3.574
    static let labelColor: Color = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)
    static let helperColor: Color = Color(red: 0x99 / 255.0, green: 0x99 / 255.0, blue: 0x99 / 255.0)
}
