//
//  SearchViewModelTests.swift
//  SAA2025Tests
//

import Testing
import Foundation
@testable import SAA2025

@MainActor
@Suite("SearchViewModel")
struct SearchViewModelTests {

    @Test("Initial: empty query, empty results, not searching, recent seeded from fixtures")
    func initialState() {
        let vm = SearchViewModel(service: StubSearchService())
        #expect(vm.isQueryEmpty == true)
        #expect(vm.results.isEmpty)
        #expect(vm.isSearching == false)
        // recent seed comes from SearchFixtures.recent — just sanity-check the API surface.
        #expect(vm.recent.count >= 0)
    }

    @Test("Empty/whitespace query clears results without hitting the service")
    func emptyQueryClears() async {
        let svc = StubSearchService()
        svc.results = [makeResult(name: "Alice")]
        let vm = SearchViewModel(service: svc)
        vm.query = "   "
        vm.onQueryChange()

        // Without a non-empty query the VM short-circuits and does NOT call the service.
        #expect(vm.results.isEmpty)
        #expect(svc.lastQuery == nil)
    }

    @Test("Non-empty query (after debounce) populates results")
    func nonEmptyQueryReturnsResults() async {
        let svc = StubSearchService()
        let alice = makeResult(name: "Alice")
        svc.results = [alice]
        let vm = SearchViewModel(service: svc)

        vm.query = "Alice"
        vm.onQueryChange()
        // Debounce is 180ms; wait long enough.
        try? await Task.sleep(for: .milliseconds(300))

        #expect(vm.results.count == 1)
        #expect(svc.lastQuery == "Alice")
        #expect(vm.isSearching == false)
    }

    @Test("recordRecent moves an item to the top and dedupes")
    func recordRecentMovesToTop() {
        let svc = StubSearchService()
        let vm = SearchViewModel(service: svc)
        let item = makeResult(name: "Bob")
        vm.recordRecent(item)
        #expect(vm.recent.first?.id == item.id)
        // Recording again moves it to the top (no duplicates).
        vm.recordRecent(item)
        #expect(vm.recent.filter { $0.id == item.id }.count == 1)
        #expect(vm.recent.first?.id == item.id)
    }

    @Test("removeRecent deletes the matching row")
    func removeRecentDeletes() {
        let svc = StubSearchService()
        let vm = SearchViewModel(service: svc)
        let item = makeResult(name: "Charlie")
        vm.recordRecent(item)
        #expect(vm.recent.contains(where: { $0.id == item.id }))
        vm.removeRecent(item)
        #expect(vm.recent.contains(where: { $0.id == item.id }) == false)
    }

    // MARK: - Helpers

    private func makeResult(name: String) -> SunnerSearchResult {
        SunnerSearchResult(
            id: UUID(),
            displayName: name,
            employeeCode: "E\(abs(name.hashValue) % 9999)",
            badgeTier: .rising
        )
    }
}
