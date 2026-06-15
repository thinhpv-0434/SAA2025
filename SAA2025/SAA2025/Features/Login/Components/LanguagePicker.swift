//
//  LanguagePicker.swift
//  SAA2025
//
//  Created by pham.van.thinh on 8/6/26.
//

import SwiftUI

// MARK: - LanguagePicker

// mm:6885:8976
struct LanguagePicker: View {

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        Menu {
            ForEach(Lang.allCases) { lang in
                Button {
                    localizer.lang = lang
                } label: {
                    Text("\(lang.flag) \(lang.rawValue)")
                }
            }
        } label: {
            pillLabel
        }
    }

    // MARK: - Pill Label

    private var pillLabel: some View {
        HStack(spacing: 4) {
            Text(localizer.lang.flag)
                .font(.system(size: 14))
            Text(localizer.lang.rawValue)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
            Image(systemName: "chevron.down")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.2))
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LanguagePicker()
            .environmentObject(Localizer())
    }
}
