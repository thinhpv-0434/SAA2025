//
//  KudoAttachedImagesGrid.swift
//  SAA2025
//
//  mm:6885:10168 — list (horizontal row of up to 5 attached image thumbnails)
//

import SwiftUI

// MARK: - KudoAttachedImagesGrid

/// F.2 — Horizontal row of up to 5 attached image thumbnails (52pt × 52pt each).
// mm:6885:10168 — list (gap: 4pt, height: 32pt per design — scaled to 52pt for usability)
struct KudoAttachedImagesGrid: View {

    /// Up to 5 image identifiers. For mocks, these are SF Symbol names.
    let imageNames: [String]

    // Thumbnail dimensions matching design (32pt design → 52pt usable)
    private let thumbSize: CGFloat = 52
    private let cornerRadius: CGFloat = 4

    var body: some View {
        // mm:6885:10168 — flex-row, gap 4pt
        HStack(spacing: 4) {
            ForEach(Array(imageNames.prefix(5).enumerated()), id: \.offset) { _, name in
                thumbnailCell(symbolName: name)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Thumbnail Cell

    // mm:I6885:10169;122:5609 — mm_media_image 12 (placeholder)
    private func thumbnailCell(symbolName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color(red: 0xCC / 255.0, green: 0xC4 / 255.0, blue: 0xAA / 255.0))
                .frame(width: thumbSize, height: thumbSize)
            Image(systemName: symbolName)
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0x99 / 255.0, green: 0x90 / 255.0, blue: 0x77 / 255.0))
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color(red: 0xF5 / 255.0, green: 0xF0 / 255.0, blue: 0xDC / 255.0).ignoresSafeArea()
        KudoAttachedImagesGrid(imageNames: KudoDetailFixtures.sampleDetail.attachedImages)
            .padding(12)
    }
}
