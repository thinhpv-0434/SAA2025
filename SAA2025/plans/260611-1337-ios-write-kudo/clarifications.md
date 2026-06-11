# Clarifications — iOS Sun*Kudos Write Kudo (composer screen)

**Screen:** [iOS] Sun*Kudos_Viết Kudo_default
**MoMorph:** https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/7fFAb-K35a
**fileKey:** 9ypp4enmFmdK3YAFJLIu6C
**screenId:** 7fFAb-K35a

## Session 2026-06-11

- Q: How should the rich text editor (toolbar + message body) be implemented for v1? → A: Plain TextEditor; toolbar visual-only (no formatting logic). Submit message as plain text.
- Q: How should the recipient picker work (B.2)? → A: Bottom sheet + fake user list from KudosUser fixtures; current user excluded.
- Q: How should hashtag entry (E.2) work? → A: Sheet picker from existing KudosFixtures.hashtags + free-text fallback for new tags.
- Q: How should image upload (F) work given mock-data v1? → A: Mock "Add" inserts a fixed asset (no PHPicker); use cycling sample assets from Assets.xcassets.
- Q: What happens after a successful Send (I)? → A: Success toast "Đã gửi Kudos" + pop NavigationStack back to KudosTabView. Reuse KudosCopiedToast pattern.
- Q: How should the @mention feature behave? → A: Static hint label only; no autocomplete. Typing '@' is plain text; submits as string.
- Q: What should the "Tiêu chuẩn cộng đồng" link (B.5) open? → A: Bottom .sheet with placeholder VN paragraph; content TBD.
- Q: How should Cancel (H) behave with unsaved content? → A: If any required field non-empty, show .alert "Bỏ Kudos này?" with "Hủy bỏ" (destructive) + "Tiếp tục viết" (cancel). If all empty, dismiss immediately.
- Default (no user input needed): Validation timing → submit-time only. Send button disabled until recipient + title + message + ≥1 hashtag are non-empty; on Submit, surface inline error per field if invalid.
- Default: Anonymous mode v1 → boolean only on submitted KudoDraft; visual treatment in feed/detail view deferred.
- Default: Localization → VN strings hardcoded in view files for parity with existing WriteKudoView trajectory; piping through Localizer is a separate cleanup pass.
- Note (2026-06-11 13:39): Track A background subagent extracted full design tokens (card cream #FFF8E1 r=10.72pt, field border #998C5F 0.447px r=3.574pt, send gold #FFEA9E, action row 16pt gap, header "New Kudo" Helvetica Neue 17 semibold, labels Montserrat 14 medium #00101A, helper Montserrat 12 #999999) but hit Write/Bash permission wall. Orchestrator takes over UI work using these tokens.
