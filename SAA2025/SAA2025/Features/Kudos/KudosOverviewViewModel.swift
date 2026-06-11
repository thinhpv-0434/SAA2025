//
//  KudosOverviewViewModel.swift
//  SAA2025
//

import Foundation
import Combine

// MARK: - KudosOverviewViewModel

/// ViewModel for the All Kudos screen ([iOS] Sun*Kudos_All Kudos — j_a2GQWKDJ).
///
/// Loads a single page (limit 20) of unfiltered cards via `KudosService.loadKudosFeed`
/// per clarifications.md. Heart toggles are handled locally with the same `isOwn`
/// guard as `KudosViewModel`.
@MainActor
final class KudosOverviewViewModel: ObservableObject {

    // MARK: - State

    @Published private(set) var state: LoadState<Void> = .idle
    @Published private(set) var cards: [KudosCardData] = []

    // Detail navigation is owned by the hosting NavigationStack (KudosTabView).
    // Routing it locally would register a second `navigationDestination(item: KudoDetail)`
    // in the same stack and SwiftUI would suppress the inner one.

    // MARK: - Dependencies

    private let service: KudosService
    private let pageLimit: Int

    init(service: KudosService = FakeKudosService(), pageLimit: Int = 20) {
        self.service = service
        self.pageLimit = pageLimit
    }

    // MARK: - Load

    func load() async {
        state = .loading
        do {
            let feed = try await service.loadKudosFeed(
                page: 1,
                limit: pageLimit,
                hashtagId: nil,
                departmentId: nil
            )
            cards = feed
            state = .loaded(())
        } catch {
            state = .error(error)
        }
    }

    // MARK: - Heart toggle

    /// Same isOwn guard as KudosViewModel (TC_FUN_008): users cannot like their own kudos.
    func toggleHeart(kudosId: UUID) {
        guard let i = cards.firstIndex(where: { $0.id == kudosId }) else { return }
        guard !cards[i].isOwn else { return }
        cards[i] = cards[i].withLikeToggled()
    }
}
