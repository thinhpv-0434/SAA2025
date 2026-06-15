//
//  ReceivedKudosCountLabel.swift
//  SAA2025
//

import SwiftUI

// MARK: - ReceivedKudosCountLabel

/// Non-interactive gold-bordered pill that summarises how many kudos the
/// viewed sunner has received. Mirrors the visual of `AwardDropdownButton`
/// but drops the chevron — there is no menu on the "other person" profile,
/// since you cannot view someone else's sent kudos.
// mm:6885:10419 — mms_7_dropdown (read-only on this screen)
struct ReceivedKudosCountLabel: View {

    let count: Int

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        Text(label)
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(AwardDropdownStyle.textColor)
            .lineLimit(1)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: AwardDropdownStyle.cornerRadius)
                    .fill(AwardDropdownStyle.backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AwardDropdownStyle.cornerRadius)
                    .stroke(AwardDropdownStyle.borderColor, lineWidth: 1)
            )
    }

    private var label: String {
        "\(localizer.t("profile.other.received_kudos.prefix"))\(count)\(localizer.t("profile.other.received_kudos.suffix"))"
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        ReceivedKudosCountLabel(count: 5)
            .environmentObject(Localizer())
    }
}
