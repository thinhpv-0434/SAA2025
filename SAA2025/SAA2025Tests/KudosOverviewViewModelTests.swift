//
//  KudosOverviewViewModelTests.swift
//  SAA2025Tests
//

import Testing
import Foundation
@testable import SAA2025

@MainActor
@Suite("KudosOverviewViewModel")
struct KudosOverviewViewModelTests {

    @Test("Initial: empty cards, idle")
    func initialState() {
        let vm = KudosOverviewViewModel(service: StubKudosService())
        #expect(vm.cards.isEmpty)
        if case .idle = vm.state { /* ok */ } else { Issue.record() }
    }

    @Test("Successful load populates cards + state.loaded")
    func loadSuccess() async {
        let svc = StubKudosService()
        svc.feed = [makeCard(isOwn: false), makeCard(isOwn: true)]
        let vm = KudosOverviewViewModel(service: svc)

        await vm.load()
        #expect(vm.cards.count == 2)
        #expect(vm.state.value != nil)
    }

    @Test("Load error surfaces in state.error")
    func loadError() async {
        let svc = StubKudosService()
        svc.thrownError = ServiceError.network
        let vm = KudosOverviewViewModel(service: svc)

        await vm.load()
        #expect(vm.state.error != nil)
    }

    @Test("toggleHeart on a non-own card flips its like state")
    func toggleHeartFlipsLike() async {
        let svc = StubKudosService()
        let card = makeCard(isOwn: false)
        svc.feed = [card]
        let vm = KudosOverviewViewModel(service: svc)
        await vm.load()

        let beforeLiked = vm.cards[0].isLiked
        vm.toggleHeart(kudosId: card.id)
        #expect(vm.cards[0].isLiked == !beforeLiked)
    }

    @Test("toggleHeart on an own card is a no-op (TC_FUN_008)")
    func toggleHeartGuardsOwnCard() async {
        let svc = StubKudosService()
        let card = makeCard(isOwn: true)
        svc.feed = [card]
        let vm = KudosOverviewViewModel(service: svc)
        await vm.load()

        let beforeLiked = vm.cards[0].isLiked
        vm.toggleHeart(kudosId: card.id)
        #expect(vm.cards[0].isLiked == beforeLiked)
    }

    @Test("toggleHeart with unknown id is a no-op")
    func toggleHeartUnknownIdIsNoOp() async {
        let svc = StubKudosService()
        svc.feed = [makeCard(isOwn: false)]
        let vm = KudosOverviewViewModel(service: svc)
        await vm.load()
        let snapshotLikes = vm.cards.map(\.isLiked)
        vm.toggleHeart(kudosId: UUID())
        #expect(vm.cards.map(\.isLiked) == snapshotLikes)
    }

    // MARK: - Helpers

    private func makeCard(isOwn: Bool) -> KudosCardData {
        TestFixtures.makeCard(isOwn: isOwn)
    }
}
