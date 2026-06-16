//
//  NotificationRow.swift
//  SAA2025
//

import SwiftUI

// MARK: - NotificationRow

/// One row in the notifications feed. Renders the coloured icon chip on the
/// left, message + optional gold sublink + timestamp on the right. Unread
/// rows pick up a darker rounded container and a small red dot — read rows
/// flatten to a borderless layout separated by hairline dividers (the host
/// view draws the dividers between consecutive read rows).
// mm:I6885:9394 (unread variant) / mm:I6885:9395 (read variant)
struct NotificationRow: View {

    let item: NotificationItem
    let onTap: () -> Void
    let onLinkTap: () -> Void

    private static let unreadBg = Color(red: 0x0E / 255.0, green: 0x16 / 255.0, blue: 0x22 / 255.0)
    private static let unreadBorder = Color.white.opacity(0.10)
    private static let dotColor = Color(red: 0xE6 / 255.0, green: 0x4A / 255.0, blue: 0x4A / 255.0)

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            iconChip
            content
            Spacer(minLength: 4)
            if item.isUnread {
                unreadDot
                    .padding(.top, 4)
            }
        }
        .padding(.horizontal, item.isUnread ? 12 : 4)
        .padding(.vertical, item.isUnread ? 12 : 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(item.isUnread ? Self.unreadBg : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    item.isUnread ? Self.unreadBorder : Color.clear,
                    lineWidth: 1
                )
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }

    private var iconChip: some View {
        Image(systemName: item.iconKind.systemName)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(item.iconKind.tint)
            .frame(width: 28, height: 28, alignment: .top)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(item.message)
                .font(.system(size: 14, weight: item.isUnread ? .semibold : .regular))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)

            if let link = item.linkText {
                Button(action: onLinkTap) {
                    HStack(spacing: 4) {
                        Text(link)
                            .font(.system(size: 13, weight: .semibold))
                            .underline()
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(Color("saaGold"))
                }
                .buttonStyle(PlainButtonStyle())
            }

            Text(item.timestamp)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white.opacity(0.55))
        }
    }

    private var unreadDot: some View {
        Circle()
            .fill(Self.dotColor)
            .frame(width: 6, height: 6)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        VStack(spacing: 8) {
            ForEach(NotificationsFixtures.items.prefix(3)) { item in
                NotificationRow(item: item, onTap: {}, onLinkTap: {})
                    .padding(.horizontal, 16)
            }
        }
    }
}
