//
//  SearchViewModel.swift
//  SAA2025
//

import Combine
import Foundation

// MARK: - SearchViewModel

/// Owns the search input + result feed + an in-memory recent-search list.
/// The input is debounced so the fake service isn't hit on every keystroke;
/// the same debounce will absorb real network roundtrips later.
@MainActor
final class SearchViewModel: ObservableObject {

    @Published var query: String = ""
    @Published private(set) var results: [SunnerSearchResult] = []
    @Published private(set) var recent: [SunnerSearchResult] = SearchFixtures.recent
    @Published private(set) var isSearching: Bool = false

    private let service: SearchService
    private var searchTask: Task<Void, Never>?

    init(service: SearchService = FakeSearchService()) {
        self.service = service
    }

    var isQueryEmpty: Bool {
        query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Called by the view whenever `query` changes. Debounces and triggers
    /// a new fetch, cancelling any in-flight one so the latest keystroke
    /// wins.
    func onQueryChange() {
        searchTask?.cancel()

        if isQueryEmpty {
            results = []
            isSearching = false
            return
        }

        searchTask = Task { [query] in
            do {
                try await Task.sleep(for: .milliseconds(180))
                if Task.isCancelled { return }
                isSearching = true
                let fetched = try await service.searchSunners(query: query)
                if Task.isCancelled { return }
                results = fetched
            } catch is CancellationError {
                // Newer query already in flight — nothing to do.
            } catch {
                results = []
            }
            isSearching = false
        }
    }

    /// Removes a recent search row. Called from the × button on the card.
    func removeRecent(_ item: SunnerSearchResult) {
        recent.removeAll { $0.id == item.id }
    }

    /// Pushes a tapped result to the top of "Recent" (and dedupes), so the
    /// user can come back to it without retyping.
    func recordRecent(_ item: SunnerSearchResult) {
        recent.removeAll { $0.id == item.id }
        recent.insert(item, at: 0)
        if recent.count > 10 { recent = Array(recent.prefix(10)) }
    }
}
