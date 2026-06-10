# Sun*Kudos Screen Specifications Analysis
**Screen:** iOS Sun*Kudos (screenId: fO0Kt19sZZ, fileKey: 9ypp4enmFmdK3YAFJLIu6C)
**Total Components:** 51 unique (118 rows with deduplication)

## 1. Sections Overview

### A. Hero/Recognition CTA (2 items)
Top banner: "Send Kudos" action button to initiate recognition flow

### B. Highlight Section (28 items)
Top 5 most-appreciated kudos carousel with hashtag/department filtering

### C. All Kudos Feed (9 items)
Paginated list of all active kudos with search & filtering

### D. Stats & Rewards (11 items)
User stats summary + secret box mechanics + top reward recipients


## 2. Component Details by Section

### Section A: Hero/Recognition CTA

**A:** mms_A_KV Kudos
- Type: `others`

**A.1:** mms_A.1_Button ghi nhận
- Type: `button`

### Section B: Highlight Section

**B:** mms_B_Highlight
- Type: `others`

**B.1:** mms_B.1_header
- Type: `others`

**B.1.1:** Nút lọc 'Hastag' | Hashtag Filter Button
- Type: `button`
- Purpose: Purpose and Context Dropdown button that opens a bottom sheet with all available hashtags queried fr
- Interaction: on_click → Opens bottom sheet with hashtag list from DB. On select: filters both Highlight 
- API: API: GET /api/v1/hashtags → loads hashtag list for bottom sheet. Selected hashtag_id used as filter ...

**B.1.2:** Nút 'Phòng ban' | Department Filter Button
- Type: `button`
- Purpose: Purpose and Context Dropdown button that opens a bottom sheet with all departments queried from the 
- Interaction: on_click → Opens bottom sheet with department list from DB. On select: filters both Highlig
- API: API: GET /api/v1/departments → loads department list for bottom sheet. Selected department_id used a...

**B.2:** mms_B.2_HIGHLIGHT KUDOS
- Type: `others`

**B.2.1:** Nút Tiến (Next) | Nút Tiến (Next)
- Type: `button`
- Purpose: Nút 'lùi' tròn (icon chevron-right) để điều hướng carousel Highlight Kudos.  Function: - Tap: Chuyển

**B.2.2:** Nút lùi (nút điều hướng về trước) | Nút lùi (nút điều hướng về trước)
- Type: `button`
- Purpose: Nút điều hướng tiến trong khu vực 'HIGHLIGHT KUDOS'.  Function: - Tap: Trượt carousel sang item tiếp

**B.2.3:** Nội dung Highlight Kudos | Highlight Kudos Content
- Type: `others`
- Data: `kudos.id`
- API: API: GET /api/v1/kudos/highlight → returns top 5 Kudos by heart count (DESC). Supports hashtag_id an...

**B.3:** mms_B.3_KUDO - Highlight | Kudos Highlight Card
- Type: `others`
- Purpose: Purpose and Context Individual featured Kudos card displaying sender information; receiver informati
- Interaction: on_click → Click "Xem chi tiết" navigates to Kudos detail page
- Data: `kudos.id`

**B.3.1:** mms_B.3.1_Avatar người gửi | Sender Avatar
- Type: `file_or_image`
- Purpose: Purpose and Context Circular avatar image of the Kudos sender; displayed at the top-left of the Kudo
- Interaction: on_click → Click navigates to the sender's profile page
- Data: `users.avatar_url`

**B.3.2:** mms_B.3.2_Thông tin người gửi | Sender Info
- Type: `label`
- Purpose: Purpose and Context Displays the sender's truncated name; employee code; and recognition badge label
- Data: `users.full_name; employee_code; badge_type`

**B.3.4:** mms_B.3.4_Icon mũi tên
- Type: `others`

**B.3.5:** mms_B.3.5_Avatar người nhận | Receiver Avatar
- Type: `file_or_image`
- Purpose: Purpose and Context Circular avatar image of the Kudos receiver; displayed at the top-right of the K
- Interaction: on_click → Click navigates to the receiver's profile page
- Data: `users.avatar_url`

**B.3.6:** Thông tin người nhận | Receiver Info (Highlight)
- Type: `label`
- Data: `users.name; avatar_url; department_id; hero_tier`

