//
//  WriteKudoAnonymousToggle.swift
//  SAA2025
//
//  G Send Anonymously Checkbox
//

import SwiftUI

// MARK: - WriteKudoAnonymousToggle

// mm:6885:9363 — anonymous checkbox + label
struct WriteKudoAnonymousToggle: View {

    @Binding var isAnonymous: Bool

    var body: some View {
        Button(action: { isAnonymous.toggle() }) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(isAnonymous ? WriteKudoFieldStyle.labelColor : Color.white)
                        .frame(width: 18, height: 18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(WriteKudoFieldStyle.borderColor, lineWidth: WriteKudoFieldStyle.borderWidth)
                        )

                    if isAnonymous {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                Text("Gửi lời cám ơn và ghi nhận ẩn danh")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(WriteKudoFieldStyle.labelColor)

                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 12) {
        WriteKudoAnonymousToggle(isAnonymous: .constant(false))
        WriteKudoAnonymousToggle(isAnonymous: .constant(true))
    }
    .padding()
    .background(Color(red: 0xFF / 255.0, green: 0xF8 / 255.0, blue: 0xE1 / 255.0))
}
