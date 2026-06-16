//
//  HomeViewModelTests.swift
//  SAA2025Tests
//

import Testing
import Foundation
@testable import SAA2025

@MainActor
@Suite("HomeViewModel")
struct HomeViewModelTests {

    // MARK: - Init / countdown

    @Test("Initial state: idle awards, idle kudos, zero unread")
    func initialState() {
        let vm = makeVM()
        #expect(vm.awardsState.isLoading == false)
        if case .idle = vm.awardsState { /* ok */ } else { Issue.record("awardsState should be idle") }
        if case .idle = vm.kudosState { /* ok */ } else { Issue.record("kudosState should be idle") }
        #expect(vm.unreadCount == 0)
    }

    @Test("Countdown values are non-negative")
    func countdownNonNegative() {
        let vm = makeVM()
        #expect(vm.remaining.days >= 0)
        #expect(vm.remaining.hours >= 0)
        #expect(vm.remaining.minutes >= 0)
    }

    // MARK: - Load

    @Test("Successful load populates awardsState.loaded with the returned awards")
    func loadAwardsSuccess() async {
        let awards = StubAwardsService()
        awards.awards = [
            Award(id: UUID(), title: "Top Project", shortDescription: "", imageName: ""),
            Award(id: UUID(), title: "MVP", shortDescription: "", imageName: "")
        ]
        let vm = makeVM(awards: awards)

        await vm.load()

        let loaded = vm.awardsState.value
        #expect(loaded?.count == 2)
        #expect(loaded?.first?.title == "Top Project")
    }

    @Test("Empty awards array maps to LoadState.empty (not loaded)")
    func loadAwardsEmpty() async {
        let awards = StubAwardsService()
        awards.awards = []
        let vm = makeVM(awards: awards)

        await vm.load()

        #expect(vm.awardsState.isEmpty == true)
        #expect(vm.awardsState.value == nil)
    }

    @Test("ServiceError.network surfaces in awardsState.error")
    func loadAwardsError() async {
        let awards = StubAwardsService()
        awards.thrownError = ServiceError.network
        let vm = makeVM(awards: awards)

        await vm.load()

        #expect(vm.awardsState.error != nil)
    }

    @Test("ServiceError.unauthorized clears the TokenStore")
    func loadAwardsUnauthorizedClearsToken() async {
        let store = makeCleanTokenStore()
        store.save("seed-token")
        #expect(store.token == "seed-token")

        let awards = StubAwardsService()
        awards.thrownError = ServiceError.unauthorized
        let vm = makeVM(awards: awards, store: store)

        await vm.load()
        #expect(store.token == nil)
    }

    @Test("ServiceError.forbidden flips the access-denied nav flag")
    func loadAwardsForbiddenRoutes() async {
        let awards = StubAwardsService()
        awards.thrownError = ServiceError.forbidden
        let vm = makeVM(awards: awards)

        await vm.load()
        #expect(vm.navigateToAccessDenied == true)
    }

    @Test("Notifications summary updates unreadCount")
    func notificationsSummary() async {
        let notif = StubNotificationsService()
        notif.summary = NotificationSummary(unreadCount: 7)
        let vm = makeVM(notif: notif)

        await vm.load()
        #expect(vm.unreadCount == 7)
    }

    // MARK: - Factory

    private func makeVM(
        awards: AwardsService = StubAwardsService(),
        kudos: KudosService = StubKudosService(),
        notif: NotificationsService = StubNotificationsService(),
        store: TokenStore? = nil
    ) -> HomeViewModel {
        HomeViewModel(
            awardsService: awards,
            kudosService: kudos,
            notificationsService: notif,
            tokenStore: store ?? makeCleanTokenStore()
        )
    }
}
