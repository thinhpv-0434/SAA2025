//
//  SunBrandSShape.swift
//  SAA2025
//
//  Vector-perfect Sun* "S" lightning-bolt brand mark.
//  Used in place of a bitmap asset so the icon stays crisp at any size.
//

import SwiftUI

// MARK: - SunBrandSShape

/// Two stacked parallelograms forming the Sun* "S" / lightning-bolt mark.
/// Designed in a 20×18 reference box (matches Figma group I6885:9058;75:2166;214:3762).
struct SunBrandSShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height

        // Top flag — parallelogram leaning right, top edge slopes down-right
        p.move(to: CGPoint(x: w * 0.08, y: h * 0.02))
        p.addLine(to: CGPoint(x: w * 1.00, y: h * 0.18))
        p.addLine(to: CGPoint(x: w * 0.62, y: h * 0.48))
        p.addLine(to: CGPoint(x: w * 0.00, y: h * 0.36))
        p.closeSubpath()

        // Bottom flag — mirror parallelogram, leaning left
        p.move(to: CGPoint(x: w * 0.38, y: h * 0.52))
        p.addLine(to: CGPoint(x: w * 1.00, y: h * 0.64))
        p.addLine(to: CGPoint(x: w * 0.92, y: h * 0.98))
        p.addLine(to: CGPoint(x: w * 0.00, y: h * 0.82))
        p.closeSubpath()

        return p
    }
}

#Preview {
    ZStack {
        Color.black
        SunBrandSShape()
            .fill(Color(red: 0xE6 / 255.0, green: 0x4A / 255.0, blue: 0x2C / 255.0))
            .frame(width: 200, height: 180)
    }
    .ignoresSafeArea()
}
