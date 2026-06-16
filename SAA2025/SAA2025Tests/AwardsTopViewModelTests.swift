//
//  AwardsTopViewModelTests.swift
//  SAA2025Tests
//

import Testing
import Foundation
@testable import SAA2025

@MainActor
@Suite("AwardsTopViewModel")
struct AwardsTopViewModelTests {

    @Test("Initial state: idle, no selection")
    func initialState() {
        let vm = AwardsTopViewModel(awardsService: StubAwardsService(), tokenStore: makeCleanTokenStore())
        if case .idle = vm.awardsState { /* ok */ } else { Issue.record() }
        #expect(vm.selectedAwardID == nil)
        #expect(vm.selectedAward == nil)
    }

    @Test("Load with multiple awards defaults the selection to 'Top Project'")
    func defaultSelectionIsTopProject() async {
        let stub = StubAwardsService()
        let mvp = Award(id: UUID(), title: "MVP", shortDescription: "", imageName: "")
        let topProject = Award(id: UUID(), title: "Top Project", shortDescription: "", imageName: "")
        stub.awards = [mvp, topProject]
        let vm = AwardsTopViewModel(awardsService: stub, tokenStore: makeCleanTokenStore())

        await vm.load()
        #expect(vm.selectedAward?.title == "Top Project")
    }

    @Test("Without 'Top Project' in the list, selection falls back to the first award")
    func fallbackToFirstAward() async {
        let stub = StubAwardsService()
        let mvp = Award(id: UUID(), title: "MVP", shortDescription: "", imageName: "")
        let bm = Award(id: UUID(), title: "Best Manager", shortDescription: "", imageName: "")
        stub.awards = [mvp, bm]
        let vm = AwardsTopViewModel(awardsService: stub, tokenStore: makeCleanTokenStore())

        await vm.load()
        #expect(vm.selectedAward?.title == "MVP")
    }

    @Test("Empty award list maps to .empty and clears selection")
    func loadEmpty() async {
        let stub = StubAwardsService()
        stub.awards = []
        let vm = AwardsTopViewModel(awardsService: stub, tokenStore: makeCleanTokenStore())

        await vm.load()
        #expect(vm.awardsState.isEmpty == true)
        #expect(vm.selectedAwardID == nil)
    }

    @Test("selectAward(byTitle:) overrides default selection after load")
    func selectByTitleOverrides() async {
        let stub = StubAwardsService()
        let mvp = Award(id: UUID(), title: "MVP", shortDescription: "", imageName: "")
        let topProject = Award(id: UUID(), title: "Top Project", shortDescription: "", imageName: "")
        stub.awards = [mvp, topProject]
        let vm = AwardsTopViewModel(awardsService: stub, tokenStore: makeCleanTokenStore())

        await vm.load()
        #expect(vm.selectedAward?.title == "Top Project")

        vm.selectAward(byTitle: "MVP")
        #expect(vm.selectedAward?.title == "MVP")
    }

    @Test("selectAward(byTitle:) is a no-op for unknown titles")
    func selectByUnknownTitleNoOp() async {
        let stub = StubAwardsService()
        stub.awards = [Award(id: UUID(), title: "Top Project", shortDescription: "", imageName: "")]
        let vm = AwardsTopViewModel(awardsService: stub, tokenStore: makeCleanTokenStore())
        await vm.load()
        let beforeID = vm.selectedAwardID

        vm.selectAward(byTitle: "Nonexistent Award")
        #expect(vm.selectedAwardID == beforeID)
    }

    @Test("ServiceError.forbidden routes to access-denied")
    func forbiddenRoutes() async {
        let stub = StubAwardsService()
        stub.thrownError = ServiceError.forbidden
        let vm = AwardsTopViewModel(awardsService: stub, tokenStore: makeCleanTokenStore())
        await vm.load()
        #expect(vm.navigateToAccessDenied == true)
    }

    @Test("ServiceError.unauthorized clears the TokenStore")
    func unauthorizedClearsToken() async {
        let store = makeCleanTokenStore()
        store.save("seed")
        let stub = StubAwardsService()
        stub.thrownError = ServiceError.unauthorized
        let vm = AwardsTopViewModel(awardsService: stub, tokenStore: store)
        await vm.load()
        #expect(store.token == nil)
    }

    @Test("Re-entering load() while already loading is ignored (guard)")
    func reentrantLoadIsGuarded() async {
        let stub = StubAwardsService()
        stub.awards = [Award(id: UUID(), title: "Top Project", shortDescription: "", imageName: "")]
        let vm = AwardsTopViewModel(awardsService: stub, tokenStore: makeCleanTokenStore())

        // Fire two loads concurrently — both should complete cleanly,
        // and the state must end in .loaded with one award.
        async let a: () = vm.load()
        async let b: () = vm.load()
        _ = await (a, b)

        #expect(vm.awardsState.value?.count == 1)
    }
}
