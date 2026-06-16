//
//  KudosViewModelTests.swift
//  SAA2025Tests
//

import Testing
import Foundation
@testable import SAA2025

@MainActor
@Suite("KudosViewModel")
struct KudosViewModelTests {

    // MARK: - Init

    @Test("Initial: idle, empty collections, zero index, no nav flags")
    func initialState() {
        let vm = KudosViewModel(service: StubKudosService())
        if case .idle = vm.state { /* ok */ } else { Issue.record() }
        #expect(vm.highlightCards.isEmpty)
        #expect(vm.allKudosCards.isEmpty)
        #expect(vm.giftRecipients.isEmpty)
        #expect(vm.hashtags.isEmpty)
        #expect(vm.departments.isEmpty)
        #expect(vm.currentHighlightIndex == 0)
        #expect(vm.navigateToSendKudos == false)
        #expect(vm.selectedDetail == nil)
    }

    // MARK: - Load

    @Test("Successful load populates every collection + state.loaded")
    func loadFanOutSuccess() async {
        let svc = StubKudosService()
        svc.highlight = [TestFixtures.makeCard(isOwn: false)]
        svc.feed = [TestFixtures.makeCard(isOwn: false), TestFixtures.makeCard(isOwn: true)]
        svc.stats = KudosStats(
            kudosReceived: 1, kudosSent: 2, heartsReceived: 3,
            secretBoxOpened: 0, secretBoxUnopened: 4
        )
        svc.hashtags = [Hashtag(id: "h1", name: "tag")]
        svc.departments = [Department(id: "d1", name: "Eng")]
        svc.spotlightCount = 9

        let vm = KudosViewModel(service: svc)
        await vm.load()

        #expect(vm.highlightCards.count == 1)
        #expect(vm.allKudosCards.count == 2)
        #expect(vm.stats.kudosReceived == 1)
        #expect(vm.hashtags.count == 1)
        #expect(vm.departments.count == 1)
        #expect(vm.spotlightTotalCount == 9)
        if case .loaded = vm.state { /* ok */ } else { Issue.record("expected loaded state") }
    }

    @Test("Load error puts state into .error")
    func loadError() async {
        let svc = StubKudosService()
        svc.thrownError = ServiceError.network
        let vm = KudosViewModel(service: svc)

        await vm.load()
        #expect(vm.state.error != nil)
    }

    // MARK: - Hearts (TC_FUN_007/008)

    @Test("toggleHeart flips like for a non-own highlight card")
    func toggleHeartHighlightFlips() async {
        let svc = StubKudosService()
        let card = TestFixtures.makeCard(isOwn: false)
        svc.highlight = [card]
        let vm = KudosViewModel(service: svc)
        await vm.load()

        let before = vm.highlightCards[0].isLiked
        vm.toggleHeart(kudosId: card.id)
        #expect(vm.highlightCards[0].isLiked == !before)
    }

    @Test("toggleHeart is a no-op for own cards (TC_FUN_008)")
    func toggleHeartGuardsOwn() async {
        let svc = StubKudosService()
        let own = TestFixtures.makeCard(isOwn: true)
        svc.feed = [own]
        let vm = KudosViewModel(service: svc)
        await vm.load()

        let before = vm.allKudosCards[0].isLiked
        vm.toggleHeart(kudosId: own.id)
        #expect(vm.allKudosCards[0].isLiked == before)
    }

    // MARK: - Carousel

    @Test("Carousel navigation respects bounds")
    func carouselBounds() async {
        let svc = StubKudosService()
        svc.highlight = [
            TestFixtures.makeCard(isOwn: false),
            TestFixtures.makeCard(isOwn: false),
            TestFixtures.makeCard(isOwn: false)
        ]
        let vm = KudosViewModel(service: svc)
        await vm.load()

        // Going prev from 0 is a no-op
        vm.goToPreviousHighlight()
        #expect(vm.currentHighlightIndex == 0)

        vm.goToNextHighlight()
        vm.goToNextHighlight()
        #expect(vm.currentHighlightIndex == 2)

        // At the last index, next is a no-op
        vm.goToNextHighlight()
        #expect(vm.currentHighlightIndex == 2)

        vm.goToPreviousHighlight()
        #expect(vm.currentHighlightIndex == 1)
    }

