//
//  AwardsTopViewModel.swift
//  SAA2025
//

import Foundation
import Combine

// MARK: - AwardsTopViewModel

/// Owns the Awards-tab data lifecycle. Loads the award list via the injected
/// `AwardsService`, exposes a `LoadState<[Award]>`, and tracks which award is
/// currently selected by the user's dropdown choice. Mirrors `HomeViewModel`'s
/// load/error patterns (including `ServiceError.unauthorized`/`.forbidden`
/// routing) so the two screens share idioms.
@MainActor
final class AwardsTopViewModel: ObservableObject {

    // MARK: - Published State

    @Published private(set) var awardsState: LoadState<[Award]> = .idle
    @Published private(set) var selectedAwardID: Award.ID? = nil
    @Published var navigateToAccessDenied: Bool = false

    // MARK: - Dependencies

    private let awardsService: AwardsService
    private let tokenStore: TokenStore

    // MARK: - Init

    init(awardsService: AwardsService = FakeAwardsService(),
         tokenStore: TokenStore) {
        self.awardsService = awardsService
        self.tokenStore = tokenStore
    }

    // MARK: - Derived

    /// Award currently shown in the Info Block, or nil while loading / on error.
    var selectedAward: Award? {
        guard
            let awards = awardsState.value,
            let id = selectedAwardID,
            let match = awards.first(where: { $0.id == id })
        else { return nil }
        return match
    }

    // MARK: - Actions

    func load() async {
        guard !awardsState.isLoading else { return }
        awardsState = .loading
        do {
            let awards = try await awardsService.loadAwards()
            if awards.isEmpty {
                awardsState = .empty
                selectedAwardID = nil
            } else {
                awardsState = .loaded(awards)
                // Default selection: prefer "Top Project" per spec, else first.
                // Cross-tab requests from Home override this via `selectAward(byTitle:)`.
                selectedAwardID = awards.first(where: { $0.title == "Top Project" })?.id
                    ?? awards.first?.id
            }
        } catch ServiceError.unauthorized {
            tokenStore.clear()
        } catch ServiceError.forbidden {
            navigateToAccessDenied = true
        } catch {
            awardsState = .error(error)
        }
    }

    func selectAward(_ id: Award.ID) {
        guard awardsState.value?.contains(where: { $0.id == id }) == true else { return }
        selectedAwardID = id
    }

    /// Look up an award by title and select it. No-op if the awards list
    /// hasn't loaded yet or no title matches. Used by `AwardsTabView` to
    /// react to cross-tab selection requests from `AppCoordinator`.
    func selectAward(byTitle title: String) {
        guard let awards = awardsState.value,
              let match = awards.first(where: { $0.title == title })
        else { return }
        selectedAwardID = match.id
    }

    func retry() {
        Task { await load() }
    }
}
