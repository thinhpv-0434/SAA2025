//
//  KudosViewModelTests.swift
//  SAA2025Tests
//
//  NOTE: This file is authored ahead of an XCTest target being wired up in the
//  Xcode project. Until the target is added, the file is NOT compiled.
//  Wire-up TODO: add a unit-test target in Xcode → set this folder as its
//  group → the file will pick up the test bundle's @testable import.
//

import XCTest
@testable import SAA2025

@MainActor
final class KudosViewModelTests: XCTestCase {

    // MARK: - Helpers

    /// Mock service that records the args of the most recent highlight/feed call.
    final class MockKudosService: KudosService {
        var capturedHashtagId: String?
        var capturedDepartmentId: String?
        var openCallCount = 0

        func loadKudos() async throws -> KudosInfo {
            KudosInfo(isAvailable: true, bannerImageName: "", descriptionText: "", badgeText: "")
        }
        func loadHighlight(hashtagId: String?, departmentId: String?) async throws -> [KudosCardData] {
            capturedHashtagId = hashtagId
            capturedDepartmentId = departmentId
            return Array(KudosFixtures.cards.prefix(5))
        }
        func loadKudosFeed(page: Int, limit: Int, hashtagId: String?, departmentId: String?) async throws -> [KudosCardData] {
            capturedHashtagId = hashtagId
            capturedDepartmentId = departmentId
            return Array(KudosFixtures.cards.prefix(limit))
        }
        func loadHashtags() async throws -> [Hashtag] { KudosFixtures.hashtags }
        func loadDepartments() async throws -> [Department] { KudosFixtures.departments }
        func loadKudosStats() async throws -> KudosStats { KudosFixtures.stats }
        func loadTopRecipients() async throws -> [GiftRecipient] { KudosFixtures.recipients }
        func loadSpotlightCount() async throws -> Int { 388 }
        func openNextSecretBox() async throws -> Bool {
            openCallCount += 1
            return true
        }
    }

    // MARK: - Smoke

    func test_loadPopulatesSnapshot() async {
        let vm = KudosViewModel(service: MockKudosService())
        await vm.load()
        XCTAssertEqual(vm.highlightCards.count, 5)
        XCTAssertGreaterThan(vm.allKudosCards.count, 0)
        XCTAssertEqual(vm.spotlightTotalCount, 388)
    }

    // MARK: - TC_FUN_005 — Filter selection resets carousel

    func test_selectHashtag_resetsCarouselToZero() async {
        let vm = KudosViewModel(service: MockKudosService())
        await vm.load()
        vm.currentHighlightIndex = 3
        await vm.selectHashtag(KudosFixtures.hashtags[0])
        XCTAssertEqual(vm.currentHighlightIndex, 0)
    }

    func test_selectDepartment_resetsCarouselToZero() async {
        let vm = KudosViewModel(service: MockKudosService())
        await vm.load()
        vm.currentHighlightIndex = 3
        await vm.selectDepartment(KudosFixtures.departments[0])
        XCTAssertEqual(vm.currentHighlightIndex, 0)
    }

    // MARK: - TC_FUN_004 — Filter AND-logic passes both params

    func test_filterAND_passesBothParamsToService() async {
        let mock = MockKudosService()
        let vm = KudosViewModel(service: mock)
        await vm.load()
        await vm.selectHashtag(KudosFixtures.hashtags[0])
        await vm.selectDepartment(KudosFixtures.departments[0])
        XCTAssertEqual(mock.capturedHashtagId, KudosFixtures.hashtags[0].id)
        XCTAssertEqual(mock.capturedDepartmentId, KudosFixtures.departments[0].id)
    }

    // MARK: - TC_FUN_007 — Heart toggle

    func test_toggleHeart_likes() async {
        let vm = KudosViewModel(service: MockKudosService())
        await vm.load()
        guard let target = vm.highlightCards.first(where: { !$0.isOwn }) else {
            return XCTFail("Need a non-own card for like test")
        }
        let originalCount = target.heartCount
        vm.toggleHeart(kudosId: target.id)
        let updated = vm.highlightCards.first { $0.id == target.id }!
        XCTAssertTrue(updated.isLiked)
        XCTAssertEqual(updated.heartCount, originalCount + 1)
    }

