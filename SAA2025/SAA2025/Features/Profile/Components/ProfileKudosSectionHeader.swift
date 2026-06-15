//
//  ProfileKudosSectionHeader.swift
//  SAA2025
//

import SwiftUI

// MARK: - ProfileKudosSectionHeader

/// "Sun* Annual Awards 2025" subtitle (with hairline divider) + bold gold
/// "KUDOS" title — sits above the filter dropdown on the Profile tab.
// mm:6885:10387 — mms_4_header
struct ProfileKudosSectionHeader: View {

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            VStack(alignment: .leading, spacing: 4) {
                Text(localizer.t("profile.kudos.section.subtitle"))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.85))
                    .kerning(0.5)
                Rectangle()
                    .fill(Color.white.opacity(0.25))
                    .frame(height: 0.5)
            }

            Text(localizer.t("profile.kudos.section.title"))
                .font(.system(size: 26, weight: .black))
                .foregroundColor(Color("saaGold"))
                .kerning(1.2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        ProfileKudosSectionHeader()
            .environmentObject(Localizer())
    }
}
