//
//  SecretBoxPedestal.swift
//  SAA2025
//

import SwiftUI

// MARK: - SecretBoxPedestal

/// Shared gold-rim pedestal used as the base for every Secret Box
/// illustration (unopened gift box, opening burst, revealed reward).
/// Two concentric rounded shapes give the "round stage" feel from the
/// Figma artwork.
struct SecretBoxPedestal: View {

    var body: some View {
        VStack(spacing: -8) {
            Ellipse()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0x4E / 255.0, green: 0x37 / 255.0, blue: 0x10 / 255.0),
                            Color(red: 0x1A / 255.0, green: 0x11 / 255.0, blue: 0x06 / 255.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 220, height: 26)
                .overlay(
                    Ellipse()
                        .stroke(
                            Color(red: 0xC9 / 255.0, green: 0x9A / 255.0, blue: 0x3A / 255.0),
                            lineWidth: 2
                        )
                )

            Ellipse()
                .fill(Color.black.opacity(0.55))
                .frame(width: 180, height: 18)
                .overlay(
                    Ellipse()
                        .stroke(
                            Color(red: 0xC9 / 255.0, green: 0x9A / 255.0, blue: 0x3A / 255.0).opacity(0.5),
                            lineWidth: 1
                        )
                )
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        SecretBoxPedestal()
    }
}
