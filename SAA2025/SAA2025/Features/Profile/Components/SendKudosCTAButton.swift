//
//  SendKudosCTAButton.swift
//  SAA2025
//

import SwiftUI

// MARK: - SendKudosCTAButton

/// Wide gold-outlined CTA shown only on the "other person's profile" screen.
/// Pencil icon + truncated "Gửi lời cảm ơn và ghi nhận tới {name}…" label.
// mm:6885:10427 — mms_A.1_Button ghi nhận
struct SendKudosCTAButton: View {

    let recipientName: String
    let onTap: () -> Void

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color("saaGold"))

                Text(label)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(1)
                    .truncationMode(.tail)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.03))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("saaGold").opacity(0.85), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }

    private var label: String {
        let firstName = recipientName
            .split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
            .first
            .map(String.init) ?? recipientName
        return "\(localizer.t("profile.other.cta.send_prefix"))\(firstName)…"
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        SendKudosCTAButton(recipientName: "Huỳnh Dương Xuân Nhật", onTap: {})
            .environmentObject(Localizer())
    }
}
