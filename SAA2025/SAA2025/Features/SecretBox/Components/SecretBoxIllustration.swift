//
//  SecretBoxIllustration.swift
//  SAA2025
//

import SwiftUI

// MARK: - SecretBoxIllustration

/// Renders the centerpiece artwork for whatever `SecretBoxState` the
/// view-model is in. Designed to slot into a 320×320 stage on the screen.
/// Each state mirrors one of the Figma frames — the unopened gift box
/// (mm:6885:9402), the lifted/opening crate, and the variety of reveal
/// payloads (mm:6885:9577..9839).
struct SecretBoxIllustration: View {

    let state: SecretBoxState

    private static let goldDark = Color(red: 0xC9 / 255.0, green: 0x9A / 255.0, blue: 0x3A / 255.0)
    private static let goldLight = Color(red: 0xF4 / 255.0, green: 0xCC / 255.0, blue: 0x4B / 255.0)
    private static let boxDark = Color(red: 0x14 / 255.0, green: 0x0C / 255.0, blue: 0x04 / 255.0)

    var body: some View {
        ZStack(alignment: .bottom) {
            glow
                .opacity(opacityForGlow)

            VStack(spacing: -12) {
                content
                SecretBoxPedestal()
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: 320, height: 280)
    }

    // MARK: - Glow

    private var glow: some View {
        RadialGradient(
            gradient: Gradient(colors: [
                Self.goldLight.opacity(0.55),
                Self.goldLight.opacity(0.10),
                .clear
            ]),
            center: .center,
            startRadius: 4,
            endRadius: 160
        )
        .frame(width: 320, height: 220)
        .offset(y: -10)
    }

    private var opacityForGlow: Double {
        switch state {
        case .unopened: return 0.55
        case .opening:  return 0.85
        case .revealed: return 0.85
        }
    }

    // MARK: - State-driven content

    @ViewBuilder
    private var content: some View {
        switch state {
        case .unopened:
            wrappedGiftBox(includeSparkle: true)
        case .opening:
            wrappedGiftBox(includeSparkle: false)
        case .revealed(let reward):
            revealedArt(for: reward)
                .padding(.bottom, 4)
        }
    }

    // MARK: - Gift box (unopened / opening)

    private func wrappedGiftBox(includeSparkle: Bool) -> some View {
        ZStack {
            VStack(spacing: 0) {
                // Lid
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Self.boxDark)
                        .frame(width: 140, height: 30)
                    Rectangle()
                        .fill(Self.goldDark)
                        .frame(width: 14, height: 30)
                }
                // Body
                ZStack {
                    Rectangle()
                        .fill(Self.boxDark)
                        .frame(width: 124, height: 110)
                    Rectangle()
                        .fill(Self.goldDark)
                        .frame(width: 14, height: 110)
                }
            }

            // Ribbon top
            VStack {
                Image(systemName: "rosette")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Self.goldLight, Self.goldDark]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .offset(y: -22)
                Spacer()
            }
            .frame(height: 140)

            if includeSparkle {
                sparkles
                    .offset(x: 70, y: -10)
            }
        }
        .frame(width: 180, height: 160)
    }

    private var sparkles: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { i in
                Circle()
                    .fill(Self.goldLight)
                    .frame(width: i.isMultiple(of: 2) ? 4 : 2,
                           height: i.isMultiple(of: 2) ? 4 : 2)
                    .offset(
                        x: CGFloat([0, 18, 36, 12, 28, -8, 22, 6][i]),
                        y: CGFloat([0, -8, 6, 20, 30, -16, 14, -2][i])
                    )
            }
        }
    }

    // MARK: - Reward art

    @ViewBuilder
    private func revealedArt(for reward: SecretBoxReward) -> some View {
        switch reward {
        case .icon(_, let center, let edge):
            iconBadge(centerColor: center, edgeColor: edge)
        case .item(_, let kind):
            switch kind {
            case .stamps:  stampsArt
            case .mug:     mugArt
            case .scarf:   scarfArt
            case .tshirt:  tshirtArt
            }
        }
    }

    private func iconBadge(centerColor: Color, edgeColor: Color) -> some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [centerColor, edgeColor]),
                        center: .center,
                        startRadius: 4,
                        endRadius: 80
                    )
                )
                .frame(width: 130, height: 130)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.45), lineWidth: 2)
                )

            Text("SAA")
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(.bottom, 12)
    }

    private var stampsArt: some View {
        ZStack {
            stamp(color: Color(red: 0xC9 / 255.0, green: 0x4A / 255.0, blue: 0x3A / 255.0))
                .rotationEffect(.degrees(-10))
                .offset(x: -38, y: -10)
            stamp(color: Color(red: 0x3A / 255.0, green: 0x5A / 255.0, blue: 0xC9 / 255.0))
                .rotationEffect(.degrees(8))
                .offset(x: 30, y: 12)
            stamp(color: Color(red: 0xE6 / 255.0, green: 0xB6 / 255.0, blue: 0x3A / 255.0))
                .rotationEffect(.degrees(-2))
        }
        .padding(.bottom, 12)
    }

    private func stamp(color: Color) -> some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white)
                .frame(width: 56, height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.6), style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                )
            Rectangle()
                .fill(color)
                .frame(width: 50, height: 38)
                .padding(.bottom, 18)
            Text("ROOT\nFURTHER")
                .font(.system(size: 6, weight: .heavy))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.bottom, 4)
        }
        .frame(width: 56, height: 70)
    }

    private var mugArt: some View {
        ZStack {
            // Handle
            RoundedRectangle(cornerRadius: 14)
                .stroke(Self.boxDark, lineWidth: 8)
                .frame(width: 36, height: 56)
                .offset(x: -52, y: 4)

            // Body
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Self.boxDark)
                    .frame(width: 110, height: 110)

                Text("ROOT\nFURTHER")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .offset(x: 4, y: 0)
        }
        .padding(.bottom, 12)
    }

    private var scarfArt: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0x16 / 255.0, green: 0x3A / 255.0, blue: 0x40 / 255.0),
                            Color(red: 0x0A / 255.0, green: 0x1F / 255.0, blue: 0x22 / 255.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 130, height: 130)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.7), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                        .padding(8)
                )

            Text("ROOT\nFURTHER")
                .font(.system(size: 16, weight: .heavy))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 12)
    }

    private var tshirtArt: some View {
        ZStack {
            // Body
            Image(systemName: "tshirt.fill")
                .font(.system(size: 130, weight: .regular))
                .foregroundColor(Color(red: 0x0E / 255.0, green: 0x0E / 255.0, blue: 0x0E / 255.0))

            Text("SAA 2025")
                .font(.system(size: 12, weight: .heavy))
                .foregroundColor(.white)
        }
        .padding(.bottom, 12)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        VStack(spacing: 24) {
            SecretBoxIllustration(state: .unopened)
            SecretBoxIllustration(state: .revealed(.item(name: "Khăn Root Further", kind: .scarf)))
        }
    }
}
