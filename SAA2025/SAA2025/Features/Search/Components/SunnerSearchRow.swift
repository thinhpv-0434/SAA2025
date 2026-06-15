//
//  SunnerSearchRow.swift
//  SAA2025
//

import SwiftUI

// MARK: - SunnerSearchRow

/// One sunner entry in the search list. Reused for both recent searches
/// (with × remove button) and live results (no trailing accessory).
struct SunnerSearchRow: View {

    let result: SunnerSearchResult
    /// When non-nil, a small × button is rendered on the right edge.
    let onRemove: (() -> Void)?
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                avatar
                VStack(alignment: .leading, spacing: 2) {
                    Text(result.displayName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Text(result.employeeCode)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.65))
                }
                Spacer(minLength: 0)

                if let onRemove {
                    Button(action: onRemove) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.65))
                            .padding(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var avatar: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors(for: result.employeeCode)),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 44, height: 44)
            Text(initials)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
    }

    private var initials: String {
        let parts = result.displayName
            .split(whereSeparator: { $0.isWhitespace })
            .map(String.init)
        guard let first = parts.first?.first else { return "?" }
        if parts.count == 1 { return String(first).uppercased() }
        let last = parts.last?.first ?? first
        return "\(first)\(last)".uppercased()
    }

    private func gradientColors(for seed: String) -> [Color] {
        let hash = abs(seed.hashValue)
        switch hash % 3 {
        case 0:
            return [Color(red: 0xE6/255, green: 0x7E/255, blue: 0x2C/255),
                    Color(red: 0x8B/255, green: 0x20/255, blue: 0x20/255)]
        case 1:
            return [Color(red: 0xC9/255, green: 0xA0/255, blue: 0x40/255),
                    Color(red: 0x6B/255, green: 0x35/255, blue: 0x10/255)]
        default:
            return [Color(red: 0xF0/255, green: 0xB0/255, blue: 0x60/255),
                    Color(red: 0x9A/255, green: 0x30/255, blue: 0x18/255)]
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        VStack {
            SunnerSearchRow(result: SearchFixtures.pool[0], onRemove: {}, onTap: {})
            SunnerSearchRow(result: SearchFixtures.pool[1], onRemove: nil, onTap: {})
        }
    }
}
