//
//  HighlightCarousel.swift
//  SAA2025
//

import SwiftUI

// MARK: - HighlightCarousel

// mm:6885:9083 — B.2/B.3: horizontal paged carousel of highlight kudos cards
struct HighlightCarousel: View {

    let cards: [KudosCardData]
    @Binding var currentIndex: Int
    let onCopyLink: (KudosCardData) -> Void
    let onDetail: (KudosCardData) -> Void
    let onHashtagTap: (String) -> Void
    let onHeartTap: (KudosCardData) -> Void
    let onPrevious: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // mm:6885:9083 — card scroll area
            cardScrollArea

            // mm:6885:9097 — B.5: pagination row (chevron < | 2/5 | chevron >)
            paginationRow
        }
    }

    // MARK: - Card Scroll Area

    private var cardScrollArea: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
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
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
            .onChange(of: currentIndex) { _, newIndex in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(newIndex, anchor: .center)
                }
            }
        }
    }

    // MARK: - Pagination Row

    // mm:6885:9095 — B.5: < 2/5 >
    private var paginationRow: some View {
        HStack(spacing: 16) {
            // mm:6885:9095 — B.5.1 left chevron
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(currentIndex > 0 ? .white : .white.opacity(0.3))
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(Color.white.opacity(0.10)))
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentIndex == 0)

            // mm:6885:B.5.2 — page indicator text "2/5"
            Text("\(currentIndex + 1)/\(cards.count)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.85))
                .monospacedDigit()

            // mm:6885:9097 — B.5.3 right chevron
            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(currentIndex < cards.count - 1 ? .white : .white.opacity(0.3))
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(Color.white.opacity(0.10)))
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
