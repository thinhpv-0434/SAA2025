//
//  Strings+EN.swift
//  SAA2025
//

// swiftlint:disable line_length
import Foundation

enum StringsEN {
    static let table: [String: String] = [
        // Tab bar
        "tab.saa2025": "SAA 2025",
        "tab.awards": "Awards",
        "tab.kudos": "Kudos",
        "tab.profile": "Profile",

        // Common buttons / toasts
        "btn.close": "Close",
        "btn.done": "Done",
        "btn.retry": "Retry",
        "form.required": " *",
        "toast.copied": "Copied",
        "toast.kudo_sent": "Kudo sent",
        "stub.coming_soon": "Coming soon (stub)",

        // Login
        "login.tagline": "Start your journey with SAA 2025.\nSign in to explore!",
        "login.copyright": "Copyright Sun* © 2025",
        "login.error.title": "Sign-in failed",
        "login.error.message": "Please try again.",

        // Hero / Event info
        "hero.event.coming_soon": "Coming soon",
        "hero.event.ended": "Event has ended",
        "hero.btn.about_award": "ABOUT AWARD",
        "hero.btn.about_kudos": "ABOUT KUDOS",
        "event.info.time.label": "Time: ",
        "event.info.location": "Venue: Âu Cơ Art Center",
        "event.info.livestream": "Live streaming on the Sun* Family Facebook Group",

        // Home sections
        "home.kudos.subtitle": "Recognition movement",
        "home.kudos.title": "Sun* Kudos",
        "home.kudos.btn.details": "Details",
        "home.awards.subtitle": "Sun* Annual Awards 2025",
        "home.awards.title": "Award system",
        "home.awards.empty": "No awards yet",
        "home.banner.kudos.title": "Sun* Kudos",
        "home.banner.kudos.subtitle": "KUDOS",
        "home.theme.note": "More than a name, \u{201C}Root Further\u{201D} is the spirit every Sun* member is striving for: looking deeply at every context and constantly creating, expanding ourselves to push past the limits we once set. Borrowing the metaphor of color theory, from just three primary colors — red, yellow, and blue — the boundless creativity of each individual can produce an almost infinite spectrum of shades, where every hue stands for breakthrough and limitless creation.",
        "card.award.btn.details": "Details",

        // Kudos
        "kudos.hero.tagline": "Recognition and gratitude platform",
        "kudos.hero.title": "KUDOS",
        "kudos.section.subtitle": "Sun* Annual Awards 2025",
        "kudos.section.highlight.title": "HIGHLIGHT KUDOS",
        "kudos.section.spotlight.title": "SPOTLIGHT BOARD",
        "kudos.section.all.title": "ALL KUDOS",
        "kudos.btn.view_all": "View all Kudos",
        "kudos.btn.send.placeholder": "Who would you like to send kudos to today?",
        "kudos.btn.open_secret_box": "Open Secret Box",
        "kudos.action.copy_link": "Copy Link",
        "kudos.action.view_detail": "View detail",
        "kudos.detail.header.title": "Kudo",
        "kudos.overview.subtitle": "Sun* Annual Awards 2025",
        "kudos.overview.title": "ALL KUDOS",
        "kudos.overview.header.title": "All Kudos",
        "kudos.error.title": "Something went wrong",
        "kudos.recipients.title": "LATEST 10 SUNNERS WHO RECEIVED GIFTS",
        "kudos.stats.received": "Kudos you received:",
        "kudos.stats.sent": "Kudos you sent:",
        "kudos.stats.hearts": "Hearts you received:",
        "kudos.stats.secret_box_opened": "Secret Boxes you opened:",
        "kudos.stats.secret_box_unopened": "Unopened Secret Boxes:",
        "secret_box.title": "Secret Box",
        "secret_box.status.coming_soon": "Coming soon",

        // Write Kudo
        "writkudo.nav.title": "New Kudo",
        "writkudo.form.header": "Send your thanks and recognition to a teammate",
        "writkudo.field.recipient.label": "Recipient",
        "writkudo.field.recipient.placeholder": "Search",
        "writkudo.field.title.label": "Title",
        "writkudo.field.title.placeholder": "Dedicate a title to...",
        "writkudo.field.title.example": "Example: The person who inspires me.",
        "writkudo.field.title.helper": "The title will be shown as the heading of your Kudo.",
        "writkudo.field.message.placeholder": "Share your thanks and recognition with a teammate here!",
        "writkudo.field.anonymous.label": "Send thanks and recognition anonymously",
        "writkudo.hint.mention.prefix": "You can use ",
        "writkudo.hint.mention.syntax": "\"@ + name\"",
        "writkudo.hint.mention.suffix": " to mention another colleague",
        "writkudo.link.community_standards": "Community standards",
        "writkudo.action.cancel": "Cancel",
        "writkudo.action.send": "Send",
        "writkudo.cancel.title": "Discard this Kudo?",
        "writkudo.cancel.message": "Your Kudo content will not be saved.",
        "writkudo.cancel.btn.discard": "Discard",
        "writkudo.cancel.btn.continue": "Keep writing",
        "writkudo.error.title": "Something went wrong",
        "writkudo.hashtag.nav.title": "Hashtag",
        "writkudo.hashtag.counter.prefix": "Selected ",
        "writkudo.hashtag.counter.sep": " / ",
        "writkudo.hashtag.available.label": "Available hashtags",
        "writkudo.hashtag.input.placeholder": "Add a new hashtag…",
        "writkudo.awards_info.title": "Community standards",
        "writkudo.awards_info.description": "Sun*Kudos are awarded based on the SAA 2025 community values. Please use titles that describe specific contributions of your colleagues and avoid any personal attacks.",
        "writkudo.awards_info.examples.label": "Some encouraged title examples:",
        "writkudo.awards_info.example.1": "The person who inspires me",
        "writkudo.awards_info.example.2": "A teammate always ready to help",
        "writkudo.awards_info.example.3": "The unsung hero of the project",
        "writkudo.awards_info.note": "More detailed content will be published by the organizing team soon.",
        "writkudo.recipient_picker.nav.title": "Pick a recipient",
        "writkudo.recipient_picker.search.placeholder": "Search by name or department",
        "writkudo.hashtag.label": "Hashtag",
        "writkudo.image.label": "Image",
        "writkudo.max_5_hint": "(Max 5)",

        // Awards extras
        "awards.kudos.note": "WHAT\u{2019}S NEW IN SAA 2025\nThe recognition and gratitude activity — for the first time available to every Sunner. The activity will roll out in November 2025, encouraging Sun* members to share appreciation with colleagues on the platform announced by the organizing team. The contents will feed into the Heads Council's selection of award recipients.",
        "award.stat.quantity.label": "Number of awards",
        "award.stat.value.label": "Award value",
        "award.stat.value.suffix": "per award",
        "writkudo.error.submit": "Could not send your Kudo. Please try again.",

        // Awards
        "awards.loading.message": "Loading...",
        "awards.select.prompt": "Please select an award.",
        "awards.empty.message": "No awards available.",
        "awards.error.message": "Could not load the awards list.",
        "awards.overview.nav.title": "Awards",
        "award.detail.nav.title": "Award detail",
        "awards.highlight.subtitle": "Sun* Annual Awards 2025",
        "awards.highlight.title": "Award system\nSAA 2025",
        "award.badge.accessibility_label": "Award badge",

        // Profile
        "profile.title": "Profile",
        "profile.nav.title": "Profile",
        "profile.badge.legend_hero": "Legend Hero",
        "profile.icon_collection.title": "My icon collection",
        "profile.kudos.section.subtitle": "Sun* Annual Awards 2025",
        "profile.kudos.section.title": "KUDOS",
        "profile.filter.received": "Received",
        "profile.filter.sent": "Sent",
        "profile.kudos.status.spam": "Spam",
        "profile.other.cta.send_prefix": "Send thanks and recognition to ",
        "profile.other.received_kudos.prefix": "Received ",
        "profile.other.received_kudos.suffix": " kudos",

        // Stub screens
        "search.title": "Search",
        "search.nav.title": "Search",
        "notifications.title": "Notifications",
        "notifications.nav.title": "Notifications",
        "notifications.mark_all_read": "Mark all as read",
        "access_denied.title": "Access Denied",
        "access_denied.nav.title": "Access Denied",
        "access_denied.btn.back_to_login": "Back to Login"
    ]
}
