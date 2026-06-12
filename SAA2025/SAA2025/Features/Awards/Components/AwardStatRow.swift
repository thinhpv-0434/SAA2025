//
//  AwardStatRow.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardStatRow

/// Reusable stat row used inside the Award Information Block — icon + label
/// on the left, value (plus optional sub-line) on the right. Used twice:
/// quantity ("Số lượng giải thưởng" / "02 Tập thể") and value
/// ("Giá trị giải thưởng" / "15.000.000 VNĐ" / "cho mỗi giải thưởng").
struct AwardStatRow: View {

    let iconSystemName: String
    let label: String
    let primaryValue: String
    let secondaryValue: String?

    init(iconSystemName: String,
         label: String,
         primaryValue: String,
         secondaryValue: String? = nil) {
        self.iconSystemName = iconSystemName
        self.label = label
        self.primaryValue = primaryValue
        self.secondaryValue = secondaryValue
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Icon + label
            HStack(spacing: 8) {
                Image(systemName: iconSystemName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("saaGold"))
                    .frame(width: 20)

                Text(label)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(2)
            }

            Spacer(minLength: 8)

            // Value column
            VStack(alignment: .trailing, spacing: 2) {
                Text(primaryValue)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                if let sub = secondaryValue, !sub.isEmpty {
                    Text(sub)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00/255.0, green: 0x10/255.0, blue: 0x1A/255.0)
            .ignoresSafeArea()
        VStack(spacing: 0) {
            AwardStatRow(
                iconSystemName: "diamond.fill",
                label: "Số lượng giải thưởng",
                primaryValue: "02 Tập thể"
            )
            Divider().background(Color(red: 0x2E/255.0, green: 0x39/255.0, blue: 0x40/255.0))
            AwardStatRow(
                iconSystemName: "flag.fill",
                label: "Giá trị giải thưởng",
                primaryValue: "15.000.000 VNĐ",
                secondaryValue: "cho mỗi giải thưởng"
            )
        }
        .padding(.horizontal, 24)
    }
}
