# Phase 5 Round 1 — human visual-verification walkthrough (US3 + US4)

> **STATUS: AWAITING WALKTHROUGH (John).** Prepared 2026-07-20 (T205). Nothing
> below is self-certified — every item is yours to pass or fail. Findings become
> their own filed tasks in the next batch, as every prior round's did.

Green suites cover the *logic* of everything here — backend Unit 38/38,
Integration 1/1, Contract 39/39, Acceptance 62/62; frontend `flutter analyze`
clean, `flutter test` **107/107**; plus the headless-Chrome browser tier
(T065's real inventory journey). This checklist is the human step for what
suites structurally cannot judge: whether these features are **reachable,
legible, and coherent** to a person clicking through them.

Three prior rounds justify the ceremony — each found a real defect that every
green suite had missed: raw i18n keys rendering as `family.sour` (T157), a
garnish/ice label contradiction on a correct dataset (T158), and a
registration flow that was green everywhere and **dead in a real browser**
(T169). Correct code, wrong experience, invisible to CI.

**Scope:** US3 (Author a Personal Library) and US4 (Track Inventory / "What
Can I Make?"). This is the first walkthrough since Phase 4 signed off, so it
covers everything built since. Naming follows the directive's own words
("Phase 5 Round 1") though the surfaces span Phase 5 (US3) and Phase 6 (US4).

---

## Run it

Both processes are **already running** as of this document's preparation. If
you're picking this up later, re-run them and re-verify freshness.

1. **Backend** — `docker compose up -d` (from repo root).
   - Confirmed: `curl http://localhost:5001/health/live` → **200**.
   - **API freshness verified, not assumed**: the running `specpour-api` image
     was built 2026-07-19T19:37Z, and `git log --since` confirms **zero
     commits touching `backend/` since then** (last backend commit: `bf07171`,
     T148). The image carries the merged US4 backend — spot-confirmed against
     the live OpenAPI doc: `/api/v1/inventory/{items,makeable,recognize}` all
     present, `/api/v1/recipes` advertises the `makeable` parameter, and the
     `Makeability*`/`SatisfiedBy`/`Requirement` schemas are published.

2. **Web app** — built and served from `frontend/app/build/web` on port 8080.

   ```
   cd frontend/app && flutter build web
   cd build/web && python3 -m http.server 8080
   ```

   ### → Open **http://localhost:8080**

   **Build freshness** (standing convention — a stale bundle has wasted a
   walkthrough round before): served bundle checksum-verified against disk.

   ```
   on-disk main.dart.js : cd5eb50af11b81d1090e33df45aace83d1d628d00e5a7be7205ea919def88adf
   served  main.dart.js : cd5eb50af11b81d1090e33df45aace83d1d628d00e5a7be7205ea919def88adf
                          MATCH ✅
   ```

   Built from branch `phase6-t204-t205-walkthrough-prep` (T204 + T205 + ledger
   updates), which contains **no frontend source changes** — it is `main`
   (`a068818`, PR #11 merged) plus a shell script and docs.

### Seed content you'll be working against

4 recipes / 14 ingredients (the T040/T181 curated set):

| Recipe | Ingredient lines |
|---|---|
| **Daiquiri** | White Rum 2oz, Lime Juice 1oz, Simple Syrup 0.75oz |
| **Hemingway Daiquiri** | White Rum 2oz, Lime Juice 0.75oz, Grapefruit Juice 0.5oz, Maraschino Liqueur 0.5oz |
| **Mai Tai** | Aged Rum 1.5oz, Lime Juice 0.75oz, Orange Curaçao 0.5oz, Orgeat 0.5oz, Rich Simple Syrup 0.25oz |
| **Whiskey Flip** | Bourbon 2oz, Rich Simple Syrup 0.75oz, Whole Egg 1 whole |

Full ingredient list: Aged Rum, Angostura Bitters, **Beefeater**, Bourbon,
Grapefruit Juice, Lime Juice, **London Dry Gin**, Maraschino Liqueur, Orange
Curaçao, Orgeat, Rich Simple Syrup, Simple Syrup, White Rum, Whole Egg.
The **only** hierarchy edge in the entire seed is Beefeater → London Dry Gin
(this matters for item **(k)**).

### Account

Both stories are bearer-only; you'll need to be signed in. Register at
`/register` if needed — **password minimum is 12 characters, no composition
rules** (T171), and the age gate is real, so use an of-age date of birth.

---

## Read this before you start — known gaps, do NOT fail these

Three things are already-known missing work, filed as tasks during prep
(**before** the walkthrough, so they don't consume a finding slot). Please
don't burn time failing items for them:

- **T206 — Inventory has no navigation entry point.** Nothing in the app links
  to `/inventory`. You must type **http://localhost:8080/#/inventory** into
  the address bar. Verified by grep: Discover's AppBar has exactly three
  actions (library, account, about) and no screen anywhere pushes
  `/inventory`. This is the T161 gap class recurring a third time. *The
  library does not have this problem — its button is wired.*
- **T207 — T148's makeable facet has no frontend surface.** "Filter Discover
  to what I can make" is backend-only (`GET /recipes?makeable=true` works and
  is acceptance-tested; the Flutter app never sends it). Makeability is
  visible **only** inside Inventory's own Makeable tab. Don't look for a
  makeable filter on Discover — it isn't built.
- **T208 — the substitution rung of the ladder is not walkable.** The seed has
  zero curated substitution rules and no UI to add one, so no sequence of
  clicks can produce a substitution-grade match. It's covered by tests, but
  **no human has ever seen how it renders** — noted honestly rather than
  dressed up as a passable item.

**Also not a defect:** there is **no publish / visibility control** in the
library UI. US3 authoring is private-by-default; publishing (FR-021 variant
attach) is a later story. Confirmed by grep — no `visibility`/`publish`
anywhere in `features/library/`. Don't look for it.

---

## US3 — Author a Personal Library

### (a) Library is reachable and guest-gated
- [ ] From Discover, the **book icon** in the AppBar opens the Library.
- [ ] Signed **out**, tapping it prompts to sign in/register rather than
      silently doing nothing or showing an empty library.
- [ ] After signing in you land in the Library (not dumped back to Discover).

### (b) Library landing screen
- [ ] Two clearly labelled sections: **Recipes** and **Ingredients**.
- [ ] With nothing authored yet, **both** show a real empty-state message —
      not a blank area, not a spinner that never resolves.
- [ ] A **Manage venues** action is present in the AppBar.
- [ ] Create buttons for both a recipe and a house-made ingredient are obvious.

### (c) Recipe editor — the core US3 surface
Create a recipe. Judge it as an author, not a tester.
- [ ] **Primary name** and **alternate names** fields, and it's clear that
      alternate names are optional and comma-separated (or however it asks).
- [ ] A **library scope** selector offering **Personal** and **Bar**.
- [ ] Choosing **Bar** reveals a **venue** picker. With no venues yet, it shows
      a helpful hint rather than an empty/broken dropdown.
- [ ] **Instructions**: you can add multiple steps, and their order is clear.
- [ ] **Ingredient lines**: for each line — ingredient picker (populated from
      the 14 seeded ingredients), quantity, unit, scaling rule, purpose — plus
      **add** and **remove** controls that behave sanely (removing the middle
      line removes *that* line).
- [ ] Submitting with required fields blank shows a **field-legible error**,
      not a raw exception (T170's rule: no exception text ever reaches a user).
- [ ] A valid recipe saves, and you return to the Library **with the new
      recipe listed**.
- [ ] **No raw localization keys anywhere** (`recipeEditor.something`,
      `family.sour`) — the T157 defect class.

### (d) Venues
- [ ] Manage venues → empty state reads sensibly.
- [ ] The create-venue sheet takes **name, address, latitude, longitude**.
- [ ] Submitting it empty gives a friendly validation message.
- [ ] A created venue appears in the list, and then becomes selectable as the
      **Bar** scope venue back in the recipe editor **(c)**.

### (e) House-made ingredient editor
- [ ] Fields: name, **defining recipe** picker, yield quantity, yield unit,
      shelf-life days, storage instructions.
- [ ] With no recipes authored, the defining-recipe picker shows a hint and
      offers a route to create one — rather than a dead empty dropdown.
- [ ] A saved house-made ingredient appears in the Library's Ingredients
      section.
- [ ] **Judgment call for you:** is it clear what a "house-made ingredient"
      *is* from this screen alone? This is the surface most likely to be
      conceptually opaque to a real user.

---

## US4 — Track Inventory and "What Can I Make?"

Reach it at **http://localhost:8080/#/inventory** (see T206 above).

### (f) Inventory landing
- [ ] Two tabs: **Items** (your bottles) and **Makeable**.
- [ ] An **add** floating action button is obvious.
- [ ] Empty inventory shows a real empty-state message on both tabs.

### (g) Adding a bottle — manual path
- [ ] Add screen offers an **ingredient** picker, **quantity**, and **bottle
      size**, plus **Photo** and **Barcode** buttons.
- [ ] Submitting with no ingredient selected gives a friendly error.
- [ ] Add **White Rum** — it appears in the Items tab with its quantity and
      bottle size rendered legibly (correct units, no raw enum values).

### (h) Photo and barcode paths — expected to degrade gracefully
The vision provider is deliberately **unconfigured** (T202 is parked pending
real credentials), so recognition *always* reports "not recognized". That is
correct behavior here, not a bug.
- [ ] **Photo** button: picking an image produces a clear "not recognized"
      status message and **leaves you able to enter the bottle manually** —
      it must not dead-end, hang, or discard what you'd already typed.
- [ ] **Barcode** button: opens the scanner shell without crashing. (Camera
      behavior in a desktop browser is best-effort — judge only that it
      fails *gracefully*.)
- [ ] **Judgment call:** does "not recognized" read as *"this feature isn't
      set up yet"* or as *"your photo was bad"*? The second would be
      misleading and is worth filing.

### (i) Removing a bottle
- [ ] Delete on an item raises a **confirmation dialog** — no instant destroy.
- [ ] **Cancel** leaves the item intact.
- [ ] Confirm removes it and the list refreshes to reflect reality.

### (j) "What can I make?" — the payoff surface
- [ ] With only **White Rum** held: Daiquiri is **not** makeable. It should
      appear as a **near-miss** naming what's missing — and the missing
      ingredients should be **Lime Juice and Simple Syrup**, correctly named.
- [ ] Add **Lime Juice** and **Simple Syrup**. Daiquiri now appears under
      **makeable**, with a match-quality label.
- [ ] Hemingway Daiquiri should now be a near-miss (missing Grapefruit Juice
      and Maraschino Liqueur) — near-miss must be computed *after* match
      resolution, so nothing already satisfied is listed as missing.
- [ ] **Judgment call:** is the distinction between "makeable" and "near-miss"
      immediately obvious, and does the match-quality wording mean anything to
      a normal person? These labels are the entire user-facing product of the
      ladder — if they read as jargon, that's a finding.

### (k) The ladder's class-satisfied rung — cross-story test
This is the interesting one: it exercises **US3 authoring feeding US4
matching**, and it's the only way to see `class-satisfied` with this seed
(the single hierarchy edge is Beefeater → London Dry Gin, and no seeded
recipe uses London Dry Gin).
- [ ] In the Library, author a personal recipe with one ingredient line:
      **London Dry Gin**.
- [ ] Add **Beefeater** to your inventory (a *descendant* of London Dry Gin —
      you do **not** hold the class itself).
- [ ] Your recipe appears as **makeable**, graded **class-satisfied** — not
      missing, and not a substitution.
- [ ] Your own **personal** recipe appears in the makeable results at all
      (it's private — this confirms owner-visible matching works).
- [ ] **Judgment call:** does "class-satisfied" communicate *"your Beefeater
      counts as London Dry Gin"* to a normal reader? Same jargon risk as (j).

### (l) Privacy — owner-only from birth
- [ ] Sign out, then hit `/#/inventory` directly: it must **not** show the
      previous account's bottles, and must not blank-crash.
- [ ] Register a **second** account and check inventory: **empty**, with no
      trace of the first account's bottles or its personal recipe.

---

## Cross-cutting (applies to every screen above)

- [ ] **No raw localization keys** rendered anywhere (T157 class).
- [ ] **No raw exception text** rendered anywhere — errors are friendly; an
      unexpected one carries a correlation ID (T170/T172 class).
- [ ] **Error text is selectable/copyable** so you can paste it into a finding
      (T172).
- [ ] Nothing contradicts itself on screen the way Daiquiri's garnish/ice line
      did in Phase 3 (T158) — labels match the values under them.
- [ ] Sensible behavior on a **narrow window** (the app is served to a
      browser; a squished layout is a legitimate finding).

---

## Disposition

Record findings inline (fail an item, add a note) or as a list below. Each one
becomes a filed task in the next batch — please don't fix anything yourself.

**Per John's sequencing: T201 (the facet model story) opens only after this
hold posts.** This walkthrough's findings and T201's scope overlap
deliberately — T201 reworks the very matching surface items (j) and (k)
exercise, so what you find here should inform it.

### Findings

_(none yet — awaiting walkthrough)_
