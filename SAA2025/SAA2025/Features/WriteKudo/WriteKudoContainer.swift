//
//  WriteKudoContainer.swift
//  SAA2025
//
//  Owns the WriteKudoViewModel; presents sheets, success toast,
//  cancel-confirm alert, and dismisses on success. Hosted as a
//  NavigationStack destination from KudosTabView.
//

import SwiftUI

// MARK: - WriteKudoContainer

struct WriteKudoContainer: View {

    let onDismiss: () -> Void

    @StateObject private var viewModel: WriteKudoViewModel = WriteKudoViewModel()
    @State private var showSuccessToast: Bool = false
    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        WriteKudoView(
            recipient: $viewModel.recipient,
            title: $viewModel.title,
            message: $viewModel.message,
            hashtags: $viewModel.hashtags,
            images: $viewModel.images,
            isAnonymous: $viewModel.isAnonymous,
            isSubmitting: viewModel.isSubmitting,
            canSubmit: viewModel.canSubmit,
            onBack: handleBack,
            onRecipientTap: { viewModel.showRecipientPicker = true },
            onAwardsInfoTap: { viewModel.showAwardsInfo = true },
            onAddHashtagTap: { viewModel.showHashtagPicker = true },
            onRemoveHashtag: viewModel.removeHashtag,
            onAddImageTap: viewModel.addImage,
            onRemoveImage: viewModel.removeImage,
            onCancel: handleBack,
            onSubmit: handleSubmit
        )
        .task { await viewModel.loadOptions() }
        .sheet(isPresented: $viewModel.showRecipientPicker) {
            RecipientPickerSheet(
                recipients: viewModel.availableRecipients,
                onSelect: { viewModel.selectRecipient($0) },
                onDismiss: { viewModel.showRecipientPicker = false }
            )
        }
        .sheet(isPresented: $viewModel.showHashtagPicker) {
            HashtagPickerSheet(
                allHashtags: viewModel.availableHashtags,
                selectedHashtags: viewModel.hashtags,
                onToggle: { tag in
                    if viewModel.hashtags.contains(tag) {
                        viewModel.removeHashtag(tag)
                    } else {
                        viewModel.addHashtag(tag)
                    }
                },
                onAddFreeText: { viewModel.addHashtag($0) },
                onDismiss: { viewModel.showHashtagPicker = false }
            )
        }
        .sheet(isPresented: $viewModel.showAwardsInfo) {
            AwardsInfoSheet(onDismiss: { viewModel.showAwardsInfo = false })
        }
        .alert(localizer.t("writkudo.cancel.title"), isPresented: $viewModel.showCancelConfirm) {
            Button(localizer.t("writkudo.cancel.btn.discard"), role: .destructive) {
                viewModel.showCancelConfirm = false
                onDismiss()
            }
            Button(localizer.t("writkudo.cancel.btn.continue"), role: .cancel) {
                viewModel.showCancelConfirm = false
            }
        } message: {
            Text(localizer.t("writkudo.cancel.message"))
        }
        .alert(localizer.t("writkudo.error.title"), isPresented: Binding(
            get: { viewModel.submitError != nil },
            set: { if !$0 { viewModel.submitError = nil } }
        )) {
            Button(localizer.t("btn.close"), role: .cancel) {}
        } message: {
            Text(viewModel.submitError ?? "")
        }
        .kudosSentToast(isVisible: showSuccessToast)
    }

    // MARK: - Handlers

    private func handleBack() {
        viewModel.attemptCancel(onClean: onDismiss)
    }

    private func handleSubmit() {
        Task {
            let ok = await viewModel.submit()
            if ok {
                withAnimation(.easeOut(duration: 0.25)) { showSuccessToast = true }
                try? await Task.sleep(for: .seconds(1.2))
                onDismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        WriteKudoContainer(onDismiss: {})
    }
    .environmentObject(Localizer())
}