**B.4:** mms_B.4_Nội dung lời cảm ơn | Kudos Content Area
- Type: `others`
- Purpose: Purpose and Context Container area within the Kudos Highlight card that holds the post timestamp; me
- Data: `kudos.id`

**B.4.1:** mms_B.4.1_Thời gian đăng | Post Time
- Type: `label`
- Purpose: Purpose and Context Timestamp label showing when the Kudos was posted; displayed above the message c
- Data: `kudos.created_at`

**B.4.2:** mms_B.4.2_Nội dung | Kudos Message Content
- Type: `label`
- Purpose: Purpose and Context Displays the kudos message content including the recognition category title and 
- Data: `kudos.title; message`

**B.4.3:** mms_B.4.3_Hashtag | Hashtag Tags
- Type: `label`
- Purpose: Purpose and Context Displays the list of hashtags associated with the Kudos post; allowing quick fil
- Interaction: on_click → Click on a hashtag filters the Highlight feed by that tag
- Data: `kudos_hashtags.tag_name`

**B.4.4:** mms_B.4.4_Action | Action Row
- Type: `others`
- Purpose: Purpose and Context Action bar at the bottom of each Kudos Highlight card; providing heart reaction;
- Interaction: on_click → Click heart toggles like; click Copy Link copies URL; click Xem chi tiết navigat
- Data: `kudos_reactions.kudos_id; user_id`

**B.5:** mms_B.5_slide
- Type: `pagination`

**B.5.1:** Nút lùi (carousel) | Nút lùi (carousel)
- Type: `button`
- Purpose: Nút lùi điều hướng carousel.  Function: - Tap: Chuyển carousel sang card trước đó - Trường hợp đang 

**B.5.2:** mms_B.5.2_số trang
- Type: `label`

**B.5.3:** Nút điều hướng sang phải | Nút điều hướng sang phải
- Type: `button`
- Purpose: Nút chuyển sang mục kế tiếp trong carousel.  Function: - Tap: Trượt carousel sang item tiếp theo - T

**B.6:**  | Spotlight Board Header
- Type: `others`
- Purpose: Section header introducing the Spotlight interactive board.  Display:   - Subtitle: 'Sun* Annual Awa

**B.7:** mms_B.7_Spotlight
- Type: `others`

**B.7.1:** mms_B.7.1_388 KUDOS
- Type: `label`

**B.7.2:** mms_B.7.2_Pan zoom fdsfs
- Type: `others`

**B.7.3:** mms_B.7.3_Tìm kiếm sunner
- Type: `text_form`

### Section C: All Kudos Feed

**C:** mms_C_All kudos
- Type: `others`

