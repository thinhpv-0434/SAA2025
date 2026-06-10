//
//  HomeHeader.swift
//  SAA2025
//

import SwiftUI

// MARK: - HomeHeader

// mm:6885:9057
struct HomeHeader: View {

    @Binding var selectedLang: Lang
    let unreadCount: Int
    let onSearch: () -> Void
    let onBell: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // mm:I6885:9057;88:1827
            Image("SunAALogo")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 44)

            Spacer()

            // mm:I6885:9057;88:1829
            LanguagePicker(selectedLang: $selectedLang)

            // mm:I6885:9057;88:1869
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 32, height: 32)

            // mm:I6885:9057;88:1830
            ZStack(alignment: .topTrailing) {
                Button(action: onBell) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(width: 32, height: 32)

                if unreadCount > 0 {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: 2, y: -2)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HomeHeader(
            selectedLang: .constant(.vn),
            unreadCount: 3,
            onSearch: {},
            onBell: {}
        )
    }
}
