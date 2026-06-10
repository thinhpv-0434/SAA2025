//
//  OpenSecretBoxButton.swift
//  SAA2025
//

import SwiftUI

// MARK: - OpenSecretBoxButton

// mm:6885:D.2 — yellow CTA "Mở Secret Box" with gift icon
struct OpenSecretBoxButton: View {

    let unopenedCount: Int
    let onTap: () -> Void

    var isDisabled: Bool { unopenedCount == 0 }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Text("Mở Secret Box")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(isDisabled
                        ? Color(red: 0x1A / 255.0, green: 0x14 / 255.0, blue: 0x0A / 255.0).opacity(0.4)
                        : Color(red: 0x1A / 255.0, green: 0x14 / 255.0, blue: 0x0A / 255.0))

                // mm:I6885:D.2 — gift icon
                Image(systemName: "giftcard.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isDisabled
                        ? Color(red: 0x1A / 255.0, green: 0x14 / 255.0, blue: 0x0A / 255.0).opacity(0.4)
                        : Color(red: 0x1A / 255.0, green: 0x14 / 255.0, blue: 0x0A / 255.0))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isDisabled ? Color("saaGold").opacity(0.35) : Color("saaGold"))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        VStack(spacing: 16) {
            OpenSecretBoxButton(unopenedCount: 5, onTap: {})
            OpenSecretBoxButton(unopenedCount: 0, onTap: {})
        }
    }
}
