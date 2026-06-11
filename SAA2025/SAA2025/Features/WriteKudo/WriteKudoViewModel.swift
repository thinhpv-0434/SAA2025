//
//  WriteKudoViewModel.swift
//  SAA2025
//
//  Owns composer state, validation, picker lifecycle, and submit flow.
//

import Foundation
import Combine

// MARK: - WriteKudoViewModel

@MainActor
final class WriteKudoViewModel: ObservableObject {

    // MARK: - Form bindings (mutated by the view through bindings)
    @Published var recipient: KudosUser? = nil
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var hashtags: [String] = []
    @Published var images: [KudoImageAttachment] = []
    @Published var isAnonymous: Bool = false

    // MARK: - Sheet visibility / dialog
    @Published var showRecipientPicker: Bool = false
    @Published var showHashtagPicker: Bool = false
    @Published var showAwardsInfo: Bool = false
    @Published var showCancelConfirm: Bool = false

    // MARK: - Loaded options
    @Published private(set) var availableRecipients: [KudosUser] = []
    @Published private(set) var availableHashtags: [Hashtag] = []

    // MARK: - Network state
    @Published private(set) var isSubmitting: Bool = false
    @Published var submitError: String? = nil

    // MARK: - Dependencies

    private let service: KudosService
    private var imageCycleIndex: Int = 0

    init(service: KudosService = FakeKudosService()) {
        self.service = service
    }

    // MARK: - Derived state

    var canSubmit: Bool {
        recipient != nil
            && !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && title.count <= KudoDraftLimits.titleMax
            && !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && message.count <= KudoDraftLimits.messageMax
            && !hashtags.isEmpty
            && hashtags.count <= KudoDraftLimits.hashtagMax
            && !isSubmitting
    }

    var isDirty: Bool {
        recipient != nil
            || !title.isEmpty
            || !message.isEmpty
            || !hashtags.isEmpty
            || !images.isEmpty
            || isAnonymous
    }

    // MARK: - Lifecycle

    func loadOptions() async {
        async let recipientsTask = (try? service.loadRecipients()) ?? []
        async let hashtagsTask = (try? service.loadHashtags()) ?? []
        let (recipients, hashtags) = await (recipientsTask, hashtagsTask)
        self.availableRecipients = recipients
        self.availableHashtags = hashtags
    }

    // MARK: - Recipient

    func selectRecipient(_ user: KudosUser) {
        recipient = user
        showRecipientPicker = false
    }

    // MARK: - Hashtags

    func addHashtag(_ raw: String) {
        let normalized = normalizeHashtag(raw)
        guard !normalized.isEmpty else { return }
        guard hashtags.count < KudoDraftLimits.hashtagMax else { return }
        guard !hashtags.contains(normalized) else { return }
        hashtags.append(normalized)
    }

    func removeHashtag(_ tag: String) {
        hashtags.removeAll { $0 == tag }
    }

    private func normalizeHashtag(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return "" }
        return trimmed.hasPrefix("#") ? trimmed : "#" + trimmed
    }

    // MARK: - Images

    func addImage() {
        guard images.count < KudoDraftLimits.imageMax else { return }
        let cycle = WriteKudoFixtures.mockImageAssetCycle
        guard !cycle.isEmpty else { return }
        let name = cycle[imageCycleIndex % cycle.count]
        imageCycleIndex += 1
        images.append(KudoImageAttachment(assetName: name))
    }

    func removeImage(_ id: UUID) {
        images.removeAll { $0.id == id }
    }

    // MARK: - Submit / Cancel

    /// Returns true on success — the container handles toast + dismiss.
    func submit() async -> Bool {
        guard canSubmit, let recipient = recipient else { return false }
        let draft = KudoDraft(
            recipient: recipient,
            title: title,
            message: message,
            hashtags: hashtags,
            imageAssetNames: images.map(\.assetName),
            isAnonymous: isAnonymous
        )
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            let ok = try await service.submitKudo(draft)
            if ok { return true }
            submitError = "Không gửi được Kudos. Vui lòng thử lại."
            return false
        } catch {
            submitError = error.localizedDescription
            return false
        }
    }

    /// Called when the user taps Hủy. If dirty, show confirm; else caller dismisses.
    func attemptCancel(onClean: () -> Void) {
        if isDirty {
            showCancelConfirm = true
        } else {
            onClean()
        }
    }
}
