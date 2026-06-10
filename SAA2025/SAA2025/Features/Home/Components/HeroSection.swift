//
//  HeroSection.swift
//  SAA2025
//

import SwiftUI

// MARK: - HeroSection

// mm:6885:8983
struct HeroSection: View {

    let remaining: (days: Int, hours: Int, minutes: Int)
    let isEventEnded: Bool
    let onAboutAward: () -> Void
    let onAboutKudos: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // mm:6885:8984
            Image("RootFurtherLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 247, height: 109)

            // mm:6885:8985
            VStack(alignment: .leading, spacing: 12) {
                if !isEventEnded {
                    Text("Coming soon")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .kerning(1.5)
                        .textCase(.uppercase)

                    // mm:6885:8986
                    CountdownCard(
                        days: remaining.days,
                        hours: remaining.hours,
                        minutes: remaining.minutes
                    )
                } else {
                    Text("Sự kiện đã diễn ra")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }

                // mm:6885:9016
                EventInfoCard()
            }

            // mm:6885:9025
            HStack(spacing: 12) {
                // mm:6885:9026
                actionButton(
                    label: "ABOUT AWARD",
                    style: .filled,
                    action: onAboutAward
                )
                // mm:6885:9027
                actionButton(
                    label: "ABOUT KUDOS",
                    style: .outlined,
                    action: onAboutKudos
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: - Private

    private enum ActionButtonStyle { case filled, outlined }

    private func actionButton(label: String, style: ActionButtonStyle, action: @escaping () -> Void) -> some View {
        let isFilled = style == .filled
        return Button(action: action) {
            HStack(spacing: 6) {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .kerning(0.5)
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(isFilled ? Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0) : .white)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isFilled
                          ? Color("saaGold")
                          : Color(red: 1.0, green: 0xEA / 255.0, blue: 0x9E / 255.0).opacity(0.10))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isFilled
                            ? Color.clear
                            : Color(red: 0x99 / 255.0, green: 0x8C / 255.0, blue: 0x5F / 255.0),
                            lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ScrollView {
            HeroSection(
                remaining: (200, 14, 32),
                isEventEnded: false,
                onAboutAward: {},
                onAboutKudos: {}
            )
        }
    }
}
