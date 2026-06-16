//
//  TestHelpers.swift
//  SAA2025Tests
//
//  Shared stub services and helpers. Each stub conforms to the production
//  service protocol so ViewModels can be exercised in isolation: configure
//  the canned result (or thrown error) up front, then drive the ViewModel
//  and assert on its published state.
//

import Foundation
@testable import SAA2025

// MARK: - StubAuthService

final class StubAuthService: AuthService {
    var token: String = "test-token"
    var thrownError: Error?

    func signIn() async throws -> String {
        if let e = thrownError { throw e }
        return token
    }
}

// MARK: - StubAwardsService

final class StubAwardsService: AwardsService {
    var awards: [Award] = []
    var thrownError: Error?

    func loadAwards() async throws -> [Award] {
        if let e = thrownError { throw e }
        return awards
    }
}

// MARK: - StubNotificationsService

final class StubNotificationsService: NotificationsService {
    var summary: NotificationSummary = NotificationSummary(unreadCount: 0)
    var items: [NotificationItem] = []
    var thrownError: Error?

    func loadSummary() async throws -> NotificationSummary {
        if let e = thrownError { throw e }
        return summary
    }

    func loadList() async throws -> [NotificationItem] {
        if let e = thrownError { throw e }
        return items
    }
}

// MARK: - StubSearchService

final class StubSearchService: SearchService {
    var results: [SunnerSearchResult] = []
    var thrownError: Error?
    private(set) var lastQuery: String?

    func searchSunners(query: String) async throws -> [SunnerSearchResult] {
        lastQuery = query
        if let e = thrownError { throw e }
        return results
    }
}

// MARK: - StubKudosService

/// Stub for `KudosService` with per-method configurable return values + errors.
/// Each method first checks its own optional `error` knob (so tests can target
/// the exact failure mode they care about), then falls back to a global
/// `thrownError`, then returns the canned value.
final class StubKudosService: KudosService {

    // Per-method return values
    var kudosInfo: KudosInfo = KudosInfo(
        isAvailable: true,
        bannerImageName: "KudosBanner",
        descriptionText: "",
        badgeText: ""
    )
    var highlight: [KudosCardData] = []
    var feed: [KudosCardData] = []
    var hashtags: [Hashtag] = []
    var departments: [Department] = []
    var stats: KudosStats = KudosStats(
        kudosReceived: 0, kudosSent: 0, heartsReceived: 0,
        secretBoxOpened: 0, secretBoxUnopened: 0
    )
    var topRecipients: [GiftRecipient] = []
    var spotlightCount: Int = 0
    var openBoxResult: Bool = true
    var recipients: [KudosUser] = []
    var submitResult: Bool = true

    // Error knobs
    var thrownError: Error?
    var submitError: Error?

    func loadKudos() async throws -> KudosInfo {
        if let e = thrownError { throw e }
        return kudosInfo
    }

    func loadHighlight(hashtagId: String?, departmentId: String?) async throws -> [KudosCardData] {
        if let e = thrownError { throw e }
        return highlight
    }

    func loadKudosFeed(page: Int, limit: Int, hashtagId: String?, departmentId: String?) async throws -> [KudosCardData] {
        if let e = thrownError { throw e }
        return feed
    }

    func loadHashtags() async throws -> [Hashtag] {
        if let e = thrownError { throw e }
        return hashtags
    }

    func loadDepartments() async throws -> [Department] {
        if let e = thrownError { throw e }
        return departments
    }

    func loadKudosStats() async throws -> KudosStats {
        if let e = thrownError { throw e }
        return stats
    }

    func loadTopRecipients() async throws -> [GiftRecipient] {
        if let e = thrownError { throw e }
        return topRecipients
    }

    func loadSpotlightCount() async throws -> Int {
        if let e = thrownError { throw e }
        return spotlightCount
    }

    func openNextSecretBox() async throws -> Bool {
        if let e = thrownError { throw e }
        return openBoxResult
    }

    func loadRecipients() async throws -> [KudosUser] {
        if let e = thrownError { throw e }
        return recipients
    }

    func submitKudo(_ draft: KudoDraft) async throws -> Bool {
        if let e = submitError ?? thrownError { throw e }
        return submitResult
    }
}

// MARK: - Token helper

/// Returns a fresh `TokenStore` with the persisted UserDefaults key cleared
/// so tests start from a known empty state.
@MainActor
func makeCleanTokenStore() -> TokenStore {
    UserDefaults.standard.removeObject(forKey: "auth.token")
    return TokenStore()
}

// MARK: - Shared fixtures

/// Minimal builders for domain models — keep ViewModel tests focused on
/// behaviour, not on rebuilding fixture data inline every time.
enum TestFixtures {

    static func makeUser(name: String = "Tester") -> KudosUser {
        KudosUser(
            id: UUID(),
            name: name,
            employeeCode: "E1234",
            department: "Eng",
            badgeLabel: nil,
            badgeTier: .none
        )
    }

    static func makeCard(isOwn: Bool, heartCount: Int = 5) -> KudosCardData {
        let sender = makeUser(name: "Sender")
        let receiver = makeUser(name: "Receiver")
        return KudosCardData(
            id: UUID(),
            sender: sender,
            receiver: receiver,
            timestamp: "10:00 - 1/1/2026",
            categoryTitle: "TEST",
            message: "Great work",
            hashtags: ["#test"],
            heartCount: heartCount,
            heartCountDisplay: "\(heartCount)",
            isHighlight: false,
            isLiked: false,
            isOwn: isOwn,
            departmentId: "eng"
        )
    }
}
