//
//  CountdownCard.swift
//  SAA2025
//

import SwiftUI

// MARK: - CountdownCard

// mm:6885:8986
struct CountdownCard: View {

    let days: Int
    let hours: Int
    let minutes: Int

    var body: some View {
        HStack(spacing: 12) {
            // mm:6885:8989
            unit(value: days, label: "DAYS")
            // mm:6885:8998
            unit(value: hours, label: "HOURS")
            // mm:6885:9007
            unit(value: minutes, label: "MINUTES")
        }
    }

    // MARK: - Private

    private func unit(value: Int, label: String) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                ForEach(digits(value), id: \.idx) { item in
                    digitBox(item.char)
                }
            }
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.85))
                .kerning(1.2)
        }
    }

    // mm:6885:8991 — each digit in its own frosted-glass box
    private func digitBox(_ digit: String) -> some View {
        Text(digit)
            .font(.system(size: 32, weight: .bold, design: .monospaced))
            .foregroundColor(.white)
            .frame(width: 32, height: 56)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.10)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(0.5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Self.goldBorder, lineWidth: 0.5)
            )
    }

    private func digits(_ value: Int) -> [(idx: Int, char: String)] {
        let padded = String(format: "%02d", max(0, min(99, value)))
        return Array(padded).enumerated().map { ($0.offset, String($0.element)) }
    }

    private static let goldBorder = Color(red: 1.0, green: 0xEA / 255.0, blue: 0x9E / 255.0)
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CountdownCard(days: 20, hours: 20, minutes: 20)
            .padding()
    }
}
