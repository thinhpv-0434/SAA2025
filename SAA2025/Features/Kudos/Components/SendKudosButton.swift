//
//  SendKudosButton.swift
//  SAA2025
//

import SwiftUI

// MARK: - SendKudosButton

// mm:6885:9065 — A.1: pill CTA "Hôm nay, bạn muốn gửi kudos đến ai?"
struct SendKudosButton: View {

    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                // mm:I6885:9065;88:1869 — pencil/edit icon
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)

                // mm:I6885:9065;88:1827 — placeholder text
                Text("Hôm nay, bạn muốn gửi kudos đến ai?")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.75))

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.10))
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        SendKudosButton(onTap: {})
            .padding(.vertical, 8)
    }
}
