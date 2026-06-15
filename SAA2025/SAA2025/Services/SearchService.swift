//
//  SearchService.swift
//  SAA2025
//

import Foundation

// MARK: - SearchService

protocol SearchService {
    /// Returns sunners whose `displayName` or `employeeCode` contains `query`,
    /// case-insensitive, diacritic-insensitive. Empty query → empty result.
    func searchSunners(query: String) async throws -> [SunnerSearchResult]
}

// MARK: - FakeSearchService

/// Filters the in-memory `SearchFixtures.pool` to mimic the real backend.
/// Replace with `RealSearchService` once `/sunners?q=` is available.
final class FakeSearchService: SearchService {

    private let delay: Duration

    init(delay: Duration = Config.mockApiDelay) {
        self.delay = delay
    }

    func searchSunners(query: String) async throws -> [SunnerSearchResult] {
        try await Task.sleep(for: delay)
        let needle = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return [] }
        let folded = needle.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        return SearchFixtures.pool.filter { item in
            let name = item.displayName
                .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            let code = item.employeeCode
                .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            return name.contains(folded) || code.contains(folded)
        }
    }
}
