//
//  NotificationsService.swift
//  SAA2025
//

import Foundation

// MARK: - Protocol

protocol NotificationsService {
    func loadSummary() async throws -> NotificationSummary
}

// MARK: - Fake Implementation (Stub)

/// FakeNotificationsService: returns a fixed unread count of 3 after simulated delay.
/// Replace with RealNotificationsService (polling or WebSocket) when backend ready.
final class FakeNotificationsService: NotificationsService {

    private let delay: Duration

    /// - Parameter delay: Simulated network latency. Defaults to `Config.mockApiDelay`.
    init(delay: Duration = Config.mockApiDelay) {
        self.delay = delay
    }

    func loadSummary() async throws -> NotificationSummary {
        try await Task.sleep(for: delay)
        return NotificationSummary(unreadCount: 3)
    }
}
