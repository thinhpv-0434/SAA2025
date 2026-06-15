//
//  WriteKudoSentToast.swift
//  SAA2025
//
//  Bottom-anchored capsule toast — "Đã gửi Kudos".
//  Same visual language as KudosCopiedToast.
//

import SwiftUI

// MARK: - WriteKudoSentToast

struct WriteKudoSentToast: View {

    let isVisible: Bool

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        if isVisible {
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.green)
                Text(localizer.t("toast.kudo_sent"))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Capsule().fill(Color.black.opacity(0.78)))
            .padding(.bottom, 60)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

// MARK: - View modifier

extension View {
    /// Attach the "Đã gửi Kudos" success toast. The container animates
    /// visibility; caller resets the binding when the screen dismisses.
    func kudosSentToast(isVisible: Bool) -> some View {
        overlay(alignment: .bottom) {
            WriteKudoSentToast(isVisible: isVisible)
                .animation(.easeOut(duration: 0.25), value: isVisible)
        }
    }
}
