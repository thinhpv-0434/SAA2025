//
//  LoadState.swift
//  SAA2025
//
//  Created by pham.van.thinh on 9/6/26.
//

import Foundation

// MARK: - LoadState

/// Generic async-load state machine used by ViewModels.
/// Covers the full lifecycle: idle → loading → loaded(T) | empty | error.
enum LoadState<T> {
    case idle
    case loading
    case loaded(T)
    case empty
    case error(Error)
}

// MARK: - Convenience

extension LoadState {

    /// True only while a fetch is in-flight.
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    /// The successfully loaded value, or nil in any other state.
    var value: T? {
        if case .loaded(let v) = self { return v }
        return nil
    }

    /// True when the server returned an empty result set.
    var isEmpty: Bool {
        if case .empty = self { return true }
        return false
    }

    /// The error if the load failed, nil otherwise.
    var error: Error? {
        if case .error(let e) = self { return e }
        return nil
    }
}