**C.1:**  | All Kudos Section Header
- Type: `others`
- Purpose: Section heading for the All Kudos feed.  Display:   - Subtitle: 'Sun* Annual Awards 2025' (small tex

**C.2:** View All Kudos Link | View All Kudos Link
- Type: `button`
- Interaction: on_click → Navigates to full Kudos list screen ([iOS] Sun*Kudos_All Kudos)
- API: Target screen loads: GET /api/v1/kudos with full pagination....

**C.3:** Bài đăng KUDO | Kudos Post Card
- Type: `others`
- Data: `kudos.id; sender_id; recipient_id; message; award_category_name; is_anonymous; created_at`
- API: API: GET /api/v1/kudos?page=N&limit=N&hashtag_id=N&department_id=N → paginated list. Each item inclu...

**C.3.1:** Thông tin người gửi | Sender Info (All Kudos)
- Type: `others`
- Data: `users.name; avatar_url; department_id`

**C.3.2:** Biểu tượng 'sent' | Send Direction Icon
- Type: `others`

**C.3.3:** Thông tin người nhận | Recipient Info (All Kudos)
- Type: `others`
- Data: `users.name; avatar_url; department_id; hero_tier`

**C.3.4:** Nhãn hiển thị thời gian | Post Time Label (All Kudos)
- Type: `label`
- Data: `kudos.created_at`

**C.3.5:** Thẻ nội dung kudos | Kudos Content Card (All Kudos)
- Type: `others`
- Data: `kudos.award_category_name; message`

### Section D: Stats & Rewards

**D.1:** mms_D.1_Thống kê tổng quat
- Type: `others`

**D.1.2:** mms_D.1.2_Số kudos nhận được
- Type: `label`

**D.1.3:** mms_D.1.3_Số kudos đã gửi
- Type: `label`

**D.1.4:** mms_D.1.4_Số tim
- Type: `label`

**D.1.5:** mms_D.1.5_phân cách nội dung
- Type: `others`

**D.1.6:** mms_D.1.6_Số secret box đã mở
- Type: `label`

**D.1.7:** mms_D.1.7_Số secret box chưa mở
- Type: `label`

**D.2:** Open Secret Box CTA | Open Secret Box Button
- Type: `button`
- Interaction: on_click → Opens Secret Box animation/flow screen
- API: API Flow: 1. GET /api/v1/users/me/secret-boxes/next → get next unopened box ID 2. POST /api/v1/users...

**D.3:** mms_D.3_10 SUNNER nhận quà
- Type: `others`

**D.3.1:** mms_D.3.1_title
- Type: `label`

**D.3.2:** mms_D.3.2_Thông tin Sunner nhận quà | Gift Recipient Row
- Type: `others`
- Purpose: Purpose and Context Individual list row showing a Sunner who has received a physical or digital gift
- Interaction: on_click → Click navigates to the recipient's profile page
- Data: `users; reward_recipients.full_name; avatar_url; reward_name`


## 3. API Contract

**API Flow: 1. GET /api/v1/users/me/secret-boxes/next → get next unopened box ID 2. POST /api/v1/users/me/secret-boxes/{boxId}/open → open box, returns **
- Used by: D.2

**API: GET /api/v1/departments → loads department list for bottom sheet. Selected department_id used as filter param for GET /api/v1/kudos and GET /api/**
- Used by: B.1.2

**API: GET /api/v1/hashtags → loads hashtag list for bottom sheet. Selected hashtag_id used as filter param for GET /api/v1/kudos and GET /api/v1/kudos/**
- Used by: B.1.1

**API: GET /api/v1/kudos/highlight → returns top 5 Kudos by heart count (DESC). Supports hashtag_id and department_id query params.**
- Used by: B.2.3

**API: GET /api/v1/kudos?page=N&limit=N&hashtag_id=N&department_id=N → paginated list. Each item includes sender, recipient, message, hashtags, photos, **
- Used by: C.3

**Target screen loads: GET /api/v1/kudos with full pagination.**
- Used by: C.2


## 4. Database Schema

### kudos

- `award_category_name; message`: C.3.5
- `created_at`: B.4.1, C.3.4
- `id`: B.2.3, B.3, B.4
- `id; sender_id; recipient_id; message; award_category_name; is_anonymous; created_at`: C.3
- `title; message`: B.4.2

### kudos_hashtags

- `tag_name`: B.4.3

### kudos_reactions

- `kudos_id; user_id`: B.4.4

### users

- `avatar_url`: B.3.1, B.3.5
- `full_name; employee_code; badge_type`: B.3.2
- `name; avatar_url; department_id`: C.3.1
- `name; avatar_url; department_id; hero_tier`: B.3.6, C.3.3

### users; reward_recipients

- `full_name; avatar_url; reward_name`: D.3.2


## 5. Business Rules & Validation

**Filter Logic** (B.1.1): - Filter logic: AND combination with Phòng ban filter (TC_FUN_004) - On filter change: carousel resets to card 1 (TC_FUN...
**Filter Logic** (B.1.2): - Filter logic: AND combination with Hashtag filter (TC_FUN_004) - On filter change: carousel resets to card 1 (TC_FUN_0...
**Filter Logic** (B.2.3): - Displays top 5 Kudos sorted by heartCount DESC (TC_FUN_001) - Filter: hashtag AND department (AND logic) (TC_FUN_004) ...
**Badge Logic** (B.3.6): - Star badge: 10→1★, 20→2★, 50→3★ (TC_FUN_006) - Tap navigates to recipient profile (TC_ACC_006)...
**Display Logic** (C.3): - Content truncated to 5 lines in list view (TC_GUI_003) - Hashtags truncated to 1 line (TC_GUI_004) - Only active Kudos...
**Badge Logic** (C.3.3): - Tap avatar/name navigates to recipient profile (TC_ACC_007) - Star badge: 10→1★, 20→2★, 50→3★ (TC_FUN_006)...
**Display Logic** (C.3.5): - Message truncated to 5 lines (TC_GUI_003) - Hashtag tags: max 5 on 1 line (TC_GUI_004) - Photo tap opens full image (T...
**State Logic** (D.2): - Button DISABLED when secret_boxes_unopened = 0 (TC_FUN_039) - Double-tap prevention: only 1 open triggered (TC_FUN_025...


## 6. Cross-Component Effects

- **Hashtag filter (B.1.1)** → affects Highlight carousel (B.2.3) + All Kudos feed (C) (AND logic with department)
- **Department filter (B.1.2)** → affects Highlight carousel (B.2.3) + All Kudos feed (C) (AND logic with hashtag)
- **Carousel navigation (B.2.1/B.2.2)** → resets on filter change to card 1
- **Hashtag tap in B.4.3** → filters Highlight feed by that tag
- **Secret Box open (D.2)** → triggers GET next unopened box → POST open → updates stats (opened+1, unopened-1)
- **Profile taps (B.3.2, C.3.1, C.3.3)** → navigate to user profile screens
- **Heart reactions (B.4.4)** → updates kudos_reactions table → affects heartCount sort in Highlight


## 7. States & Loading

- **Highlight carousel**: Empty state if 0 items after filters; pagination resets on filter
- **All Kudos**: Paginated load; infinite scroll pattern (page/limit params)
- **Secret Box button (D.2)**: DISABLED when unopened count = 0
- **Anonymous Kudos**: Sender info masked in display (users table filtered by is_anonymous)
- **Active Kudos only**: Status='active' AND deleted_at IS NULL


## 8. Validation Rules & Constraints

- **Star badges**: 10+ hearts → 1★, 20+ → 2★, 50+ → 3★
- **Text truncation**: Messages max 5 lines in list; Hashtags max 1 line
- **Hashtag tags**: Max 5 per card on 1 line (GUI_004)
- **Filter AND logic**: Both hashtag AND department must pass (FUN_004)
- **Double-tap prevention**: Secret box open prevents double triggers (FUN_025)
- **Photo handling**: Tap opens full image view (FUN_029)


## 9. Draft/Incomplete Items

**23 items in draft status (potential gaps):**

- A: mms_A_KV Kudos
- A.1: mms_A.1_Button ghi nhận
- B: mms_B_Highlight
- B.1: mms_B.1_header
- B.2: mms_B.2_HIGHLIGHT KUDOS
- B.3.4: mms_B.3.4_Icon mũi tên
- B.5: mms_B.5_slide
- B.5.2: mms_B.5.2_số trang
- B.7: mms_B.7_Spotlight
- B.7.1: mms_B.7.1_388 KUDOS
- B.7.2: mms_B.7.2_Pan zoom fdsfs
- B.7.3: mms_B.7.3_Tìm kiếm sunner
- C: mms_C_All kudos
- D.1: mms_D.1_Thống kê tổng quat
- D.1.2: mms_D.1.2_Số kudos nhận được
- D.1.3: mms_D.1.3_Số kudos đã gửi
- D.1.4: mms_D.1.4_Số tim
- D.1.5: mms_D.1.5_phân cách nội dung
- D.1.6: mms_D.1.6_Số secret box đã mở
- D.1.7: mms_D.1.7_Số secret box chưa mở


## 10. Unresolved Questions

1. **Heart limit per user**: Is there a max hearts one user can give per kudos? Rate limiting?
2. **Spotlight section (B.7)**: Purpose unclear—special-day bonus? Monthly highlight? Needs clarification.
3. **Reward recipients (D.3)**: How are 'top 10 rewards' calculated? Last 30 days? This month? All-time?
4. **Anonymous detection UX**: How does the app display anonymous kudos differently? Hidden avatar + 'Anonymous' text?
5. **Filter persistence**: Do filters persist on app return or reset on each session?
6. **Share URL (C.3)**: What does shareUrl contain? Deep link or external share link?
7. **Hashtag AND dept filter UX**: Is it a multi-select or sequential? How is it shown?
