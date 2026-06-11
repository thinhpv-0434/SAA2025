//
//  KudosScreenHeaderBar.swift
//  SAA2025
//
//  Shared top-of-screen header bar for the Kudos feature.
//  Used by both `KudosDetailView` (mm:6885:10133) and `KudosOverviewView`
//  (mm:6891:15996) so the two screens stay format-identical.
//

import SwiftUI

// MARK: - KudosScreenHeaderBar

/// 44pt tall transparent header with a centered title and a leading back chevron.
/// Designed to be the first child of a VStack inside a screen that hides the
/// system navigation bar (`.toolbar(.hidden, for: .navigationBar)`).
struct KudosScreenHeaderBar: View {

    let title: String
    let onBack: () -> Void

    var body: some View {
        ZStack {
            // Centered title (background layer of ZStack)
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)

            // Leading back button (overlay layer)
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 8)
    }
}