    func test_toggleHeart_unlikes() async {
        let vm = KudosViewModel(service: MockKudosService())
        await vm.load()
        guard let target = vm.highlightCards.first(where: { !$0.isOwn }) else { return XCTFail() }
        vm.toggleHeart(kudosId: target.id)  // like
        let countAfterLike = vm.highlightCards.first { $0.id == target.id }!.heartCount
        vm.toggleHeart(kudosId: target.id)  // unlike
        let updated = vm.highlightCards.first { $0.id == target.id }!
        XCTAssertFalse(updated.isLiked)
        XCTAssertEqual(updated.heartCount, countAfterLike - 1)
    }

    // MARK: - TC_FUN_008 — Self-like blocked

    /// A specialized mock that returns ONE own-card so the VM is seeded via load().
    final class OwnCardMock: KudosService {
        let ownCard: KudosCardData
        init(ownCard: KudosCardData) { self.ownCard = ownCard }
        func loadKudos() async throws -> KudosInfo { KudosInfo(isAvailable: false, bannerImageName: "", descriptionText: "", badgeText: "") }
        func loadHighlight(hashtagId: String?, departmentId: String?) async throws -> [KudosCardData] { [ownCard] }
        func loadKudosFeed(page: Int, limit: Int, hashtagId: String?, departmentId: String?) async throws -> [KudosCardData] { [] }
        func loadHashtags() async throws -> [Hashtag] { [] }
        func loadDepartments() async throws -> [Department] { [] }
        func loadKudosStats() async throws -> KudosStats { KudosFixtures.stats }
        func loadTopRecipients() async throws -> [GiftRecipient] { [] }
        func loadSpotlightCount() async throws -> Int { 0 }
        func openNextSecretBox() async throws -> Bool { true }
    }

    func test_toggleHeart_blocked_onOwnCard() async {
        let ownCard = KudosCardData(
            id: UUID(),
            sender: KudosFixtures.cards[0].sender,
            receiver: KudosFixtures.cards[0].receiver,
            timestamp: "now",
            categoryTitle: "x",
            message: "y",
            hashtags: [],
            heartCount: 5,
            heartCountDisplay: "5",
            isHighlight: false,
            isLiked: false,
            isOwn: true,
            departmentId: "d-a"
        )
        let vm = KudosViewModel(service: OwnCardMock(ownCard: ownCard))
        await vm.load()
        vm.toggleHeart(kudosId: ownCard.id)
        let unchanged = vm.highlightCards.first!
        XCTAssertFalse(unchanged.isLiked)
        XCTAssertEqual(unchanged.heartCount, 5)
    }

    // MARK: - TC_FUN_006 — Badge thresholds

    func test_badgeLevel_thresholds() {
        XCTAssertEqual(KudosViewModel.badgeLevel(heartCount: 0), 0)
        XCTAssertEqual(KudosViewModel.badgeLevel(heartCount: 9), 0)
        XCTAssertEqual(KudosViewModel.badgeLevel(heartCount: 10), 1)
        XCTAssertEqual(KudosViewModel.badgeLevel(heartCount: 19), 1)
        XCTAssertEqual(KudosViewModel.badgeLevel(heartCount: 20), 2)
        XCTAssertEqual(KudosViewModel.badgeLevel(heartCount: 49), 2)
        XCTAssertEqual(KudosViewModel.badgeLevel(heartCount: 50), 3)
        XCTAssertEqual(KudosViewModel.badgeLevel(heartCount: 999), 3)
    }

    // MARK: - TC_FUN_025 — Secret box debounce

    func test_openSecretBox_debouncesRapidDoubleTap() async {
        let mock = MockKudosService()
        let vm = KudosViewModel(service: mock)
        await vm.load()  // stats.secretBoxUnopened > 0
        async let a: () = vm.openSecretBox()
        async let b: () = vm.openSecretBox()
        _ = await (a, b)
        XCTAssertLessThanOrEqual(mock.openCallCount, 1)
    }
}

