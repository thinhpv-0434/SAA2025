# Clarifications — [iOS] Sun*Kudos

Screen: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/fO0Kt19sZZ
fileKey: `9ypp4enmFmdK3YAFJLIu6C` · screenId: `fO0Kt19sZZ`

## Session 2026-06-10

- Q: Should the new Sun*Kudos screen REPLACE the KudosTabView stub or sit BEHIND it as a child screen? → A: Replace the stub directly — KudosTabView becomes the Sun*Kudos screen
- Q: How should out-of-scope navigations (Send Kudos, Secret Box, Profile avatar tap, Xem chi tiết) behave? → A: Push existing stubs — WriteKudoView / ProfileTabView / KudosFeedView / empty sheet
- Q: Spotlight Board (B.7) network chart with pan/zoom + live search — scope for v1? → A: Static placeholder image + visible search field; pan/zoom + live search deferred
- Q: Filter logic + heart toggle — backed by REAL local data or surface UI only? → A: Local filtering + local heart toggle on mock array; filter mutates visible subset with AND logic; heart toggles local state
- Q: How to structure the KudosService for 5+ new endpoints? → A: Expand KudosService protocol with all methods (loadHighlight, loadKudos, loadHashtags, loadDepartments, loadSecretBoxStats, openNextSecretBox); single FakeKudosService implements all
- Q: Which business rules to implement locally in v1? → A: Star badges 10/20/50 thresholds + Self-like disable on own kudos + Filter AND logic with carousel reset to card 1; x2 special-day Fire badge deferred (static visual only)
- Q: All Kudos feed depth + pagination behavior? → A: Show 3 mock cards, no pagination; "View all Kudos" link stubbed
- Q: Tests scope for this iteration? → A: ViewModel unit tests for filter + heart logic (TC_FUN_004/005/006/007/008)
