//
//  Strings+JA.swift
//  SAA2025
//

// swiftlint:disable line_length
import Foundation

enum StringsJA {
    static let table: [String: String] = [
        // Tab bar
        "tab.saa2025": "SAA 2025",
        "tab.awards": "アワード",
        "tab.kudos": "Kudos",
        "tab.profile": "プロフィール",

        // Common buttons / toasts
        "btn.close": "閉じる",
        "btn.done": "完了",
        "btn.retry": "再試行",
        "form.required": " *",
        "toast.copied": "コピーしました",
        "toast.kudo_sent": "Kudosを送信しました",
        "stub.coming_soon": "近日公開(プレビュー)",

        // Login
        "login.tagline": "SAA 2025とともに旅を始めましょう。\nログインして探検しよう!",
        "login.copyright": "Copyright Sun* © 2025",
        "login.error.title": "ログインに失敗しました",
        "login.error.message": "もう一度お試しください。",

        // Hero / Event info
        "hero.event.coming_soon": "近日公開",
        "hero.event.ended": "イベントは終了しました",
        "hero.btn.about_award": "アワードについて",
        "hero.btn.about_kudos": "KUDOSについて",
        "event.info.time.label": "時間: ",
        "event.info.location": "会場: Âu Cơ Art Center",
        "event.info.livestream": "Sun* Family Facebook グループでライブ配信",

        // Home sections
        "home.kudos.subtitle": "感謝のムーブメント",
        "home.kudos.title": "Sun* Kudos",
        "home.kudos.btn.details": "詳細",
        "home.awards.subtitle": "Sun* Annual Awards 2025",
        "home.awards.title": "アワード制度",
        "home.awards.empty": "アワードはまだありません",
        "home.banner.kudos.title": "Sun* Kudos",
        "home.banner.kudos.subtitle": "KUDOS",
        "home.theme.note": "単なる名前ではなく、「Root Further」はSun*メンバー一人ひとりが目指す精神そのものです。あらゆる文脈を深く見つめ、絶え間なく創造し、自ら設けた限界を超えて広がり続ける姿勢。色彩理論の比喩を借りれば、赤・黄・青のたった三原色から、個々の無限の創造力はほぼ無限の色合いを生み出し、それぞれの色がブレイクスルーと限りない創造を象徴しています。",
        "card.award.btn.details": "詳細",

        // Kudos
        "kudos.hero.tagline": "感謝と称賛を伝えるプラットフォーム",
        "kudos.hero.title": "KUDOS",
        "kudos.section.subtitle": "Sun* Annual Awards 2025",
        "kudos.section.highlight.title": "HIGHLIGHT KUDOS",
        "kudos.section.spotlight.title": "SPOTLIGHT BOARD",
        "kudos.section.all.title": "ALL KUDOS",
        "kudos.btn.view_all": "すべてのKudosを見る",
        "kudos.btn.send.placeholder": "今日は誰にKudosを送りたいですか?",
        "kudos.btn.open_secret_box": "Secret Boxを開ける",
        "kudos.action.copy_link": "リンクをコピー",
        "kudos.action.view_detail": "詳細を見る",
        "kudos.detail.header.title": "Kudo",
        "kudos.overview.subtitle": "Sun* Annual Awards 2025",
        "kudos.overview.title": "ALL KUDOS",
        "kudos.overview.header.title": "すべてのKudos",
        "kudos.error.title": "エラーが発生しました",
        "kudos.recipients.title": "ギフトを受け取った最新の10人",
        "kudos.stats.received": "受け取ったKudos数:",
        "kudos.stats.sent": "送ったKudos数:",
        "kudos.stats.hearts": "受け取ったハート数:",
        "kudos.stats.secret_box_opened": "開けたSecret Box数:",
        "kudos.stats.secret_box_unopened": "未開封のSecret Box数:",
        "secret_box.title": "Secret Box",
        "secret_box.status.coming_soon": "近日公開",

        // Write Kudo
        "writkudo.nav.title": "新規Kudo",
        "writkudo.form.header": "チームメイトに感謝と称賛を送りましょう",
        "writkudo.field.recipient.label": "受信者",
        "writkudo.field.recipient.placeholder": "検索",
        "writkudo.field.title.label": "称号",
        "writkudo.field.title.placeholder": "称号を贈る相手...",
        "writkudo.field.title.example": "例: 私にやる気を与えてくれる人。",
        "writkudo.field.title.helper": "称号はKudoのタイトルとして表示されます。",
        "writkudo.field.message.placeholder": "ここでチームメイトに感謝と称賛を伝えましょう!",
        "writkudo.field.anonymous.label": "匿名で感謝と称賛を送る",
        "writkudo.hint.mention.prefix": "あなたは ",
        "writkudo.hint.mention.syntax": "\"@ + 名前\"",
        "writkudo.hint.mention.suffix": " で他の同僚をメンションできます",
        "writkudo.link.community_standards": "コミュニティ規範",
        "writkudo.action.cancel": "キャンセル",
        "writkudo.action.send": "送信",
        "writkudo.cancel.title": "このKudoを破棄しますか?",
        "writkudo.cancel.message": "Kudoの内容は保存されません。",
        "writkudo.cancel.btn.discard": "破棄",
        "writkudo.cancel.btn.continue": "書き続ける",
        "writkudo.error.title": "エラーが発生しました",
        "writkudo.hashtag.nav.title": "ハッシュタグ",
        "writkudo.hashtag.counter.prefix": "選択済み ",
        "writkudo.hashtag.counter.sep": " / ",
        "writkudo.hashtag.available.label": "利用可能なハッシュタグ",
        "writkudo.hashtag.input.placeholder": "新しいハッシュタグを追加…",
        "writkudo.awards_info.title": "コミュニティ規範",
        "writkudo.awards_info.description": "Sun*KudosはSAA 2025のコミュニティ価値観に基づいて贈られます。同僚の具体的な貢献を表す称号を使い、個人攻撃となる内容は避けてください。",
        "writkudo.awards_info.examples.label": "推奨される称号の例:",
        "writkudo.awards_info.example.1": "私にインスピレーションを与えてくれる人",
        "writkudo.awards_info.example.2": "いつでも助けてくれるチームメイト",
        "writkudo.awards_info.example.3": "プロジェクトの陰の英雄",
        "writkudo.awards_info.note": "詳細は運営チームより近日公開されます。",
        "writkudo.recipient_picker.nav.title": "受信者を選択",
        "writkudo.recipient_picker.search.placeholder": "名前または部署で検索",
        "writkudo.hashtag.label": "ハッシュタグ",
        "writkudo.image.label": "画像",
        "writkudo.max_5_hint": "(最大5)",

        // Awards extras
        "awards.kudos.note": "SAA 2025の新機軸\n同僚への感謝と称賛を共有する活動で、すべてのSunnerに初めて開放されます。活動は2025年11月に開始予定で、運営チームが発表するプラットフォーム上でSun*メンバーが感謝の言葉を共有することを推奨します。これらはHeads評議会による受賞者選考の参考資料となります。",
        "award.stat.quantity.label": "賞の数",
        "award.stat.value.label": "賞の価値",
        "award.stat.value.suffix": "1つの賞につき",
        "writkudo.error.submit": "Kudosを送信できませんでした。もう一度お試しください。",

        // Awards
        "awards.loading.message": "読み込み中...",
        "awards.select.prompt": "アワードを選択してください。",
        "awards.empty.message": "アワードはまだありません。",
        "awards.error.message": "アワード一覧を読み込めませんでした。",
        "awards.overview.nav.title": "アワード",
        "award.detail.nav.title": "アワード詳細",
        "awards.highlight.subtitle": "Sun* Annual Awards 2025",
        "awards.highlight.title": "アワード制度\nSAA 2025",
        "award.badge.accessibility_label": "アワードバッジ",

        // Profile
        "profile.title": "プロフィール",
        "profile.nav.title": "プロフィール",
        "profile.badge.legend_hero": "Legend Hero",
        "profile.icon_collection.title": "マイアイコンコレクション",
        "profile.kudos.section.subtitle": "Sun* Annual Awards 2025",
        "profile.kudos.section.title": "KUDOS",
        "profile.filter.received": "受信",
        "profile.filter.sent": "送信",
        "profile.kudos.status.spam": "Spam",
        "profile.other.cta.send_prefix": "感謝と称賛を送る: ",
        "profile.other.received_kudos.prefix": "受け取った ",
        "profile.other.received_kudos.suffix": " kudos",

        // Stub screens
        "search.title": "検索",
        "search.nav.title": "検索",
        "search.input.placeholder": "Sunnerを検索",
        "search.recent.title": "最近",
        "search.recent.view_all": "すべて表示",
        "notifications.title": "通知",
        "notifications.nav.title": "通知",
        "notifications.mark_all_read": "すべて既読にする",
        "access_denied.title": "アクセス拒否",
        "access_denied.nav.title": "アクセス拒否",
        "access_denied.btn.back_to_login": "ログインへ戻る"
    ]
}
