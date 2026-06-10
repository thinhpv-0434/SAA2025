//
//  TopRecipientsBlock.swift
//  SAA2025
//

import SwiftUI

// MARK: - TopRecipientsBlock

// mm:6885:D.3 — "10 SUNNER NHẬN QUÀ MỚI NHẤT" boxed list
struct TopRecipientsBlock: View {

    let recipients: [GiftRecipient]

    private static let bg = Color(red: 0x0E / 255.0, green: 0x16 / 255.0, blue: 0x22 / 255.0)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // mm:6885:D.3.1 — section title inside box
            Text("10 SUNNER NHẬN QUÀ MỚI NHẤT")
                .font(.system(size: 13, weight: .black))
                .foregroundColor(.white)
                .kerning(0.5)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.05))

            // mm:6885:D.3.2 — recipient rows
            ForEach(Array(recipients.enumerated()), id: \.element.id) { index, recipient in
                recipientRow(recipient)
                if index < recipients.count - 1 {
                    Divider()
                        .background(Color.white.opacity(0.08))
                        .padding(.horizontal, 16)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Self.bg)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
    }

    // MARK: - Row

    // mm:6885:D.3.2 — individual gift recipient row
    private func recipientRow(_ recipient: GiftRecipient) -> some View {
        HStack(spacing: 12) {
            // Avatar placeholder
            ZStack {
                Circle()
                    .fill(Color(red: 0.3, green: 0.45, blue: 0.6))
                    .frame(width: 40, height: 40)
                Image(systemName: "person.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                // Name
                Text(recipient.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                // Reward description
                Text(recipient.rewardDescription)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        TopRecipientsBlock(recipients: [
            GiftRecipient(id: UUID(), name: "Huỳnh Dương Xuân", department: "phòng SAA", rewardDescription: "Nhận được 1 áo phỏng SAA"),
            GiftRecipient(id: UUID(), name: "Dương Xuân Huỳnh", department: "phòng SAA", rewardDescription: "Nhận được 1 áo phỏng SAA"),
            GiftRecipient(id: UUID(), name: "Huỳnh Dương Xuân", department: "SA", rewardDescription: "Nhận được 1 áo phỏng SAA")
        ])
        .padding(.vertical, 16)
    }
}