    // MARK: - Filter selection (TC_FUN_005)

    @Test("selectHashtag resets the carousel index to 0")
    func selectHashtagResetsCarousel() async {
        let svc = StubKudosService()
        svc.highlight = [TestFixtures.makeCard(isOwn: false), TestFixtures.makeCard(isOwn: false)]
        let vm = KudosViewModel(service: svc)
        await vm.load()
        vm.goToNextHighlight()
        #expect(vm.currentHighlightIndex == 1)

        await vm.selectHashtag(Hashtag(id: "h1", name: "tag"))
        #expect(vm.currentHighlightIndex == 0)
        #expect(vm.selectedHashtag?.id == "h1")
    }

    @Test("selectDepartment resets the carousel index to 0")
    func selectDepartmentResetsCarousel() async {
        let svc = StubKudosService()
        svc.highlight = [TestFixtures.makeCard(isOwn: false), TestFixtures.makeCard(isOwn: false)]
        let vm = KudosViewModel(service: svc)
        await vm.load()
        vm.goToNextHighlight()

        await vm.selectDepartment(Department(id: "d1", name: "Eng"))
        #expect(vm.currentHighlightIndex == 0)
        #expect(vm.selectedDepartment?.id == "d1")
    }

    // MARK: - Secret Box (TC_FUN_024/025)

    @Test("openSecretBox decrements unopened + opens reveal nav")
    func openSecretBoxSuccess() async {
        let svc = StubKudosService()
        svc.openBoxResult = true
        svc.stats = KudosStats(
            kudosReceived: 0, kudosSent: 0, heartsReceived: 0,
            secretBoxOpened: 0, secretBoxUnopened: 2
        )
        let vm = KudosViewModel(service: svc)
        await vm.load()
        #expect(vm.stats.secretBoxUnopened == 2)

        await vm.openSecretBox()
        #expect(vm.stats.secretBoxUnopened == 1)
        #expect(vm.stats.secretBoxOpened == 1)
        #expect(vm.navigateToOpenSecretBox == true)
    }

    @Test("openSecretBox is a no-op when no unopened boxes remain")
    func openSecretBoxGuardedZero() async {
        let svc = StubKudosService()
        svc.stats = KudosStats(
            kudosReceived: 0, kudosSent: 0, heartsReceived: 0,
            secretBoxOpened: 0, secretBoxUnopened: 0
        )
        let vm = KudosViewModel(service: svc)
        await vm.load()

        await vm.openSecretBox()
        #expect(vm.navigateToOpenSecretBox == false)
        #expect(vm.stats.secretBoxUnopened == 0)
    }

    // MARK: - badgeLevel (TC_FUN_006)

    @Test("badgeLevel thresholds: 10→1, 20→2, 50→3, below 10→0")
    func badgeLevelThresholds() {
        #expect(KudosViewModel.badgeLevel(heartCount: 0) == 0)
        #expect(KudosViewModel.badgeLevel(heartCount: 9) == 0)
        #expect(KudosViewModel.badgeLevel(heartCount: 10) == 1)
        #expect(KudosViewModel.badgeLevel(heartCount: 19) == 1)
        #expect(KudosViewModel.badgeLevel(heartCount: 20) == 2)
        #expect(KudosViewModel.badgeLevel(heartCount: 49) == 2)
        #expect(KudosViewModel.badgeLevel(heartCount: 50) == 3)
        #expect(KudosViewModel.badgeLevel(heartCount: 9999) == 3)
    }

    // MARK: - Detail navigation

    @Test("openDetail(for:) populates selectedDetail")
    func openDetailSetsBinding() async {
        let svc = StubKudosService()
        let card = TestFixtures.makeCard(isOwn: false)
        svc.feed = [card]
        let vm = KudosViewModel(service: svc)
        await vm.load()

        #expect(vm.selectedDetail == nil)
        vm.openDetail(for: card)
        #expect(vm.selectedDetail != nil)
    }
}
