//
//  NotFoundIllustration.swift
//  SAA2025
//

import SwiftUI

// MARK: - NotFoundIllustration

/// Stylised "404 with seated robot" graphic. Composed entirely from SF
/// Symbols + tinted shapes so we ship without a bespoke PNG.
// mm:6885:9529 — illustration on the iOS Not Found screen
struct NotFoundIllustration: View {

    private static let numberFill = Color(red: 0xEC / 255.0, green: 0xDE / 255.0, blue: 0xCB / 255.0)
    private static let haloFill = Color(red: 0xE6 / 255.0, green: 0xC9 / 255.0, blue: 0xA0 / 255.0).opacity(0.55)
    private static let bodyTan = Color(red: 0xE6 / 255.0, green: 0xC9 / 255.0, blue: 0xA0 / 255.0)
    private static let bodyDark = Color(red: 0x5E / 255.0, green: 0x3A / 255.0, blue: 0x18 / 255.0)
    private static let screenDark = Color(red: 0x2D / 255.0, green: 0x1B / 255.0, blue: 0x0E / 255.0)
    private static let antennaOrange = Color(red: 0xE6 / 255.0, green: 0x6D / 255.0, blue: 0x35 / 255.0)

    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            digitFour
            robot
            digitFour
        }
        .frame(height: 170)
    }

    private var digitFour: some View {
        Text("4")
            .font(.system(size: 110, weight: .black, design: .rounded))
            .foregroundColor(Self.numberFill)
    }

    private var robot: some View {
        ZStack {
            // Halo behind the robot's head
            Circle()
                .fill(Self.haloFill)
                .frame(width: 110, height: 110)
                .offset(y: -10)

            VStack(spacing: 0) {
                antennas
                head
                shoulders
                legs
            }
        }
        .frame(width: 130, height: 170)
    }

    private var antennas: some View {
        HStack(spacing: 10) {
            VStack(spacing: 0) {
                Circle()
                    .fill(Self.antennaOrange)
                    .frame(width: 8, height: 8)
                Rectangle()
                    .fill(Self.bodyDark)
                    .frame(width: 2, height: 10)
            }
            VStack(spacing: 0) {
                Circle()
                    .fill(Self.antennaOrange)
                    .frame(width: 8, height: 8)
                Rectangle()
                    .fill(Self.bodyDark)
                    .frame(width: 2, height: 10)
            }
        }
        .padding(.bottom, 2)
    }

    private var head: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Self.bodyTan)
                .frame(width: 70, height: 56)

            RoundedRectangle(cornerRadius: 4)
                .fill(Self.screenDark)
                .frame(width: 56, height: 30)

            HStack(spacing: 14) {
                Capsule()
                    .fill(Self.bodyTan)
                    .frame(width: 8, height: 4)
                Capsule()
                    .fill(Self.bodyTan)
                    .frame(width: 8, height: 4)
            }
        }
    }

    private var shoulders: some View {
        ZStack {
            Capsule()
                .fill(Self.bodyTan)
                .frame(width: 76, height: 28)

            Text("E")
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundColor(Self.bodyDark)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Self.numberFill)
                )
                .frame(width: 28, height: 28)
        }
        .padding(.top, -4)
    }

    private var legs: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Self.bodyDark)
                .frame(width: 18, height: 18)
            Circle()
                .fill(Self.bodyDark)
                .frame(width: 18, height: 18)
        }
        .padding(.top, 2)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        NotFoundIllustration()
    }
}
