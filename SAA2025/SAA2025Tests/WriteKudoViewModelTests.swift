//
//  WriteKudoViewModelTests.swift
//  SAA2025Tests
//

import Testing
import Foundation
@testable import SAA2025

@MainActor
@Suite("WriteKudoViewModel")
struct WriteKudoViewModelTests {

    // MARK: - canSubmit / isDirty

    @Test("Fresh form: canSubmit=false, isDirty=false")
    func freshFormStateIsClean() {
        let vm = WriteKudoViewModel(service: StubKudosService())
        #expect(vm.canSubmit == false)
        #expect(vm.isDirty == false)
        #expect(vm.showValidationError == false)
    }

    @Test("Fully-filled form: canSubmit=true")
    func canSubmitWhenFilled() {
        let vm = WriteKudoViewModel(service: StubKudosService())
        fill(vm: vm)
        #expect(vm.canSubmit == true)
    }

    @Test("isDirty becomes true after any field changes")
    func isDirtyOnAnyChange() {
        let vm = WriteKudoViewModel(service: StubKudosService())
        vm.title = "Hello"
        #expect(vm.isDirty == true)
    }

    // MARK: - Recipient

    @Test("selectRecipient sets recipient and closes the picker")
    func selectRecipientClosesPicker() {
        let vm = WriteKudoViewModel(service: StubKudosService())
        vm.showRecipientPicker = true
        let user = TestFixtures.makeUser(name: "Alice")
        vm.selectRecipient(user)
        #expect(vm.recipient?.id == user.id)
        #expect(vm.showRecipientPicker == false)
    }

    // MARK: - Hashtags

    @Test("addHashtag normalizes a missing '#' prefix")
    func addHashtagNormalizesPrefix() {
        let vm = WriteKudoViewModel(service: StubKudosService())
        vm.addHashtag("nice")
        #expect(vm.hashtags == ["#nice"])
    }

    @Test("addHashtag preserves an existing '#' prefix")
    func addHashtagPreservesPrefix() {
        let vm = WriteKudoViewModel(service: StubKudosService())
        vm.addHashtag("#cool")
        #expect(vm.hashtags == ["#cool"])
    }

    @Test("Adding a duplicate hashtag is a no-op")
    func addHashtagDedupes() {
        let vm = WriteKudoViewModel(service: StubKudosService())
        vm.addHashtag("dup")
        vm.addHashtag("dup")
        #expect(vm.hashtags.count == 1)
    }

    @Test("addHashtag respects the KudoDraftLimits.hashtagMax cap")
    func addHashtagRespectsCap() {
        let vm = WriteKudoViewModel(service: StubKudosService())
        for i in 0..<(KudoDraftLimits.hashtagMax + 3) {
            vm.addHashtag("tag\(i)")
        }
        #expect(vm.hashtags.count == KudoDraftLimits.hashtagMax)
    }

    @Test("removeHashtag deletes the matching tag")
    func removeHashtag() {
        let vm = WriteKudoViewModel(service: StubKudosService())
        vm.addHashtag("a")
        vm.addHashtag("b")
        vm.removeHashtag("#a")
        #expect(vm.hashtags == ["#b"])
    }

    // MARK: - Images

    @Test("addImage caps at KudoDraftLimits.imageMax")
    func addImageRespectsCap() {
        let vm = WriteKudoViewModel(service: StubKudosService())
        for _ in 0..<(KudoDraftLimits.imageMax + 3) { vm.addImage() }
        #expect(vm.images.count == KudoDraftLimits.imageMax)
    }

    // MARK: - Submit

    @Test("submit() succeeds with a valid filled form")
    func submitSuccess() async {
        let svc = StubKudosService()
        svc.submitResult = true
        let vm = WriteKudoViewModel(service: svc)
        fill(vm: vm)

        let ok = await vm.submit()
        #expect(ok == true)
        #expect(vm.submitError == nil)
    }

    @Test("submit() with an invalid form sets hasAttemptedSubmit + showValidationError")
    func submitInvalidShowsValidation() async {
        let vm = WriteKudoViewModel(service: StubKudosService())
        // form left empty
        let ok = await vm.submit()
        #expect(ok == false)
        #expect(vm.hasAttemptedSubmit == true)
        #expect(vm.showValidationError == true)
    }

    @Test("submit() surfaces service errors via submitError")
    func submitServiceError() async {
        let svc = StubKudosService()
        svc.submitError = ServiceError.network
        let vm = WriteKudoViewModel(service: svc)
        fill(vm: vm)

        let ok = await vm.submit()
        #expect(ok == false)
        #expect(vm.submitError != nil)
    }

    // MARK: - Cancel

    @Test("attemptCancel on a clean form invokes onClean immediately")
    func attemptCancelCleanFiresCallback() {
        let vm = WriteKudoViewModel(service: StubKudosService())
        var didFire = false
        vm.attemptCancel { didFire = true }
        #expect(didFire == true)
        #expect(vm.showCancelConfirm == false)
    }

    @Test("attemptCancel on a dirty form opens the confirmation dialog")
    func attemptCancelDirtyOpensDialog() {
        let vm = WriteKudoViewModel(service: StubKudosService())
        vm.title = "draft"
        var didFire = false
        vm.attemptCancel { didFire = true }
        #expect(didFire == false)
        #expect(vm.showCancelConfirm == true)
    }

    // MARK: - Helpers

    /// Populates the form with the minimal valid payload so `canSubmit` is true.
    private func fill(vm: WriteKudoViewModel) {
        vm.recipient = TestFixtures.makeUser(name: "Bob")
        vm.title = "Title"
        vm.message = "Message"
        vm.addHashtag("kudos")
    }
}
