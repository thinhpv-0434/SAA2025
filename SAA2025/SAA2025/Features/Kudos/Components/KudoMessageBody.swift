//
//  KudoMessageBody.swift
//  SAA2025
//
//  mm:6885:10158 — mms_B.4.2_Nội dung (message body — full text, no truncation)
//

import SwiftUI

// MARK: - KudoMessageBody

/// B.4.2 — Full message body text for the Kudo detail view. No line truncation.
// mm:6885:10158 — mms_B.4.2_Nội dung
struct KudoMessageBody: View {

    let message: String

    // mm:6885:10161 — font: Montserrat 10pt regular, color rgba(0,16,26,1)
    private static let textDark = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)

    var body: some View {
        // mm:6885:10161 — text node: Montserrat 10pt, lineHeight 14pt, justified
        Text(message)
            .font(.custom("Montserrat", size: 10))
            .fontWeight(.regular)
            .foregroundColor(Self.textDark)
            .multilineTextAlignment(.leading)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color(red: 0xF5 / 255.0, green: 0xF0 / 255.0, blue: 0xDC / 255.0).ignoresSafeArea()
        KudoMessageBody(message: KudoDetailFixtures.sampleDetail.message)
            .padding(12)
    }
}
