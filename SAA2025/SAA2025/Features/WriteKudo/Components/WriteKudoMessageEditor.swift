//
//  WriteKudoMessageEditor.swift
//  SAA2025
//
//  D Kudo Message Text Area + D.1 mention hint label
//

import SwiftUI

// MARK: - WriteKudoMessageEditor

struct WriteKudoMessageEditor: View {

    @Binding var message: String
    let onAwardsInfoTap: () -> Void

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            VStack(spacing: 0) {
                // mm:6885:9306 — toolbar (top)
                WriteKudoFormatToolbar(onAwardsInfoTap: onAwardsInfoTap)

                // mm:6885:9322 — message text area
                ZStack(alignment: .topLeading) {
                    if message.isEmpty {
                        Text(localizer.t("writkudo.field.message.placeholder"))
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(WriteKudoFieldStyle.helperColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .allowsHitTesting(false)
                    }

                    TextEditor(text: $message)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(WriteKudoFieldStyle.labelColor)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .frame(minHeight: 96, maxHeight: 140)
                }
                .background(Color.white)
                .overlay(
                    Rectangle()
                        .stroke(WriteKudoFieldStyle.borderColor, lineWidth: WriteKudoFieldStyle.borderWidth)
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: WriteKudoFieldStyle.cornerRadius,
                        bottomTrailingRadius: WriteKudoFieldStyle.cornerRadius,
                        topTrailingRadius: 0
                    )
                )
            }

            // mm:(no node) — mention hint
            Text(mentionHintAttributed)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(WriteKudoFieldStyle.helperColor)
                .padding(.top, 2)
        }
    }

    /// Renders the mention hint with the inner "@ + name" literal emphasised.
    private var mentionHintAttributed: AttributedString {
        var leading = AttributedString(localizer.t("writkudo.hint.mention.prefix"))
        leading.foregroundColor = WriteKudoFieldStyle.helperColor

        var mention = AttributedString(localizer.t("writkudo.hint.mention.syntax"))
        mention.foregroundColor = WriteKudoFieldStyle.labelColor

        var trailing = AttributedString(localizer.t("writkudo.hint.mention.suffix"))
        trailing.foregroundColor = WriteKudoFieldStyle.helperColor

        return leading + mention + trailing
    }
}

#Preview {
    WriteKudoMessageEditor(message: .constant(""), onAwardsInfoTap: {})
        .padding()
        .background(Color(red: 0xFF / 255.0, green: 0xF8 / 255.0, blue: 0xE1 / 255.0))
        .environmentObject(Localizer())
}
