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

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: -12) {
                content
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: 320, height: 280)
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
        if includeSparkle {
            ZStack {
                // Body
                Image("Boximageopen")
                    .font(.system(size: 130, weight: .regular))
            }
            .padding(.bottom, 12)
        } else {
            ZStack {
                // Body
                Image("Boximage")
                    .font(.system(size: 130, weight: .regular))
            }
            .padding(.bottom, 12)
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
            // Body
            Image("stampmedia")
                .font(.system(size: 130, weight: .regular))
        }
        .padding(.bottom, 12)
    }

    private var mugArt: some View {
        ZStack {
            // Body
            Image("mugimage")
                .font(.system(size: 130, weight: .regular))
        }
        .padding(.bottom, 12)
    }

    private var scarfArt: some View {
        ZStack {
            // Body
            Image("scarfimage")
                .font(.system(size: 130, weight: .regular))
        }
        .padding(.bottom, 12)
    }

    private var tshirtArt: some View {
        ZStack {
            // Body
            Image("tshirtImage")
                .font(.system(size: 130, weight: .regular))
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
