//
//  KudosViewModel.swift
//  SAA2025
//

import Foundation
import Combine

// MARK: - KudosViewModel

@MainActor
final class KudosViewModel: ObservableObject {

    // MARK: - State

    @Published private(set) var state: LoadState<Void> = .idle

    @Published private(set) var highlightCards: [KudosCardData] = []
    @Published private(set) var allKudosCards: [KudosCardData] = []
    @Published private(set) var stats: KudosStats = KudosStats(
        kudosReceived: 0, kudosSent: 0, heartsReceived: 0,
        secretBoxOpened: 0, secretBoxUnopened: 0
    )
    @Published private(set) var giftRecipients: [GiftRecipient] = []
    @Published private(set) var spotlightTotalCount: Int = 0
    @Published private(set) var hashtags: [Hashtag] = []
    @Published private(set) var departments: [Department] = []

    // MARK: - Filter state

    @Published private(set) var selectedHashtag: Hashtag?
    @Published private(set) var selectedDepartment: Department?

    // MARK: - Carousel state

    @Published var currentHighlightIndex: Int = 0

    // MARK: - Navigation intents

    @Published var navigateToSendKudos: Bool = false
    @Published var navigateToKudosDetail: Bool = false
    @Published var navigateToViewAll: Bool = false
    @Published var navigateToOpenSecretBox: Bool = false

    // MARK: - Dependencies

    private let service: KudosService
    private var lastBoxOpenAt: ContinuousClock.Instant?
    private let boxOpenDebounce: Duration = .milliseconds(600)

    init(service: KudosService = FakeKudosService()) {
        self.service = service
    }

    // MARK: - Load

    func load() async {
        state = .loading
        do {
            async let highlight = service.loadHighlight(
                hashtagId: selectedHashtag?.id, departmentId: selectedDepartment?.id
            )
            async let feed = service.loadKudosFeed(
                page: 1, limit: 3,
                hashtagId: selectedHashtag?.id, departmentId: selectedDepartment?.id
            )
            async let statsValue = service.loadKudosStats()
            async let recipientsValue = service.loadTopRecipients()
            async let countValue = service.loadSpotlightCount()
            async let hashtagsValue = service.loadHashtags()
            async let departmentsValue = service.loadDepartments()

            let (h, f, s, r, c, ht, dp) = try await (
                highlight, feed, statsValue, recipientsValue,
                countValue, hashtagsValue, departmentsValue
            )

            highlightCards = h
            allKudosCards = f
            stats = s
            giftRecipients = r
            spotlightTotalCount = c
            hashtags = ht
            departments = dp
            state = .loaded(())
        } catch {
            state = .error(error)
        }
    }

    // MARK: - Filter actions (TC_FUN_004/005)

    func selectHashtag(_ tag: Hashtag?) async {
        selectedHashtag = tag
        currentHighlightIndex = 0  // TC_FUN_005: reset carousel
        await reloadFilteredSections()
    }

    func selectDepartment(_ dept: Department?) async {
        selectedDepartment = dept
        currentHighlightIndex = 0  // TC_FUN_005: reset carousel
        await reloadFilteredSections()
    }

    private func reloadFilteredSections() async {
        do {
            async let highlight = service.loadHighlight(
                hashtagId: selectedHashtag?.id, departmentId: selectedDepartment?.id
            )
            async let feed = service.loadKudosFeed(
                page: 1, limit: 3,
                hashtagId: selectedHashtag?.id, departmentId: selectedDepartment?.id
            )
            let (h, f) = try await (highlight, feed)
            highlightCards = h
            allKudosCards = f
        } catch {
            state = .error(error)
        }
    }

    // MARK: - Carousel actions

    func goToPreviousHighlight() {
        guard currentHighlightIndex > 0 else { return }
        currentHighlightIndex -= 1
    }

    func goToNextHighlight() {
        guard currentHighlightIndex < highlightCards.count - 1 else { return }
        currentHighlightIndex += 1
    }

    // MARK: - Heart toggle (TC_FUN_007/008)

    func toggleHeart(kudosId: UUID) {
        if let i = highlightCards.firstIndex(where: { $0.id == kudosId }) {
            guard !highlightCards[i].isOwn else { return }  // TC_FUN_008
            highlightCards[i] = highlightCards[i].withLikeToggled()
        }
        if let j = allKudosCards.firstIndex(where: { $0.id == kudosId }) {
            guard !allKudosCards[j].isOwn else { return }
            allKudosCards[j] = allKudosCards[j].withLikeToggled()
        }
    }

    // MARK: - Secret Box (TC_FUN_024/025)

    func openSecretBox() async {
        let now = ContinuousClock.now
        if let last = lastBoxOpenAt, now - last < boxOpenDebounce { return }
        lastBoxOpenAt = now
        guard stats.secretBoxUnopened > 0 else { return }
        do {
            let ok = try await service.openNextSecretBox()
            if ok {
                stats = KudosStats(
                    kudosReceived: stats.kudosReceived,
                    kudosSent: stats.kudosSent,
                    heartsReceived: stats.heartsReceived,
                    secretBoxOpened: stats.secretBoxOpened + 1,
                    secretBoxUnopened: stats.secretBoxUnopened - 1
                )
                navigateToOpenSecretBox = true
            }
        } catch {
            state = .error(error)
        }
    }

    // MARK: - Static helpers (TC_FUN_006)

    /// Star badges: 10+ hearts → 1★, 20+ → 2★, 50+ → 3★.
    static func badgeLevel(heartCount: Int) -> Int {
        if heartCount >= 50 { return 3 }
        if heartCount >= 20 { return 2 }
        if heartCount >= 10 { return 1 }
        return 0
    }

    // MARK: - Preview helpers (used by SwiftUI #Preview blocks)

    static let mockHighlightCards: [KudosCardData] = KudosFixtures.cards
}
