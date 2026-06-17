//
//  HighlightCarousel.swift
//  SAA2025
//

import SwiftUI

// MARK: - HighlightCarousel

// mm:6885:9084 — B: highlight carousel (cards + side fade chevrons + page indicator)
struct HighlightCarousel: View {

    let cards: [KudosCardData]
    @Binding var currentIndex: Int
    let onCopyLink: (KudosCardData) -> Void
    let onDetail: (KudosCardData) -> Void
    let onHashtagTap: (String) -> Void
    let onHeartTap: (KudosCardData) -> Void
    let onPrevious: () -> Void
    let onNext: () -> Void

    // mm:6885:9092 — card width 273 / spacing 12 (Figma).
    private static let cardWidth: CGFloat = 273
    private static let cardSpacing: CGFloat = 12
    private static let cardAreaHeight: CGFloat = 275

    // Background navy used by the side fade gradient (screen background).
    private static let bgNavy = Color(red: 0x00 / 255.0,
                                      green: 0x10 / 255.0,
                                      blue:  0x1A / 255.0)

    var body: some View {
        VStack(spacing: 12) {
            // mm:6885:9090 + 9094/9096 — cards + left/right fade chevrons
            cardScrollArea

            // mm:6885:9098 — B.5: pagination row "< 2/5 >"
            paginationRow
        }
    }

    // MARK: - Card Scroll Area

    private var cardScrollArea: some View {
        ScrollViewReader { proxy in
            GeometryReader { geo in
                let inset = max(0, (geo.size.width - Self.cardWidth) / 2)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Self.cardSpacing) {
                        ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                            KudosCard(
                                card: card,
                                isCarouselVariant: true,
                                onCopyLink: { onCopyLink(card) },
                                onDetail: { onDetail(card) },
                                onHashtagTap: onHashtagTap,
                                onHeartTap: { onHeartTap(card) }
                            )
                            .id(index)
                        }
                    }
                    .padding(.horizontal, inset)
                    .padding(.vertical, 4)
                }
                .onChange(of: currentIndex) { _, newIndex in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo(newIndex, anchor: .center)
                    }
                }
            }
            .frame(height: Self.cardAreaHeight)
            // mm:6885:9096 — left fade overlay + chevron tap target
            .overlay(alignment: .leading)  { sideOverlay(isLeading: true) }
            // mm:6885:9094 — right fade overlay + chevron tap target
            .overlay(alignment: .trailing) { sideOverlay(isLeading: false) }
        }
        .frame(height: Self.cardAreaHeight)
    }

    // mm:6885:9094 / 9096 — fade gradient (navy → transparent) with chevron icon.
    // The gradient hides adjacent-card peek so focus stays on the active card.
    private func sideOverlay(isLeading: Bool) -> some View {
        let canMove = isLeading ? currentIndex > 0 : currentIndex < cards.count - 1
        return Button(action: isLeading ? onPrevious : onNext) {
            ZStack {
                LinearGradient(
                    stops: [
                        .init(color: Self.bgNavy,              location: 0.05),
                        .init(color: Self.bgNavy.opacity(0.5), location: 0.45),
                        .init(color: Self.bgNavy.opacity(0.0), location: 1.0),
                    ],
                    startPoint: isLeading ? .leading : .trailing,
                    endPoint:   isLeading ? .trailing : .leading
                )
                Image(systemName: isLeading ? "chevron.left" : "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(canMove ? 1.0 : 0.35))
                    .frame(maxWidth: .infinity, alignment: isLeading ? .leading : .trailing)
                    .padding(.horizontal, 12)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 56)
        .disabled(!canMove)
        .allowsHitTesting(canMove)
    }

    // MARK: - Pagination Row

    // mm:6885:9098 — B.5: < 2/5 >  (gap 32, plain chevrons, no circle pill)
    private var paginationRow: some View {
        HStack(spacing: 32) {
            // mm:6885:9098;93:2085 — left chevron IC
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(currentIndex > 0 ? .white : .white.opacity(0.3))
                    .frame(width: 24, height: 24)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentIndex == 0)

            // mm:6885:9098;93:2086 — page indicator "2/5" (Montserrat 14 / 700)
            Text("\(currentIndex + 1)/\(cards.count)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .monospacedDigit()

            // mm:6885:9098;93:2087 — right chevron IC
            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(currentIndex < cards.count - 1 ? .white : .white.opacity(0.3))
                    .frame(width: 24, height: 24)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentIndex == cards.count - 1)
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        HighlightCarousel(
            cards: KudosViewModel.mockHighlightCards,
            currentIndex: .constant(1),
            onCopyLink: { _ in },
            onDetail: { _ in },
            onHashtagTap: { _ in },
            onHeartTap: { _ in },
            onPrevious: {},
            onNext: {}
        )
    }
}
