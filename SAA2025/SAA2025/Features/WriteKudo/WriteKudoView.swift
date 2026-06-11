//
//  WriteKudoView.swift
//  SAA2025
//
//  Screen: [iOS] Sun*Kudos_Viết Kudo_default — 7fFAb-K35a
//  Design: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/7fFAb-K35a
//

import SwiftUI

// MARK: - WriteKudoView

// mm:6885:9271 — Write Kudo composer (presentational layer)
struct WriteKudoView: View {

    @Binding var recipient: KudosUser?
    @Binding var title: String
    @Binding var message: String
    @Binding var hashtags: [String]
    @Binding var images: [KudoImageAttachment]
    @Binding var isAnonymous: Bool

    let isSubmitting: Bool
    let canSubmit: Bool

    let onBack: () -> Void
    let onRecipientTap: () -> Void
    let onAwardsInfoTap: () -> Void
    let onAddHashtagTap: () -> Void
    let onRemoveHashtag: (String) -> Void
    let onAddImageTap: () -> Void
    let onRemoveImage: (UUID) -> Void
    let onCancel: () -> Void
    let onSubmit: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            // mm:6885:9271 — reused key-visual background
            KudosKeyvisualBackground()

            VStack(spacing: 0) {
                // mm:(nav) — custom nav bar
                WriteKudoNavBar(onBack: onBack)
                    .padding(.top, 4)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        formCard
                            .padding(.horizontal, 16)
                            .padding(.top, 12)

                        actionRow
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                            .padding(.bottom, 24)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Form card

    private var formCard: some View {
        WriteKudoCard {
            // mm:6885:9292 — A. header
            Text("Gửi lời cám ơn và ghi nhận đến đồng đội")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(WriteKudoFieldStyle.labelColor)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            // B. recipient
            WriteKudoRecipientField(recipient: recipient, onTap: onRecipientTap)

            // B.3-B.5. title + helper
            WriteKudoTitleField(title: $title)

            // C + D. toolbar + message
            WriteKudoMessageEditor(message: $message, onAwardsInfoTap: onAwardsInfoTap)

            // E. hashtags
            WriteKudoHashtagSection(
                hashtags: hashtags,
                onAddTap: onAddHashtagTap,
                onRemove: onRemoveHashtag
            )

            // F. images
            WriteKudoImageSection(
                images: images,
                onAddTap: onAddImageTap,
                onRemove: onRemoveImage
            )

            // G. anonymous
            WriteKudoAnonymousToggle(isAnonymous: $isAnonymous)
        }
    }

    // MARK: - Action row (H + I)

    private var actionRow: some View {
        WriteKudoActionRow(
            isSubmitting: isSubmitting,
            canSubmit: canSubmit,
            onCancel: onCancel,
            onSubmit: onSubmit
        )
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @State var recipient: KudosUser? = nil
        @State var title: String = ""
        @State var message: String = ""
        @State var hashtags: [String] = ["#Dedicated", "#Inspiring"]
        @State var images: [KudoImageAttachment] = [
            KudoImageAttachment(assetName: "KudosBanner"),
            KudoImageAttachment(assetName: "KudosBanner"),
            KudoImageAttachment(assetName: "KudosBanner"),
            KudoImageAttachment(assetName: "KudosBanner")
        ]
        @State var isAnonymous: Bool = false

        var body: some View {
            NavigationStack {
                WriteKudoView(
                    recipient: $recipient,
                    title: $title,
                    message: $message,
                    hashtags: $hashtags,
                    images: $images,
                    isAnonymous: $isAnonymous,
                    isSubmitting: false,
                    canSubmit: false,
                    onBack: {},
                    onRecipientTap: {},
                    onAwardsInfoTap: {},
                    onAddHashtagTap: {},
                    onRemoveHashtag: { _ in },
                    onAddImageTap: {},
                    onRemoveImage: { _ in },
                    onCancel: {},
                    onSubmit: {}
                )
            }
        }
    }
    return PreviewWrapper()
}
