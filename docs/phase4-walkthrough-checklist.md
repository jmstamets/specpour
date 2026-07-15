# Phase 4 (US2 Identity) — human visual-verification walkthrough

Green test suites (backend Unit 35/35, Integration 1/1, Contract 35/35, Acceptance
41/41; frontend `flutter analyze` clean, `flutter test` 58/58) cover every scenario's
*logic*. This checklist is the human step for what they can't: whether the identity
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
   (2026-07-14): `51120b83061cce870c7d3fda0b7d72e1f8e19c109994979cdb07b8eba8588011`.

## Verify

### (a) T161 — account nav shell reachability (the crux item)
- [ ] From the Discover home screen, tap the account icon in the AppBar (right of the
  info/About icon). While signed OUT, this must show a sign-in prompt, not the account
  menu (no account to manage yet).
- [ ] Register a new account (adult DOB). After registration completes, tap the
  account icon again — it should now open the **Account** menu directly (no prompt),
  listing five destinations: Two-factor authentication, Active sessions, Notification
  preferences, Your data, Deactivate account.
- [ ] Tap each of the five destinations in turn and confirm each opens its real
  screen (not a blank/error page), then navigate back to the Account menu between
  each.

### (b) T047/T055 — registration and sign-in
- [ ] Register with an underage DOB (e.g., 10 years ago) — rejected with a clear
  error message, and the form does not silently clear the other fields.
- [ ] Sign out is not yet wired to any button in this build (no sign-out UI exists —
  a known, already-tracked gap, not something to flag here); to test sign-in
  separately, use a second browser profile or clear site data, then sign in with the
  account just registered.

### (c) T050/T163 — MFA enrollment, backup codes, disable
- [ ] From the Account menu, open **Two-factor authentication** → **Set up
  two-factor authentication**. A secret key is shown for manual entry into an
  authenticator app (a real TOTP code is needed to confirm — use an authenticator app
  or a TOTP calculator against the shown secret).
- [ ] After confirming with a valid code: a **backup-code list** appears with clear
  wording that these are shown once and won't be shown again. Read the wording —
  does it actually read as urgent/clear to a first-time user, not just technically
  present?
- [ ] Tap **"I've saved these codes"** — the codes disappear and do not reappear on
  navigating away and back to this screen.
- [ ] Tap **Regenerate backup codes** — a fresh set appears with the same one-time
  framing; dismiss it the same way.
- [ ] Tap **Turn off two-factor authentication** — status updates to reflect it's
  off, and the regenerate/disable buttons are replaced by the enroll button again.

### (d) T050 — account recovery
- [ ] From the sign-in screen, use the "forgot password" / recovery link. Request
  recovery for the registered email — a generic success message appears regardless
  of whether the email is real (no enumeration signal in the copy).
- [ ] The actual recovery email isn't inspectable in this build (smtp4dev's web UI at
  `http://localhost:5080` can show it, if desired) — confirming the request screen's
  behavior is enough for this checklist; the full reset-token flow is exhaustively
  covered by acceptance scenarios 4/9/14.

### (e) T051 — sessions
- [ ] Open **Active sessions** from the Account menu. The current session appears
  with a device description and a last-active time that reads as a real,
  human-parseable date (not an ISO timestamp).
- [ ] Sign in from a second browser/incognito window with the same account, then
  refresh the sessions list in the first — two sessions now appear.
- [ ] Revoke one session — it disappears from the list immediately.

### (f) T151 — notification preferences
- [ ] Open **Notification preferences**. Both Email and Push rows appear, both off
  by default.
- [ ] Toggle Email on — the switch updates immediately; reload the page and reopen
  the screen to confirm the change actually persisted (not just local UI state).

### (g) T052 — account lifecycle
- [ ] Open **Deactivate account**. Tapping the deactivate button shows a confirmation
  dialog first (not an immediate action) — cancel it once to confirm cancel actually
  works, then confirm for real.
- [ ] After deactivating, the screen shows a **Reactivate** option and a confirmation
  message. Reactivating restores the deactivate button.

### (h) T053 — data export and deletion
- [ ] Open **Your data**. Tap **Export my data** — the caller's date of birth
  appears on screen (this is the *only* screen anywhere in the app that should ever
  show a raw date of birth — worth confirming no other screen visited during this
  walkthrough ever showed it).
- [ ] Tap **Delete my account** — a confirmation dialog appears first, with wording
  that makes clear this is permanent. Cancelling it should leave the account intact
  (don't confirm delete unless you're fine losing this walkthrough's test account —
  deleting it ends the session and returns to Discover).

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
