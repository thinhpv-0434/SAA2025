//
//  NotificationsViewModelTests.swift
//  SAA2025Tests
//

import Testing
import Foundation
@testable import SAA2025

@MainActor
@Suite("NotificationsViewModel")
struct NotificationsViewModelTests {

    @Test("Initial state: empty items, idle state")
    func initialState() {
        let vm = NotificationsViewModel(service: StubNotificationsService())
        #expect(vm.items.isEmpty)
        if case .idle = vm.state { /* ok */ } else { Issue.record("state should be idle") }
    }

    @Test("Successful load populates items + sets state.loaded")
    func loadSuccess() async {
        let svc = StubNotificationsService()
        svc.items = [makeItem(id: 1, unread: true), makeItem(id: 2, unread: false)]
        let vm = NotificationsViewModel(service: svc)

        await vm.load()

        #expect(vm.items.count == 2)
        #expect(vm.state.value?.count == 2)
    }

    @Test("Load error surfaces in state.error")
    func loadError() async {
        let svc = StubNotificationsService()
        svc.thrownError = ServiceError.network
        let vm = NotificationsViewModel(service: svc)

        await vm.load()
        #expect(vm.state.error != nil)
    }

    @Test("markAllRead clears the unread flag on every row")
    func markAllRead() async {
        let svc = StubNotificationsService()
        svc.items = [makeItem(id: 1, unread: true), makeItem(id: 2, unread: true), makeItem(id: 3, unread: false)]
        let vm = NotificationsViewModel(service: svc)
        await vm.load()
        #expect(vm.items.contains(where: { $0.isUnread }))

        vm.markAllRead()
        #expect(vm.items.allSatisfy { !$0.isUnread })
    }

    // MARK: - Helpers

    private func makeItem(id: Int, unread: Bool) -> NotificationItem {
        NotificationItem(
            id: UUID(),
            iconKind: .kudoReceived,
            message: "msg \(id)",
            linkText: nil,
            timestamp: "now",
            isUnread: unread
        )
    }
}
