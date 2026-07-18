# Phase 4 (US2 Identity) — human visual-verification walkthrough

Green test suites (backend Unit 35/35, Integration 1/1, Contract 37/37, Acceptance
46/46; frontend `flutter analyze` clean, `flutter test` 77/77; plus the full
headless-Chrome browser tier, including the new frozen-tab test — as of
2026-07-17, branch `phase4-signoff`) cover every scenario's _logic_. This
checklist is the human step for what they can't: whether the identity
feature actually feels reachable and clear as a real person clicking through it — no
US2 surface has had a human walkthrough before this checkpoint (Phase 3's walkthrough
was scoped to US1/Discover only). The crux item is (a): four of these five screens
were built with zero navigation chrome pointing at them until T161 landed this
session — the whole point of this checklist is confirming a person can actually find
them, not just that the code is correct in isolation.

## Run it

Two processes: the backend stack (docker-compose) and the built Flutter web app.

1. **Backend** (from repo root):

   ```
   docker compose up -d
   ```

   Confirm: `curl http://localhost:5001/health/live` → 200.

2. **Web app** — rebuild and serve the current bundle:

   ```
   cd frontend/app
   flutter build web
   cd build/web && python3 -m http.server 8080
   ```

   Open **http://localhost:8080**.

   **Build freshness**: verify the served bundle matches what's on disk —
   `sha256sum main.dart.js` on disk must match `curl -s
http://localhost:8080/main.dart.js | sha256sum`. Confirmed matching for this build
   (2026-07-18, Round 4 refresh — T187 QR-first MFA enrollment, T188 sign out,
   T189 sessions-list polish, plus T195's backup-codes copy addition):
   `200a6b46c1be25e8f4385a5a8b55c4f6520f6779f5616f43fdc216c682562a0d`.

   **Branch note (2026-07-18):** T187-T189 merged to `main` via PR #5; this
   refreshed build is from branch `phase4-biometric-recovery-docs` (the
   biometric/recovery-docs + T195 follow-up batch), which adds only the T195
   backup-codes copy on the frontend (the rest of that branch is docs). The
   `docker compose` API image from the PR #5 line already carries T188's
   `isCurrent` field — no backend change in this batch.

   **Round 4 note (2026-07-18):** the Round 3 walkthrough surfaced three
   findings, now delivered: MFA enrollment is QR-first and scannable (T187 —
   section (c), RE-OPENED for your real-authenticator scan), a Sign out action
   exists (T188 — new section (i)), and the sessions list is humanized with a
   "This device" badge (T189 — folded into section (e)). Everything is green on
   the automated + browser tiers; what's left below is the human verification
   those tiers can't do (a real authenticator scan; the backup-code wording
   judgment; eyeballing the sign-out and sessions UX).

## Verify

### (a) T161 — account nav shell reachability (the crux item)

- [PASS] From the Discover home screen, tap the account icon in the AppBar (right of the
  info/About icon). While signed OUT, this must show a sign-in prompt, not the account
  menu (no account to manage yet).
- [PASS] Register a new account (adult DOB). After registration completes, tap the
  account icon again — it should now open the **Account** menu directly (no prompt),
  listing five destinations: Two-factor authentication, Active sessions, Notification
  preferences, Your data, Deactivate account.
- [PASS] Tap each of the five destinations in turn and confirm each opens its real
  screen (not a blank/error page), then navigate back to the Account menu between
  each.

### (b) T047/T055 — registration and sign-in

- [PASS] Register with an underage DOB (e.g., 10 years ago) — rejected with a clear
  error message, and the form does not silently clear the other fields.
- [PASS] Sign out; to test sign-in separately, use a second browser profile or clear site data, then sign in with the account just registered.
- [PASS] **T171 — password UX**: on the registration screen, confirm (1) a reveal/hide eye icon on the password field (no separate confirm field — reveal replaces it);
  (2) the hint "At least 12 characters" is visible _before_ you type anything or
  submit, not only after a failure; (3) typing fewer than 12 characters and tapping
  submit shows the error bound to the field itself (red text under the field), not a
  form-level banner, and happens instantly with no network delay.
- [PASS] **T170 — error presentation**: sign in with a wrong password. Confirm the
  error reads as plain, friendly copy (e.g. "Invalid email or password"), never raw
  exception/stack-trace text, and a short correlation ID is visible somewhere in or
  near the error (for reporting a bug against a specific attempt).
- [PASS] **T172 — selectable/copyable errors**: on that same sign-in error, try to
  drag-select the error text (should work, unlike the original bug report) and tap
  the copy icon next to it — paste somewhere to confirm the clipboard now holds the
  exact error text including the correlation ID.

### (c) T050/T163/T187 — MFA enrollment, backup codes, disable

