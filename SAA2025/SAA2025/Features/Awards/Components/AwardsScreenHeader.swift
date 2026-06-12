//
//  AwardsScreenHeader.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardsScreenHeader

/// Top-of-screen header for the Awards tab. Mirrors the shared header
/// instance used by the Home screen (SAA logo + language picker + search +
/// notification bell), but scoped to the Awards feature so callbacks land on
/// Awards-specific intents. Per the design (node 6885:10434) the header
/// gradient-fades into the keyvisual background — it does not stand on top
/// of a solid bar.
// mm:6885:10434 — header
struct AwardsScreenHeader: View {

    @Binding var selectedLang: Lang
    let unreadCount: Int
    let onSearch: () -> Void
    let onBell: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // mm:I6885:10434;88:1827 — SAA red star logo
            Image("SunAALogo")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 44)

            Spacer()

            // mm:I6885:10434;88:1829 — language picker (VN flag + chevron)
            LanguagePicker(selectedLang: $selectedLang)

            // mm:I6885:10434;88:1869 — search
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 32, height: 32)

            // mm:I6885:10434;88:1830 — notification bell + dot badge
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
        Color(red: 0x00/255.0, green: 0x10/255.0, blue: 0x1A/255.0)
            .ignoresSafeArea()
        AwardsScreenHeader(
            selectedLang: .constant(.vn),
            unreadCount: 1,
            onSearch: {},
            onBell: {}
        )
    }
}
