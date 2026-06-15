//
//  ProfileIconCollection.swift
//  SAA2025
//

import SwiftUI

// MARK: - ProfileIconCollection

/// Horizontal strip of earned-icon slots below the member card. Six dark
/// circles render under the title "Bộ sưu tập icon của tôi". Slots remain
/// presentational placeholders until the icon catalogue API exists.
// mm:6885:10349 — mms_2_icon collection
struct ProfileIconCollection: View {

    /// Number of slots to render. The design ships six.
    let slotCount: Int

    @EnvironmentObject private var localizer: Localizer

    init(slotCount: Int = 6) {
        self.slotCount = slotCount
    }

    private static let slotFill = Color(red: 0x16 / 255.0, green: 0x1F / 255.0, blue: 0x2A / 255.0)
    private static let slotStroke = Color.white.opacity(0.18)
    private static let slotSize: CGFloat = 44

    var body: some View {
        VStack(spacing: 12) {
            // mm:6885:10350 — list of badge slots
            HStack(spacing: 12) {
                ForEach(0..<slotCount, id: \.self) { _ in
                    slot
                }
            }

            // mm:6885:10357 — mms_A.3_Title
            Text(localizer.t("profile.icon_collection.title"))
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }

    private var slot: some View {
        Circle()
            .fill(Self.slotFill)
            .frame(width: Self.slotSize, height: Self.slotSize)
            .overlay(
                Circle().stroke(Self.slotStroke, lineWidth: 1)
            )
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)
            .ignoresSafeArea()
        ProfileIconCollection()
            .environmentObject(Localizer())
    }
}
