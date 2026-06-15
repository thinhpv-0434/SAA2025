//
//  AccessDeniedIllustration.swift
//  SAA2025
//

import SwiftUI

// MARK: - AccessDeniedIllustration

/// Stylised "blocked screen" graphic — composes a desktop monitor with a
/// person silhouette inside it and a padlock + warning badge in the corner.
/// Composed from SF Symbols + tinted shapes so no bespoke asset is required.
// mm:6885:9529 — mms_2.1_mm_media_Not Found
struct AccessDeniedIllustration: View {

    private static let monitorFrame = Color(red: 0x55 / 255.0, green: 0x66 / 255.0, blue: 0x72 / 255.0)
    private static let screenFill = Color(red: 0xC9 / 255.0, green: 0x6A / 255.0, blue: 0x3A / 255.0)
    private static let personSkin = Color(red: 0xE6 / 255.0, green: 0xB0 / 255.0, blue: 0x7E / 255.0)
    private static let personHair = Color(red: 0x6E / 255.0, green: 0x39 / 255.0, blue: 0x14 / 255.0)
    private static let personShirt = Color(red: 0x6E / 255.0, green: 0x2A / 255.0, blue: 0x2A / 255.0)
    private static let badgeBg = Color.white
    private static let lockColor = Color(red: 0xC9 / 255.0, green: 0x8A / 255.0, blue: 0x3A / 255.0)
    private static let warningColor = Color(red: 0xE6 / 255.0, green: 0x3A / 255.0, blue: 0x3A / 255.0)

    var body: some View {
        VStack(spacing: 0) {
            monitor
            stand
            base
        }
        .frame(width: 200, height: 180)
    }

    private var monitor: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Self.monitorFrame)
                .frame(width: 200, height: 130)

            RoundedRectangle(cornerRadius: 4)
                .fill(Self.screenFill)
                .frame(width: 184, height: 114)

            personSilhouette
                .frame(width: 184, height: 114)
                .clipShape(RoundedRectangle(cornerRadius: 4))

            // Lock + warning badge in bottom-right corner of the screen
            badge
                .offset(x: 60, y: 30)
        }
    }

    private var personSilhouette: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: -4) {
                Spacer()
                // Hair cap
                Circle()
                    .fill(Self.personHair)
                    .frame(width: 60, height: 60)
                    .offset(y: 12)

                // Face
                Circle()
                    .fill(Self.personSkin)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Circle()
                            .fill(Self.personHair)
                            .frame(width: 56, height: 16)
                            .offset(y: -20)
                    )
            }
            // Shoulders (rounded bar across bottom)
            RoundedRectangle(cornerRadius: 18)
                .fill(Self.personShirt)
                .frame(width: 130, height: 50)
                .offset(y: 24)
        }
    }

    private var badge: some View {
        ZStack {
            Circle()
                .fill(Self.badgeBg)
                .frame(width: 44, height: 44)

            Image(systemName: "lock.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Self.lockColor)
                .offset(x: -5, y: 0)

            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Self.warningColor)
                .offset(x: 10, y: 6)
        }
    }

    private var stand: some View {
        Trapezoid()
            .fill(Self.monitorFrame)
            .frame(width: 50, height: 22)
    }

    private var base: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Self.monitorFrame)
            .frame(width: 90, height: 8)
    }
}

// MARK: - Trapezoid

/// Simple trapezoid for the monitor stand — wider at the bottom.
private struct Trapezoid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let inset = rect.width * 0.3
        path.move(to: CGPoint(x: inset, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - inset, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        AccessDeniedIllustration()
    }
}
