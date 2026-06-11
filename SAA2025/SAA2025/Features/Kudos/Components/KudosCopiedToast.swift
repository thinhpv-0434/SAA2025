//
//  KudosCopiedToast.swift
//  SAA2025
//
//  Bottom-anchored capsule toast used by Kudos screens to confirm "Copy Link".
//  Auto-dismisses 1.5s after activation.
//

import SwiftUI

// MARK: - KudosCopiedToast

struct KudosCopiedToast: View {

    let isVisible: Bool

    var body: some View {
        if isVisible {
            Text("Đã sao chép")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.black.opacity(0.78)))
                .padding(.bottom, 32)
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

// MARK: - View modifier

extension View {
    /// Attach the Kudos "Copy Link" toast to a screen. The toast appears for ~1.5s
    /// whenever `isVisible` flips to true; caller is responsible for resetting it.
    func kudosCopiedToast(isVisible: Bool) -> some View {
        overlay(alignment: .bottom) {
            KudosCopiedToast(isVisible: isVisible)
        }
    }
}

// MARK: - Trigger helper

@MainActor
enum KudosCopiedToastController {
    /// Shows the toast, schedules a hide after 1.5s. Skips if already visible
    /// (guards against animation stacking on rapid taps).
    static func show(_ binding: Binding<Bool>) {
        guard !binding.wrappedValue else { return }
        withAnimation(.easeOut(duration: 0.25)) { binding.wrappedValue = true }
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.5))
            withAnimation(.easeIn(duration: 0.25)) { binding.wrappedValue = false }
        }
    }
}
