//
//  HomeViewModel.swift
//  SAA2025
//

import Foundation
import Combine

// MARK: - HomeViewModel

@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: - Published State

    @Published private(set) var awardsState: LoadState<[Award]> = .idle
    @Published private(set) var kudosState: LoadState<KudosInfo> = .idle
    @Published private(set) var unreadCount: Int = 0
    @Published private(set) var remaining: (days: Int, hours: Int, minutes: Int) = (0, 0, 0)
    @Published private(set) var isEventEnded: Bool = false

    // MARK: - Navigation Intents (Phase 6 binds these)

    @Published var navigateToAboutKudos: Bool = false
    @Published var navigateToSearch: Bool = false
    @Published var navigateToBell: Bool = false
    @Published var navigateToWriteKudo: Bool = false
    @Published var navigateToKudosFeed: Bool = false
    @Published var navigateToAccessDenied: Bool = false

    // MARK: - Dependencies

    private let awardsService: AwardsService
    private let kudosService: KudosService
    private let notificationsService: NotificationsService
    private let tokenStore: TokenStore

    private var countdownTimer: AnyCancellable?

    // MARK: - Init

    init(
        awardsService: AwardsService = FakeAwardsService(),
        kudosService: KudosService = FakeKudosService(),
        notificationsService: NotificationsService = FakeNotificationsService(),
        tokenStore: TokenStore
    ) {
        self.awardsService = awardsService
        self.kudosService = kudosService
        self.notificationsService = notificationsService
        self.tokenStore = tokenStore
        updateCountdown()
    }

    // MARK: - Actions

    func load() async {
        awardsState = .loading
        kudosState = .loading

        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadAwards() }
            group.addTask { await self.loadKudos() }
            group.addTask { await self.loadNotifications() }
        }
    }

    func retryAwards() {
        awardsState = .loading
        Task { await loadAwards() }
    }

    func startCountdown() {
        countdownTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.updateCountdown() }
    }

    func stopCountdown() {
        countdownTimer?.cancel()
        countdownTimer = nil
    }

    // MARK: - Private

    private func loadAwards() async {
        do {
            let awards = try await awardsService.loadAwards()
            awardsState = awards.isEmpty ? .empty : .loaded(awards)
        } catch ServiceError.unauthorized {
            tokenStore.clear()
        } catch ServiceError.forbidden {
            navigateToAccessDenied = true
        } catch {
            awardsState = .error(error)
        }
    }

    private func loadKudos() async {
        guard Config.isKudosAvailable else {
            kudosState = .empty
            return
        }
        do {
            let info = try await kudosService.loadKudos()
            kudosState = .loaded(info)
        } catch ServiceError.unauthorized {
            tokenStore.clear()
        } catch ServiceError.forbidden {
            navigateToAccessDenied = true
        } catch {
            kudosState = .error(error)
        }
    }

    private func loadNotifications() async {
        do {
            let summary = try await notificationsService.loadSummary()
            unreadCount = summary.unreadCount
        } catch {
            // Badge silently stays 0 — non-critical
        }
    }

    private func updateCountdown() {
        let now = Date()
        let target = Config.eventDate
        guard target > now else {
            isEventEnded = true
            remaining = (0, 0, 0)
            return
        }
        let diff = Int(target.timeIntervalSince(now))
        let days = diff / 86_400
        let hours = (diff % 86_400) / 3_600
        let minutes = (diff % 3_600) / 60
        remaining = (days, hours, minutes)
    }
}