**Round 4 partial confirmation (2026-07-18)** — the enrollment UX is now
QR-first (T187, `43dbd93`): a scannable QR code, scan instructions, and the
manual key grouped in fours beneath. **John confirmed QR enrollment with a real
authenticator, and observed regenerate** (marked [PASS] below). Two boxes remain
**OPEN for John** per his sign-off directive: the codes-don't-reappear check and
disable-restores-enroll. (Backup-code wording: John's walkthrough judgment
produced T195, which appended "Without these codes or your authenticator app,
you could lose access to your account." — visible after the next bundle rebuild.)

- [PASS] From the Account menu, open **Two-factor authentication** → **Set up
  two-factor authentication**. A **QR code** appears with scan instructions and
  a manual key beneath. **Scan it with a real authenticator app** (Google/
  Microsoft Authenticator, 1Password, …) — it should add a "SpecPour" entry
  showing a 6-digit code. Enter that code to confirm; enrollment succeeds.
  _(Confirmed with a real authenticator, 2026-07-18.)_
- [PASS with note] After confirming with a valid code: a **backup-code list**
  appears with clear wording that these are shown once and won't be shown again.
  _(Wording judged during the walkthrough → T195 appended the "you could lose
  access to your account" consequence sentence; the updated copy shows after the
  next bundle rebuild.)_
- [ ] **OPEN for John** — Tap **"I've saved these codes"** — the codes disappear
      and do not reappear on navigating away and back to this screen.
- [PASS] Tap **Regenerate backup codes** — a fresh set appears with the same
  one-time framing; dismiss it the same way. _(Observed, 2026-07-18.)_
- [ ] **OPEN for John** — Tap **Turn off two-factor authentication** — status
      updates to reflect it's off, and the regenerate/disable buttons are replaced by
      the enroll button again.

### (d) T050 — account recovery

- [PASS] From the sign-in screen, use the "forgot password" / recovery link. Request
  recovery for the registered email — a generic success message appears regardless
  of whether the email is real (no enumeration signal in the copy).
- [PASS] The actual recovery email isn't inspectable in this build (smtp4dev's web UI at
  `http://localhost:5080` can show it, if desired) — confirming the request screen's
  behavior is enough for this checklist; the full reset-token flow is exhaustively
  covered by acceptance scenarios 4/9/14.

### (e) T051 — sessions

