//
//  WriteKudoHashtagSection.swift
//  SAA2025
//
//  E.1 Hashtag Label + E.2 Tag Group
//

import SwiftUI

// MARK: - WriteKudoHashtagSection

struct WriteKudoHashtagSection: View {

    let hashtags: [String]
    let onAddTap: () -> Void
    let onRemove: (String) -> Void

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // mm:6885:9325
            (Text(localizer.t("writkudo.hashtag.label"))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(WriteKudoFieldStyle.labelColor)
             + Text(localizer.t("form.required"))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.red))
                .frame(width: 96, alignment: .leading)
                .padding(.top, 6)

            // mm:6885:9328 — tag group + add button
            FlowLayoutWriteKudo(spacing: 6) {
                ForEach(hashtags, id: \.self) { tag in
                    HashtagPill(text: tag, onRemove: { onRemove(tag) })
                }

                if hashtags.count < KudoDraftLimits.hashtagMax {
                    addButton
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var addButton: some View {
        Button(action: onAddTap) {
            HStack(spacing: 4) {
                Image(systemName: "plus")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(WriteKudoFieldStyle.labelColor)
                Text(localizer.t("writkudo.hashtag.label"))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(WriteKudoFieldStyle.labelColor)
                Text(localizer.t("writkudo.max_5_hint"))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(WriteKudoFieldStyle.helperColor)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: WriteKudoFieldStyle.cornerRadius)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: WriteKudoFieldStyle.cornerRadius)
                            .stroke(WriteKudoFieldStyle.borderColor, lineWidth: WriteKudoFieldStyle.borderWidth)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - HashtagPill (selected tag)

private struct HashtagPill: View {
    let text: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(WriteKudoFieldStyle.labelColor)
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(WriteKudoFieldStyle.helperColor)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(Color.white)
                .overlay(Capsule().stroke(WriteKudoFieldStyle.borderColor, lineWidth: WriteKudoFieldStyle.borderWidth))
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        WriteKudoHashtagSection(hashtags: [], onAddTap: {}, onRemove: { _ in })
        WriteKudoHashtagSection(hashtags: ["#Dedicated", "#Inspiring"], onAddTap: {}, onRemove: { _ in })
    }
    .padding()
    .background(Color(red: 0xFF / 255.0, green: 0xF8 / 255.0, blue: 0xE1 / 255.0))
    .environmentObject(Localizer())
}
