//
//  WriteKudoRecipientField.swift
//  SAA2025
//
//  B.1 Recipient Label + B.2 Recipient Dropdown
//

import SwiftUI

// MARK: - WriteKudoRecipientField

struct WriteKudoRecipientField: View {

    let recipient: KudosUser?
    let onTap: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            // mm:6885:9294 — "Người nhận *"
            requiredLabel(text: "Người nhận")
                .frame(width: 96, alignment: .leading)

            // mm:6885:9297 — dropdown row
            Button(action: onTap) {
                HStack(spacing: 8) {
                    Text(recipient?.name ?? "Tìm kiếm")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(recipient == nil
                                         ? WriteKudoFieldStyle.helperColor
                                         : WriteKudoFieldStyle.labelColor)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(WriteKudoFieldStyle.helperColor)
                }
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
            .buttonStyle(PlainButtonStyle())
        }
    }

    @ViewBuilder
    private func requiredLabel(text: String) -> some View {
        (Text(text)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(WriteKudoFieldStyle.labelColor)
         + Text(" *")
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.red))
    }
}

#Preview {
    VStack(spacing: 12) {
        WriteKudoRecipientField(recipient: nil, onTap: {})
        WriteKudoRecipientField(
            recipient: KudosUser(id: UUID(), name: "Huỳnh Dương Xuân", employeeCode: "CECV10", department: "Division A", badgeLabel: nil, badgeTier: .none),
            onTap: {}
        )
    }
    .padding()
    .background(Color(red: 0xFF / 255.0, green: 0xF8 / 255.0, blue: 0xE1 / 255.0))
}
