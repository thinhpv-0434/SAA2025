//
//  WriteKudoTitleField.swift
//  SAA2025
//
//  B.3 Title Label + B.4 Title Input + B.5 Awards Info Link
//

import SwiftUI

// MARK: - WriteKudoTitleField

struct WriteKudoTitleField: View {

    @Binding var title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack(alignment: .center, spacing: 10) {
                // mm:6885:9299 — "Danh hiệu *"
                (Text("Danh hiệu")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(WriteKudoFieldStyle.labelColor)
                 + Text(" *")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.red))
                    .frame(width: 96, alignment: .leading)

                // mm:6885:9302 — title text input
                TextField("Dành tặng một danh hiệu cho...", text: $title)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(WriteKudoFieldStyle.labelColor)
                    .textInputAutocapitalization(.sentences)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 9)
                    .background(
                        RoundedRectangle(cornerRadius: WriteKudoFieldStyle.cornerRadius)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: WriteKudoFieldStyle.cornerRadius)
                                    .stroke(WriteKudoFieldStyle.borderColor, lineWidth: WriteKudoFieldStyle.borderWidth)
                            )
                    )
            }

            // Helper text (per Figma)
            VStack(alignment: .leading, spacing: 2) {
                Text("Ví dụ: Người truyền động lực cho tôi.")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(WriteKudoFieldStyle.helperColor)
                Text("Danh hiệu sẽ hiển thị làm tiêu đề Kudos của bạn.")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(WriteKudoFieldStyle.helperColor)
            }
            .padding(.leading, 106)
        }
    }
}

// MARK: - Standards link (B.5) — rendered separately so it can sit inside the toolbar row

struct WriteKudoCommunityStandardsLink: View {

    let onTap: () -> Void

    // mm:6885:9303 — "Tiêu chuẩn cộng đồng" text link
    var body: some View {
        Button(action: onTap) {
            Text("Tiêu chuẩn cộng đồng")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 0xD4 / 255.0, green: 0x27 / 255.0, blue: 0x1D / 255.0))
                .underline()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 12) {
        WriteKudoTitleField(title: .constant(""))
        WriteKudoCommunityStandardsLink(onTap: {})
    }
    .padding()
    .background(Color(red: 0xFF / 255.0, green: 0xF8 / 255.0, blue: 0xE1 / 255.0))
}
