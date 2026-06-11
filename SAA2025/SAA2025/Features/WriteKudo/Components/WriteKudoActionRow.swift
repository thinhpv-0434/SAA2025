//
//  WriteKudoActionRow.swift
//  SAA2025
//
//  H Cancel Button + I Send Button
//

import SwiftUI

// MARK: - WriteKudoActionRow

struct WriteKudoActionRow: View {

    let isSubmitting: Bool
    let canSubmit: Bool
    let onCancel: () -> Void
    let onSubmit: () -> Void

    private static let gold = Color(red: 0xFF / 255.0, green: 0xEA / 255.0, blue: 0x9E / 255.0)
    private static let border = Color(red: 0x99 / 255.0, green: 0x8C / 255.0, blue: 0x5F / 255.0)
    private static let navy = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)

    var body: some View {
        HStack(spacing: 16) {
            // mm:6891:16834 — Cancel
            Button(action: onCancel) {
                HStack(spacing: 6) {
                    Text("Huỷ")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Self.navy)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Self.border, lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isSubmitting)

            // mm:6891:16833 — Send (primary)
            Button(action: onSubmit) {
                HStack(spacing: 6) {
                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0))
                            .scaleEffect(0.8)
                    } else {
                        Text("Gửi đi")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0))
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(canSubmit ? Self.gold : Self.gold.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Self.border, lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!canSubmit)
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        VStack(spacing: 12) {
            WriteKudoActionRow(isSubmitting: false, canSubmit: true, onCancel: {}, onSubmit: {})
            WriteKudoActionRow(isSubmitting: false, canSubmit: false, onCancel: {}, onSubmit: {})
            WriteKudoActionRow(isSubmitting: true, canSubmit: true, onCancel: {}, onSubmit: {})
        }
        .padding()
    }
}
