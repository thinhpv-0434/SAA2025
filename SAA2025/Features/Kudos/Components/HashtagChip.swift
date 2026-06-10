//
//  HashtagChip.swift
//  SAA2025
//

import SwiftUI

// MARK: - HashtagChip

// mm:6885:B.4.3 — individual hashtag tag within a kudos card
struct HashtagChip: View {

    let tag: String   // e.g. "#Dedicated"
    let onTap: (() -> Void)?

    init(tag: String, onTap: (() -> Void)? = nil) {
        self.tag = tag
        self.onTap = onTap
    }

    var body: some View {
        Button {
            onTap?()
        } label: {
            Text(tag)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color("saaGold"))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color("saaGold").opacity(0.12))
                        .overlay(
                            Capsule()
                                .stroke(Color("saaGold").opacity(0.30), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(onTap == nil)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        HStack(spacing: 6) {
            HashtagChip(tag: "#Dedicated")
            HashtagChip(tag: "#Inspiring")
        }
    }
}
