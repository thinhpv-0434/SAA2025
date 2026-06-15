//
//  RecentSearchesHeader.swift
//  SAA2025
//

import SwiftUI

// MARK: - RecentSearchesHeader

/// "Recent" label on the left + underlined gold "View all" link on the right.
/// Rendered above the recent-search rows on the empty-state search screen.
struct RecentSearchesHeader: View {

    let onViewAll: () -> Void

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        HStack {
            Text(localizer.t("search.recent.title"))
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)

            Spacer()

            Button(action: onViewAll) {
                Text(localizer.t("search.recent.view_all"))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color("saaGold"))
                    .underline()
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        RecentSearchesHeader(onViewAll: {})
            .environmentObject(Localizer())
    }
}
