# Phase 3 (US1 MVP) — human visual-verification walkthrough

**STATUS: CHECKPOINT CLOSED — walkthrough PASSED (John, 2026-07-14).** All six items
(a)–(f) below verified against the build described in "Run it." T155–T158 and T150/
T156 are confirmed working end-to-end, including the one visual judgment (FR-055
allergen prominence) automated suites can't make. This file is retained as the
verification record; no further action needed unless a future change touches these
surfaces, in which case re-walk the affected items only.

---

Green test suites don't cover visual judgments (FR-055 allergen *prominence*) or the
feel of the browse→detail→concept flows. This checklist is the human step required
to close the Phase 3 MVP checkpoint — the sandbox has no browser, so this must be
walked through on a real machine with a display.

**Status**: T155–T158 (search reconciliation, entity-info popovers, the raw-localization-key
fix, the garnish-mislabel fix) are all implemented, committed, and covered by green
automated suites. This checkpoint does not close on green suites alone — it closes
when the six items below pass a live human walkthrough. Everything through T164
(identity Phase 4 sub-checkpoint 2 + the T162/T164 security audit) is included in
this build; none of that work touches the US1 surfaces below, so items already
verified on a prior build are noted as carried forward rather than re-asked.

## Run it

Two processes: the backend stack (docker-compose) and the built Flutter web app.

1. **Backend + seeded content** (from repo root):
   ```
   docker compose build api migration-runner
   docker compose up -d migration-runner api
   ```
   The existing Postgres volume already has seeded content (Mai Tai, Daiquiri +
   Hemingway Daiquiri, Whiskey Flip, glossary, equipment) — no reseed needed unless
   starting from a fresh volume. Confirm: `curl http://localhost:5001/health/ready` → 200.

2. **Web app** — rebuild and serve the current bundle (CORS dev default allows any
   localhost origin; the app calls `http://localhost:5001/api/v1`):
   ```
   cd frontend/app
   flutter build web
   cd build/web && python3 -m http.server 8080
   ```
   Open **http://localhost:8080**.

   **Build freshness**: verify the served bundle is actually what's on disk, not a
   stale cache — `sha256sum main.dart.js` on disk must match `curl -s
   http://localhost:8080/main.dart.js | sha256sum`. Confirmed matching for this build
   (2026-07-14): `d76a5c3fd1a0924a39fb061ad1f964471aa8d4de8e863f015a1613edbe4ac203`.

## Verify — the six T155–T158 checkpoint items

### (a) T155 — search-document composition
- [X] Search **"rum"**: a **Recipes** header appears with **Daiquiri**, **Hemingway
  Daiquiri**, and **Mai Tai** — none of these three names contains "rum". This proves
  the recipe search document includes ingredient names at the referenced hierarchy
  level, not just the recipe's own name. (Aged Rum/White Rum ingredient matches
  appear too, under an Ingredients header — expected, not the thing being proven.)
- [X] Search results are typed and grouped with section headers (Recipes /
  Ingredients / Equipment / Glossary). Search "shake" or "muddle": glossary terms
  appear under a Glossary header, distinct from recipe results.

### (b) T157 — resolved labels, no raw localization keys
- [X] Discover browse-list subtitles show localized family names ("Sour", "Flip"),
  never raw keys like `family.sour`.
- [X] Allergen chips show "Egg"/"Tree nut", not `egg`/`treeNut`.
- [X] **Suite coverage confirmed in code** (2026-07-14): the key-shaped-string render
  assertion (`expectNoRawLocalizationKeys`, `test/support/no_raw_l10n_keys.dart`) is
  wired into `test/features/discover/us01_discover_widget_test.dart` and has since
  become the standard pattern reused by every identity screen's widget tests too
  (T047/T049/T050) — this is a code-verifiable fact, not a visual judgment; still
  walk the two boxes above to confirm what a user actually sees.

### (c) T158 — Daiquiri garnish/ice labeling
- [X] The Daiquiri detail shows **"Ice: None (served up)"** and **"Garnish: Lime
  wheel"** as two separate, correctly-labeled lines — no contradiction between them.
  (Determination on record: this was a **renderer bug**, not seed content —
  `recipe_detail_screen.dart` rendered `recipe.iceSpec` under the Garnish label; the
  seed data was always correct. No launch-content QA checklist entry was needed.)

### (d) FR-055 — allergen prominence (visual judgment — the reason this checkpoint can't self-close)
- [X] **Whiskey Flip** (whole egg): the **Egg** allergen banner reads as prominent —
  present near the top of the detail view, above the fold, not buried below the
  instructions. **Verified by John, 2026-07-12.**
- [X] **Mai Tai** (orgeat → tree nuts): the **Tree nut** allergen banner reads as
  prominent, same placement standard. **Verified by John, 2026-07-12.**
- Carried forward from the prior walkthrough — nothing in this build (T049/T050/
  T146/T162/T164, all identity-module work) touches allergen rendering or
  `recipe_detail_screen.dart`. Re-confirm only if this reads differently on this
  build; otherwise no re-walk needed for this specific item.

### (e) T156 — entity-info popovers
- [X] On a recipe detail page, tapping an ingredient line opens a popover with that
  ingredient's description/how-to-use plus a link to its full entry.
- [X] Tapping glassware or an equipment chip does the same for that entity.

### (f) T150 — responsible-consumption banner + support resources
- [X] Every recipe detail page shows a persistent responsible-consumption message
  banner (below the content) with a **"Support resources"** button.
- [X] Tapping "Support resources" opens a sheet listing at least one resource.
- [X] The **About** surface (info icon, top-right of the Discover screen) shows the
  same responsible-use banner (footer/about placement) + support resources.

## Verify — supporting flows (context for the six items above, not separately gating)

- [X] Discover screen loads showing a browse list of recipes (Mai Tai, Daiquiri,
  Hemingway Daiquiri, Whiskey Flip). Family facet chips filter the list.
- [X] Typing "Mai Tai" in search + submitting shows the Mai Tai result; tapping it
  opens the recipe detail with ingredient lines **with names** (not GUIDs),
  instructions, garnish, ice, glassware + equipment by name, ABV/standard drinks,
  creator, history.
- [X] Back out; open the Daiquiri concept page (navigate to `#/concepts/<id>`) — it
  lists **Daiquiri** and **Hemingway Daiquiri** as variants with differentiator text,
  each tapping through to its full recipe.
- [X] Everything above works with **no sign-in** (guest) — no account/sign-in wall
  blocks browsing or reading. (No gated actions are wired into US1 screens yet; the
  sign-in-prompt mechanism itself is unit-tested — T043.)

## Known-deferred (not defects — tracked)
- Glossary terms in recipe text are **not** yet clickable inline links (T152 → Phase 10 / US7).
- SEO pages use ID URLs, not keyword slugs (T153).
- Per-jurisdiction message/support-resource copy and the FR-070 encyclopedia articles
  are launch-content-checklist items (see tasks.md Notes), not built in code.

## Closing this checkpoint

**CLOSED 2026-07-14.** (a)–(f) all passed. The Phase 3 (US1) MVP checkpoint is
formally closed. T163 (MFA backup-code recovery) is next.
