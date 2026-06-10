//
//  FloatingActionButton.swift
//  SAA2025
//

import SwiftUI

// MARK: - FloatingActionButton

// mm:6885:9058
struct FloatingActionButton: View {

    let onWriteKudo: () -> Void
    let onKudosFeed: () -> Void

    @State private var isExpanded: Bool = false

    var body: some View {
        // mm:I6885:9058;75:2162 — gold pill, 89×48, pen / S-logo
        HStack(spacing: 8) {
            // mm:I6885:9058;75:2163 — pen + "/" separator (write kudo target)
            Button(action: guardedWriteKudo) {
                HStack(spacing: 8) {
                    // mm:I6885:9058;75:2164 — MM_MEDIA_Pen (compose-style SF symbol)
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Self.iconNavy)
                        .frame(width: 24, height: 24)
                    // mm:I6885:9058;75:2165 — slash separator
                    Text("/")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(Self.iconNavy)
                }
            }
            .buttonStyle(PlainButtonStyle())

            // mm:I6885:9058;75:2166 — Sun* Kudos S brand mark (vector Shape, crisp at any scale)
            Button(action: onKudosFeed) {
                SunBrandSShape()
                    .fill(Self.kudosRed)
                    .frame(width: 20, height: 18)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(8)
        .background(
            Capsule()
                .fill(Self.fabGold)
                .shadow(color: Self.fabGlow.opacity(0.6), radius: 6, x: 0, y: 0)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
        )
    }

    // MARK: - Double-tap guard

    private func guardedWriteKudo() {
        guard !isExpanded else { return }
        isExpanded = true
        onWriteKudo()
        Task {
            try? await Task.sleep(for: .milliseconds(500))
            isExpanded = false
        }
    }

    private static let iconNavy = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)
    private static let kudosRed = Color(red: 0xE6 / 255.0, green: 0x4A / 255.0, blue: 0x2C / 255.0)
    private static let fabGold = Color(red: 1.0, green: 0xEA / 255.0, blue: 0x9E / 255.0)
    private static let fabGlow = Color(red: 0xFA / 255.0, green: 0xE2 / 255.0, blue: 0x87 / 255.0)
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            Spacer()
            HStack {
                Spacer()
                FloatingActionButton(onWriteKudo: {}, onKudosFeed: {})
                    .padding(.trailing, 20)
                    .padding(.bottom, 32)
            }
        }
    }
}
