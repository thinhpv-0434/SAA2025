//
//  KudosDetailView.swift
//  SAA2025
//
//  mm:6885:10128 — [iOS] Sun*Kudos_View kudo (root frame)
//  MoMorph: fileKey=9ypp4enmFmdK3YAFJLIu6C screenId=T0TR16k0vH
//

import SwiftUI

// MARK: - KudosDetailView

/// Read-only Kudo detail screen.
/// - Heart toggle is local `@State` (per clarifications.md — no parent sync this iteration).
/// - Copy Link writes `saa2025://kudos/{id}` to `UIPasteboard.general` and shows a toast.
/// - Hashtag tap is a no-op closure surface for callers; no navigation yet.
// mm:6885:10128
struct KudosDetailView: View {

    let onBack: () -> Void

    @State private var kudo: KudoDetail
    @State private var showCopiedToast: Bool = false

    init(detail: KudoDetail, onBack: @escaping () -> Void = {}) {
        self.onBack = onBack
        self._kudo = State(initialValue: detail)
    }

    // Design tokens (matched to Figma)
    private static let navy       = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)
    private static let cardBorder = Color(red: 0xFF / 255.0, green: 0xEA / 255.0, blue: 0x9E / 255.0)
    private static let highlight  = Color(red: 0xFF / 255.0, green: 0xF8 / 255.0, blue: 0xE1 / 255.0)
    private static let textDark   = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)
    private static let textMid    = Color(red: 0x99 / 255.0, green: 0x99 / 255.0, blue: 0x99 / 255.0)

    var body: some View {
        VStack(spacing: 0) {
            // mm:6885:10133 — shared header bar (format matches KudosOverviewView)
            KudosScreenHeaderBar(title: "Kudo", onBack: onBack)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // mm:6885:10147 — content card
                    kudoCard
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                }
            }
        }
        // mm:6885:10129 — key-visual painted via `.background` so its internal
        // `.ignoresSafeArea()` fills edge-to-edge without extending the host's frame.
        // Treating `detailBackground` as a ZStack child pushes the bottom frame into
        // the safe area and causes the Copy Link toast to hide behind the tab bar.
        .background { detailBackground }
        .toolbar(.hidden, for: .navigationBar)
        .kudosCopiedToast(isVisible: showCopiedToast)
    }

    // MARK: - Background

    // mm:6885:10129 — mm_media_bg (Shadow Left + Keyvisual + Shadow Bottom)
    private var detailBackground: some View {
        ZStack(alignment: .top) {
            Self.navy.ignoresSafeArea()

            Image("KeyvisualBG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity, alignment: .top)
                .clipped()
                .ignoresSafeArea(edges: .top)

            // mm:6885:10131 / 10132 — shadow gradients fading to navy near the bottom
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Self.navy.opacity(0.0), location: 0.0),
                    .init(color: Self.navy.opacity(0.55), location: 0.6),
                    .init(color: Self.navy, location: 0.9)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }

    // MARK: - Kudo Card

    // mm:6885:10148 — mms_B.3_KUDO - Highlight container
    private var kudoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            // mm:6885:10149 — sender ➜ receiver
            KudoSenderReceiverHighlight(sender: kudo.sender, receiver: kudo.receiver)

            // mm:6885:10154 — divider
            Rectangle()
                .fill(Color.black.opacity(0.08))
                .frame(height: 1)

            // mm:6885:10155 — postedAt
            Text(kudo.postedAt)
                .font(.custom("Montserrat", size: 10))
                .fontWeight(.medium)
                .foregroundColor(Self.textMid)
                .kerning(0.23)

            // mm:6885:10156 — title
            Text(kudo.title)
                .font(.custom("Montserrat", size: 10))
                .fontWeight(.bold)
                .foregroundColor(Self.textDark)
                .multilineTextAlignment(.center)
                .kerning(0.23)
                .frame(maxWidth: .infinity, alignment: .center)

            // mm:6885:10157 — content body, images, hashtags
            VStack(alignment: .leading, spacing: 8) {
                KudoMessageBody(message: kudo.message)

                if !kudo.attachedImages.isEmpty {
                    KudoAttachedImagesGrid(imageNames: kudo.attachedImages)
                }

                if !kudo.hashtags.isEmpty {
                    hashtagRow
                }
            }

            // mm:6885:10176 — action bar (Xem chi tiết hidden on detail; heart disabled for own kudo)
            KudoDetailActionBar(
                heartCount: kudo.heartCount,
                isLiked: kudo.isLiked,
                isOwn: kudo.isOwn,
                showsDetailButton: false,
                onHeartTap: { kudo = kudo.withLikeToggled() },
                onCopyLink: copyLink
            )

            // mm:6885:10191 — bottom spacer
            Color.clear.frame(height: 4)
        }
        .padding(12)
        .background(Self.highlight)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Self.cardBorder, lineWidth: 1)
        )
    }

    // mm:6885:10174 — mms_B.4.3_Hashtag
    // Figma renders hashtags as inline red text (#D4271D), NOT pill chips —
    // styling diverges from the shared HashtagChip used in the card list variant.
    private static let hashtagRed = Color(red: 0xD4 / 255.0, green: 0x27 / 255.0, blue: 0x1D / 255.0)

    private var hashtagRow: some View {
        Text(kudo.hashtags.prefix(5).joined(separator: " "))
            .font(.custom("Montserrat", size: 10))
            .fontWeight(.medium)
            .foregroundColor(Self.hashtagRed)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Actions

    private func copyLink() {
        KudosClipboard.copy(kudoId: kudo.id)
        KudosCopiedToastController.show($showCopiedToast)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        KudosDetailView(detail: KudoDetailFixtures.sampleDetail)
    }
}