- [PASS with comment] Open **Active sessions** from the Account menu. The current session appears with a device description and a last-active time that reads as a real, human-parseable date (not an ISO timestamp).
  NOTE (Round 1): refreshing the browser required re-login and created a new
  Active-sessions entry — **FIXED, T177** (`8a72024`, PR #2). Re-verify: reload
  the page while on this screen — it should silently restore the _same_ session
  (no re-login, no new entry appears; last-active time bumps instead).
- [PASS] Sign in from a second browser/incognito window with the same account, then
  refresh the sessions list in the first — two sessions now appear.
- [PASS] Revoke one session — it disappears from the list immediately.
- [PASS] **T189 — sessions list polish (2026-07-18)**: the current session now
  shows a **"This device"** badge; device rows read as "{Browser} on {OS}"
  (e.g. "Edge on Windows") with a **Connection details** toggle revealing the
  raw user agent; last-active is relative ("2 hours ago"). Confirm the two open
  sessions from the step above: exactly one is badged "This device", and the
  descriptions are human-readable, not raw UA strings. (Revoking the "This
  device" session is a **Sign out** — see section (i).)
- [NA] **T183 — frozen-tab refresh hardening**: no human step needed here. This
  fix (a background tab that Chrome froze/suspended missing the cross-tab
  refresh handoff, then presenting a stale token and tripping reuse detection —
  logging every tab out) is mechanically verified by an automated browser-tier
  test (`web_frozen_tab_test.dart`, green in CI on every push to this PR) that
  simulates the exact frozen-tab race. Nothing to click through; listed here
  only so this checklist has a record of it.

### (f) T151 — notification preferences

- [PASS] Open **Notification preferences**. Both Email and Push rows appear, both off
  by default.
- [PASS] Toggle Email on — the switch updates immediately; reload the page and
  reopen the screen to confirm the change actually persisted (not just local
  UI state). **This is now testable** — Round 1 marked it "Unable to test,
  refresh logs out user"; T177 (above) means reload no longer signs you out,
  so this can finally be walked end-to-end. Not self-certified as PASS here —
  genuinely needs your click-through.

### (g) T052 — account lifecycle

- [PASS] Open **Deactivate account**. Tapping the deactivate button shows a confirmation
  dialog first (not an immediate action) — cancel it once to confirm cancel actually
  works, then confirm for real.
- [PASS] After deactivating, the screen shows a **Reactivate** option and a confirmation
  message. Reactivating restores the deactivate button.

### (h) T053 — data export and deletion

- [PASS] Open **Your data**. Tap **Export my data** — the caller's date of birth
  appears on screen (this is the _only_ screen anywhere in the app that should ever
  show a raw date of birth — worth confirming no other screen visited during this
  walkthrough ever showed it).
- [PASS] **T178 — real download, `fa661fc`**: tapping **Export my data** should now
  _also_ trigger a browser download of a `specpour-data-export-{userId}.json`
  file (check your Downloads folder). Open the downloaded file and confirm its
  contents match what's shown on screen (userId, email, sessions present) —
  this is mechanically verified by an automated browser test that checks the
  real file on disk (`web_export_download_test.dart`), but confirm the actual
  UX here: is a download this easy to miss, does the browser's download
  indicator make it obvious something happened?
- [PASS] Tap **Delete my account** — a confirmation dialog appears first, with wording that makes clear this is permanent. Cancelling it should leave the account intact (don't confirm delete unless you're fine losing this walkthrough's test account — deleting it ends the session and returns to Discover).

### (i) T188 — sign out (current session) — CONFIRMED by John (2026-07-18)

All four mechanically covered by the browser tier (`web_sign_out_test.dart`,
green in CI) **and confirmed by John's own walkthrough** (2026-07-18: "all tests
pass").

- [PASS] The Account menu has a **Sign out** entry (below the five destinations,
  under a divider).
- [PASS] Tap **Sign out** — it returns to Discover, signed out (tapping the account
  icon now shows the sign-in prompt again, not the account menu).
- [PASS] **Signed out survives reload**: after signing out, reload the page — you
  stay signed out (the persisted token was cleared; you are not silently
  restored).
- [PASS] **Second tab signs out too**: open the app in two tabs, both signed in;
  sign out in one — the other also lands signed out (on Discover).
- [PASS] From **Active sessions**, revoking the row badged **"This device"** (its
  button reads **Sign out**) does the same thing — signs you out and returns to
  Discover. Revoking any _other_ session just drops it from the list.

### Not visually verifiable in this build

- Public-attribution anonymization on deletion (spec.md scenario 6) has no UI
  surface — the Community module that owns ratings/attribution doesn't exist yet.
  Covered by backend acceptance tests only.
- FR-004/scenario 7 (default tier) and FR-002b/scenario 8 (audited age-predicate
  access) are backend-internal guarantees with no direct UI to click through;
  covered by contract/acceptance suites only.

## Sign-off

### Round 4 disposition (2026-07-18) — the current gate

Phase 4 is **not yet formally signed off** — held pending John's confirmation of
the last two open items below. Everything else has been walked and passed across
Rounds 1–4.

- **Confirmed this round (John):** (c) QR MFA enrollment with a real
  authenticator; (c) regenerate backup codes; (e) sessions-list polish (T189
  "This device" badge + humanized descriptions); **(i) all four sign-out checks
  (T188 — confirmed 2026-07-18: "all tests pass")**. Plus all of
  (a),(b),(d),(f),(g),(h) from prior rounds.
- **Still OPEN for John (the whole remaining gate — two boxes in section (c)):**
  - (c) "I've saved these codes" → codes don't reappear.
  - (c) Turn off two-factor → status flips and the enroll button returns.
- **Rides along, not a gate:** the T195 backup-codes copy addition ("…you could
  lose access to your account.") is now in the served bundle (rebuilt this batch).

**On John's confirmation of the open items**, this checklist is committed as the
Phase 4 walkthrough record and Phase 4 is formally signed off; T190 (coverage
baseline) then executes at Phase 5 entry per its schedule.

---

_Historical (Round 1–2) sign-off notes, kept as record:_

- [superseded] All items above walked through and passed.
- [superseded] Any failures noted here with enough detail to reproduce:

Two-factor authentication:

1. Page displays "Two-factor authentication is off"
2. Click "Set up two-factor authentication"
3. Error text (not selectable nor copyable) "Implicit body inferred for parameter "request" but no body was provided. Did you mean to use a Service instead?"
4. Click "Set up two-factor authentication"
5. Error repeats (page refreshes)

NOTE: if a user unsuccsessfully attempts to sign in, "Invalid email or password" is presented. If the user then creates a new sign-in, the user is returned to the login page with the previous data still present (not cleared). Clicking sign in at this point fails, and the sign in button disables, even if the user corrects the information.
HOWEVER, if the user returns to the home page via the left-arrow link in the app, they are actually logged in.

### Round 2 disposition (2026-07-15, after re-walk fixes — see docs/phase4-walkthrough-feedback-2026-07-15.md for John's full findings)

This checklist is **not yet signed off**. Status of every finding above, for
anyone picking this back up:

- **#1 (registration broken on web)** — FIXED, T169 (`07d1c28`). PKCE-semantics
  rider verified, T174 (`06067a7`).
- **F1 (MFA enrollment 500, section (c) step 3 above)** — FIXED, T175
  (`06067a7`). Section (c)'s remaining sub-items (backup-code wording, "I've
  saved these codes", regenerate, disable) were blocked pending a working
  enrollment and **still need a full re-walk with a real/simulated TOTP
  code** — not yet re-walked.
- **F2 (sign-in state-machine/stranding, the NOTE above)** — FIXED, T176
  (`58ccad1`), plus a follow-through browser test for the register-path
  intent (`7a47453`).
- **F3 (session not persisted across reload; orphan sessions in (e))** —
  **FIXED, T177** (`35ee70d`→`8a72024` on branch `t177-session-persistence`,
  PR #2). Reload now silently restores the same session (no re-login, no
  duplicate Active-sessions entry) — proven by an automated browser-tier test
  against the real docker stack (`web_session_persistence_test.dart`'s (a)),
  not just reasoning. This unblocks BOTH (e)'s reload-duplicate-session
  re-walk AND (f)'s persistence check ("Unable to test - refresh logs out
  user") — **(f) is now mechanically verifiable**: reload no longer signs the
  user out, so John's original steps (toggle Email on, reload, reopen, confirm
  persisted) can actually be walked end-to-end for the first time. This note
  confirms the BLOCKER is resolved and automated-tested; it is not a
  substitute for John's own re-walk of (e) and (f) in a real browser — no
  claim of PASS is made here on his behalf, per this project's standing rule
  that MVP-checkpoint-style visual walkthroughs need human verification, not
  just automated-test inference.
- **F4 (data export must download a file, section (h))** — **FIXED, T178**
  (2026-07-17). Tapping **Export my data** now also downloads a real
  `specpour-data-export-{userId}.json` file (the full export payload) —
  confirmed via an automated browser-tier test that checks the actual
  downloaded file on disk, not just that a function ran. The on-screen
  date-of-birth rendering is unchanged (still the only screen that shows a
  raw DOB), now genuinely a courtesy view alongside the real deliverable.
  Flagged for John's own re-walk of (h), not self-certified as PASS, per this
  project's standing human-visual-verification rule.
- **Structural browser-tier growth** — ONGOING, T179. `web_auth_smoke_test.dart`
  now covers register, sign-in fail-then-succeed, MFA enroll, and the
  register-path preserve-intent case; still needs MFA confirm/disable and
  wiring into a real CI pipeline as a _required_ check for that specific file
  (T168 closed the broader CI-provisioning gap and wired the whole browser
  tier in as required — see T168 for status; growing this one file's own
  scenario coverage remains open).
- **T170 (error presentation)** — **FIXED**, `44a802c`. Explicit checklist
  item added to section (b) above.
- **T171 (password UX)** — **FIXED**, `085f187`. Explicit checklist item
  added to section (b) above.
- **T172 (selectable/copyable errors)** — **FIXED**, `745a61c`. Explicit
  checklist item added to section (b) above.
- **T173 (social sign-in productionization)** — **FIXED**, `5f773dd`. No
  checklist item added: this build has zero OAuth providers configured (no
  real Google/Microsoft/Apple credentials exist in any environment this
  codebase has run in — see `docs/oauth-provider-setup.md` for when you
  register them), so the correct, verified-in-CI behavior is that the sign-in
  and register screens show **no social buttons and no divider at all** — if
  you see any social button in this build, that itself is the bug to report.
- **T183 (frozen-tab refresh hardening, found during PR #2 review)** —
  **FIXED**, `6edbf8f`. Explicit note added to section (e) above — no human
  step needed, mechanically verified in CI.

### Round 3 disposition (2026-07-17 — this session, PR #3: `phase4-signoff`)

Every item that was open at the end of Round 2 is now code-complete, and every
automated suite is green on this branch (backend all four suites; frontend
`flutter analyze` clean, `flutter test` 77/77; the full browser tier including
the new frozen-tab test; NuGet vulnerability scan clean; zero generated-client
drift). What's left is **entirely human verification**, in two shapes:

1. **Re-confirm fixes that are already mechanically proven** (T177's reload
   persistence in section (e), T183's frozen-tab hardening, T178's export
   download) — low-risk, these have real automated browser tests behind them,
   but this project's standing rule is that a human still walks the actual UX,
   not just trusts the test suite.
2. **A genuinely new first pass** on section (c) (MFA backup-code UX) and the
   three new T170-T172 checklist items in section (b) — these have widget-test
   coverage but have never been looked at by a human in a real browser.

Sign-off is gated on: this walkthrough, all sections, run once against the
build described above (`c31733e4...79cbb`, branch `phase4-signoff`). No task
is scheduled to remain open after this walkthrough closes except whatever new
findings it surfaces.
