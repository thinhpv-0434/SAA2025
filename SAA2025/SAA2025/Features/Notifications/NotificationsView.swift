//
//  NotificationsView.swift
//  SAA2025
//
//  Screen: [iOS] Notifications — _b68CBWKl5
//  Design: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/_b68CBWKl5
//

import SwiftUI

// MARK: - NotificationsView

/// Notifications list reached from the bell icon on the Home header. Renders
/// the seven-row feed over the shared Awards keyvisual background, with an
/// unread-state visual for the topmost row and "Đánh dấu đọc tất cả" action
/// above the list.
// mm:6885:9370 — [iOS] Notifications
struct NotificationsView: View {

    @StateObject private var viewModel = NotificationsViewModel()
    @State private var navigateToStandards: Bool = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        ZStack(alignment: .top) {
            AwardsBackground()

            VStack(spacing: 0) {
                NotificationsScreenHeader(onBack: { dismiss() })

                HStack {
                    MarkAllReadButton(onTap: { viewModel.markAllRead() })
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 12)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { _, item in
                            NotificationRow(
                                item: item,
                                onTap: {},
                                onLinkTap: { navigateToStandards = true }
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            if case .idle = viewModel.state {
                await viewModel.load()
            }
        }
        .navigationDestination(isPresented: $navigateToStandards) {
            CommunityStandardsView()
        }
    }
}

#Preview {
    NavigationStack { NotificationsView() }
        .environmentObject(Localizer())
}
