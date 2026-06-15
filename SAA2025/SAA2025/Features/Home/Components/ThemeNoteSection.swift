//
//  ThemeNoteSection.swift
//  SAA2025
//

import SwiftUI

// MARK: - ThemeNoteSection

// mm:6885:9028
struct ThemeNoteSection: View {

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        // mm:6885:9029
        Text(localizer.t("home.theme.note"))
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.white.opacity(0.9))
            .lineSpacing(5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ThemeNoteSection()
            .environmentObject(Localizer())
    }
}
