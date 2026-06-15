//
//  NotificationsViewModel.swift
//  SAA2025
//

import Combine
import Foundation

// MARK: - NotificationsViewModel

/// Owns the notification feed state and the "mark all read" intent. The
/// network layer is hidden behind `NotificationsService` so previews and
/// tests can swap a fake.
@MainActor
final class NotificationsViewModel: ObservableObject {

    @Published private(set) var items: [NotificationItem] = []
    @Published private(set) var state: LoadState<[NotificationItem]> = .idle

    private let service: NotificationsService

    init(service: NotificationsService = FakeNotificationsService()) {
        self.service = service
    }

    func load() async {
        state = .loading
        do {
            let list = try await service.loadList()
            items = list
            state = .loaded(list)
        } catch {
            state = .error(error)
        }
    }

    /// Clears every row's unread flag in-place. The host backend would
    /// receive a single `PATCH /notifications/read-all` call here.
    func markAllRead() {
        items = items.map { item in
            guard item.isUnread else { return item }
            return NotificationItem(
                id: item.id,
                iconKind: item.iconKind,
                message: item.message,
                linkText: item.linkText,
                timestamp: item.timestamp,
                isUnread: false
            )
        }
    }
}
