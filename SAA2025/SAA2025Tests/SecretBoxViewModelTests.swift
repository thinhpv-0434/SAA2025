//
//  SecretBoxViewModelTests.swift
//  SAA2025Tests
//

import Testing
import Foundation
@testable import SAA2025

@MainActor
@Suite("SecretBoxViewModel")
struct SecretBoxViewModelTests {

    @Test("Initial: .unopened, unopenedCount honors init param")
    func initialState() {
        let vm = SecretBoxViewModel(unopenedCount: 3)
        #expect(vm.state.isUnopened == true)
        #expect(vm.unopenedCount == 3)
        #expect(vm.state.revealedReward == nil)
    }

    @Test("openNext flips to .opening immediately, then .revealed after a brief delay")
    func openNextRevealsReward() async {
        let vm = SecretBoxViewModel(unopenedCount: 2)
        vm.openNext()
        if case .opening = vm.state { /* ok */ } else { Issue.record("state should be .opening") }

        // The internal Task sleeps ~700ms — wait a bit longer.
        try? await Task.sleep(for: .milliseconds(900))

        #expect(vm.state.revealedReward != nil)
        #expect(vm.unopenedCount == 1)
    }

    @Test("openNext is a no-op when no boxes remain")
    func openNextRespectsZeroCount() async {
        let vm = SecretBoxViewModel(unopenedCount: 0)
        vm.openNext()
        #expect(vm.state.isUnopened == true)  // never left the initial state
        #expect(vm.unopenedCount == 0)
    }

    @Test("openNext is a no-op while another reveal is mid-flight")
    func openNextGuardsConcurrentTaps() async {
        let vm = SecretBoxViewModel(unopenedCount: 5)
        vm.openNext()
        // Second tap while still .opening
        vm.openNext()
        try? await Task.sleep(for: .milliseconds(900))

        // Only ONE box opened despite two taps.
        #expect(vm.unopenedCount == 4)
    }

    @Test("resetToUnopened flips back to .unopened so the next roll can happen")
    func resetToUnopened() async {
        let vm = SecretBoxViewModel(unopenedCount: 2)
        vm.openNext()
        try? await Task.sleep(for: .milliseconds(900))
        #expect(vm.state.revealedReward != nil)

        vm.resetToUnopened()
        #expect(vm.state.isUnopened == true)
    }

    @Test("resetToUnopened is a no-op when no boxes remain")
    func resetGuardedAtZero() async {
        let vm = SecretBoxViewModel(unopenedCount: 1)
        vm.openNext()
        try? await Task.sleep(for: .milliseconds(900))
        #expect(vm.unopenedCount == 0)

        vm.resetToUnopened()
        // Still in .revealed because no boxes left to roll.
        if case .revealed = vm.state { /* ok */ } else { Issue.record("state should still be .revealed") }
    }
}
