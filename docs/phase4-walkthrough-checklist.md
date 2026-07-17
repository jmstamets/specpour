# Phase 4 (US2 Identity) — human visual-verification walkthrough

Green test suites (backend Unit 35/35, Integration 1/1, Contract 35/35, Acceptance
41/41; frontend `flutter analyze` clean, `flutter test` 58/58) cover every scenario's
_logic_. This checklist is the human step for what they can't: whether the identity
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
   (2026-07-15, includes re-walk fixes #1/F1/F2 — T169/T175/T176):
   `e4badd9baa251af153f63e82e60b0259128b609b2b85d5ea48128db8a5e73c02`.

   **Re-walk note (2026-07-15):** finding #1 (registration failing in a real browser)
   is fixed and now guarded by a headless-Chrome integration test
   (`scripts/run-web-integration-tests.sh`). The stale error _presentation_ (raw
   exception text, no reveal toggle / password-policy hint, uncopyable errors) is
   tracked as T170-T172; session persistence (reload logs you out) is T177 — NONE yet fixed — so on this re-walk, registration should
   _succeed and land signed in_, but a deliberately-bad input (short password,
   underage DOB) will still show terse/technical copy until those land.

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
- [N/A] Sign out is not yet wired to any button in this build (no sign-out UI exists —
  a known, already-tracked gap, not something to flag here); to test sign-in
  separately, use a second browser profile or clear site data, then sign in with the
  account just registered.

### (c) T050/T163 — MFA enrollment, backup codes, disable

- [FAIL] From the Account menu, open **Two-factor authentication** → **Set up
  two-factor authentication**. A secret key is shown for manual entry into an
  authenticator app (a real TOTP code is needed to confirm — use an authenticator app
  or a TOTP calculator against the shown secret).
- [-] After confirming with a valid code: a **backup-code list** appears with clear
  wording that these are shown once and won't be shown again. Read the wording —
  does it actually read as urgent/clear to a first-time user, not just technically
  present?
- [-] Tap **"I've saved these codes"** — the codes disappear and do not reappear on
  navigating away and back to this screen.
- [-] Tap **Regenerate backup codes** — a fresh set appears with the same one-time
  framing; dismiss it the same way.
- [-] Tap **Turn off two-factor authentication** — status updates to reflect it's
  off, and the regenerate/disable buttons are replaced by the enroll button again.

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
  NOTE: Active sessions: displays current session, however refreshing the browser requires the user to re-login, and that results in a new entry in Active sessions
- [PASS] Sign in from a second browser/incognito window with the same account, then
  refresh the sessions list in the first — two sessions now appear.
- [PASS] Revoke one session — it disappears from the list immediately.

### (f) T151 — notification preferences

- [PASS] Open **Notification preferences**. Both Email and Push rows appear, both off
  by default.
- [Unable to test - refresh logs out user] Toggle Email on — the switch updates immediately; reload the page and reopen
  the screen to confirm the change actually persisted (not just local UI state).

### (g) T052 — account lifecycle

- [PASS] Open **Deactivate account**. Tapping the deactivate button shows a confirmation
  dialog first (not an immediate action) — cancel it once to confirm cancel actually
  works, then confirm for real.
- [PASS] After deactivating, the screen shows a **Reactivate** option and a confirmation
  message. Reactivating restores the deactivate button.

### (h) T053 — data export and deletion

- [PASS with note: cannot select, copy or export] Open **Your data**. Tap **Export my data** — the caller's date of birth
  appears on screen (this is the _only_ screen anywhere in the app that should ever
  show a raw date of birth — worth confirming no other screen visited during this
  walkthrough ever showed it).
- [PASS] Tap **Delete my account** — a confirmation dialog appears first, with wording that makes clear this is permanent. Cancelling it should leave the account intact (don't confirm delete unless you're fine losing this walkthrough's test account — deleting it ends the session and returns to Discover).

### Not visually verifiable in this build

- Public-attribution anonymization on deletion (spec.md scenario 6) has no UI
  surface — the Community module that owns ratings/attribution doesn't exist yet.
  Covered by backend acceptance tests only.
- FR-004/scenario 7 (default tier) and FR-002b/scenario 8 (audited age-predicate
  access) are backend-internal guarantees with no direct UI to click through;
  covered by contract/acceptance suites only.

## Sign-off

- [ ] All items above walked through and passed.
- [ ] Any failures noted here with enough detail to reproduce:

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
- **F4 (data export must download a file, section (h))** — **STILL OPEN**,
  tracked as T178.
- **Structural browser-tier growth** — ONGOING, T179. `web_auth_smoke_test.dart`
  now covers register, sign-in fail-then-succeed, MFA enroll, and the
  register-path preserve-intent case; still needs MFA confirm/disable,
  reload-restores-session (after T177), export-download (after T178), and
  wiring into a real CI pipeline (T168 — see that task for current status).
- **T170–T173 (error presentation, password UX, selectable/copyable errors,
  social sign-in productionization)** — **STILL OPEN**, not started, last in
  John's sequence.

Sign-off is gated on: ~~T177~~ (DONE, 2026-07-17) → T178 → the (c)/(f)
re-walks → T170–T173, per John's 2026-07-15 sequencing.
