//
//  WriteKudoImageSection.swift
//  SAA2025
//
//  F Image Section + F.1 Label + F.2 Thumbnails + F.5 Add Image Button
//

import SwiftUI

// MARK: - WriteKudoImageSection

struct WriteKudoImageSection: View {

    let images: [KudoImageAttachment]
    let onAddTap: () -> Void
    let onRemove: (UUID) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // mm:6885:9347 — "Image"
            Text("Image")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(WriteKudoFieldStyle.labelColor)
                .frame(width: 96, alignment: .leading)
                .padding(.top, 6)

            // mm:6885:9346 — thumbnails + add
            FlowLayoutWriteKudo(spacing: 6) {
                ForEach(images) { attachment in
                    thumbnail(attachment: attachment)
                }
                if images.count < KudoDraftLimits.imageMax {
                    addButton
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Sub-views

    @ViewBuilder
    private func thumbnail(attachment: KudoImageAttachment) -> some View {
        // mm:6885:9352/9353/9354/9356 — image thumbnail with remove
        ZStack(alignment: .topTrailing) {
            Image(attachment.assetName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(WriteKudoFieldStyle.borderColor, lineWidth: WriteKudoFieldStyle.borderWidth)
                )

            Button(action: { onRemove(attachment.id) }) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0xD4 / 255.0, green: 0x27 / 255.0, blue: 0x1D / 255.0))
                        .frame(width: 14, height: 14)
                    Image(systemName: "xmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .offset(x: 4, y: -4)
        }
    }

    // mm:6885:9355 — "+ Image (Tối đa 5)"
    private var addButton: some View {
        Button(action: onAddTap) {
            HStack(spacing: 4) {
                Image(systemName: "plus")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(WriteKudoFieldStyle.labelColor)
                Text("Image")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(WriteKudoFieldStyle.labelColor)
                Text("(Tối đa 5)")
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

#Preview {
    WriteKudoImageSection(
        images: [
            KudoImageAttachment(assetName: "KudosBanner"),
            KudoImageAttachment(assetName: "KudosBanner"),
            KudoImageAttachment(assetName: "KudosBanner"),
            KudoImageAttachment(assetName: "KudosBanner")
        ],
        onAddTap: {},
        onRemove: { _ in }
    )
    .padding()
    .background(Color(red: 0xFF / 255.0, green: 0xF8 / 255.0, blue: 0xE1 / 255.0))
}
