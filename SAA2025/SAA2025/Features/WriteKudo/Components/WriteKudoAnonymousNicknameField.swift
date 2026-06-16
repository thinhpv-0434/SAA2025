//
//  WriteKudoAnonymousNicknameField.swift
//  SAA2025
//

import SwiftUI

// MARK: - WriteKudoAnonymousNicknameField

/// Required nickname input that appears below the anonymous toggle once
/// the user opts to send a Kudo anonymously. Mirrors the
/// "Lỗi chưa điền hết" Figma frame (mm:6885:10005) where the field is
/// labelled "Nickname ẩn danh *" with a Doraemon placeholder.
struct WriteKudoAnonymousNicknameField: View {

    @Binding var nickname: String

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            (
                Text(localizer.t("writkudo.field.anonymous_nickname.label"))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(WriteKudoFieldStyle.labelColor)
                + Text(localizer.t("form.required"))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
            )
            .frame(width: 80, alignment: .leading)
            .lineLimit(2)

            TextField("", text: $nickname, prompt: prompt)
                .font(.system(size: 14))
                .foregroundColor(WriteKudoFieldStyle.labelColor)
                .padding(.horizontal, 12)
                .frame(height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(WriteKudoFieldStyle.borderColor, lineWidth: WriteKudoFieldStyle.borderWidth)
                )
        }
    }

    private var prompt: Text {
        Text(localizer.t("writkudo.field.anonymous_nickname.placeholder"))
            .foregroundColor(WriteKudoFieldStyle.helperColor.opacity(0.6))
    }
}

#Preview {
    WriteKudoAnonymousNicknameField(nickname: .constant("Doraemon"))
        .padding()
        .background(Color(red: 0xFF / 255.0, green: 0xF8 / 255.0, blue: 0xE1 / 255.0))
        .environmentObject(Localizer())
}
