//
//  MarkAllReadButton.swift
//  SAA2025
//

import SwiftUI

// MARK: - MarkAllReadButton

/// Plain text-style action button at the top of the notifications list —
/// horizontal-lines icon + "Đánh dấu đọc tất cả" label.
// mm:6885:9392 — mms_Button_read all
struct MarkAllReadButton: View {

    let onTap: () -> Void

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))

                Text(localizer.t("notifications.mark_all_read"))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        MarkAllReadButton(onTap: {})
            .environmentObject(Localizer())
    }
}
