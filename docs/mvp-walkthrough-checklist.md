# Phase 3 (US1 MVP) — human visual-verification walkthrough

Green test suites don't cover visual judgments (FR-055 allergen *prominence*) or the
feel of the browse→detail→concept flows. This checklist is the human step required
to close the Phase 3 MVP checkpoint — the sandbox has no browser, so this must be
walked through on a real machine with a display.

## Run it

Two processes: the backend stack (docker-compose) and the built Flutter web app.

1. **Backend + seeded content** (from repo root):
   ```
   docker compose up -d --build
   # apply migrations if this is a fresh volume (the migration-runner service does this on up)
   # seed the curated content (Mai Tai, Daiquiri + Hemingway Daiquiri, Whiskey Flip, glossary, equipment):
   ConnectionStrings__Postgres="Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only" \
     ~/.dotnet/dotnet backend/src/Tools/Seeder/bin/Release/net10.0/SpecPour.Tools.Seeder.dll
   ```
   The API is on `http://localhost:5001`. Confirm: `curl http://localhost:5001/health/ready` → 200.

2. **Web app** — serve the prebuilt bundle on any localhost port (CORS dev default
   allows any localhost origin; the app calls `http://localhost:5001/api/v1`):
   ```
   python3 -m http.server 8080 --directory frontend/app/build/web
   ```
   (Rebuild with `flutter build web` if the frontend changed since this build.)
   Open **http://localhost:8080**.

## Verify

### 1. Browse → detail → concept flows (nav)
- [ ] Discover screen loads showing a browse list of recipes (Mai Tai, Daiquiri, Hemingway Daiquiri, Whiskey Flip).
- [ ] Tapping the family facet chips (Sour, Flip, …) filters the list.
- [ ] Typing "Mai Tai" in search + submitting shows the Mai Tai result; tapping it opens the recipe detail.
- [ ] Search results are **typed and grouped** with section headers (Recipes / Ingredients / Equipment / Glossary — amended FR-049). Try searching "shake" or "muddle": glossary terms appear under a Glossary header, distinct from recipe results.
- [ ] **T155 smoke test**: search "rum" — a Recipes header now appears with **Daiquiri**, **Hemingway Daiquiri**, and **Mai Tai** (none of these names contains "rum"; this proves the recipe search document includes ingredient names, not just the recipe's own name), alongside the Aged Rum/White Rum ingredient matches.
- [ ] Recipe detail shows: ingredient lines **with names** (not GUIDs), instructions, garnish, ice, **glassware + equipment by name**, ABV/standard-drinks, creator, history.
- [ ] Back out; open the Daiquiri concept (search "Daiquiri" is a recipe — to reach the concept page navigate to `#/concepts/<id>`; the concept lists **Daiquiri** and **Hemingway Daiquiri** as variants with differentiator text, each tapping through to its full recipe).

### 2. FR-055 — allergen prominence (visual judgment) — VERIFIED by John, 2026-07-12
The Daiquiri has no allergens and proves nothing — use these two (roll-ups confirmed present in seed data via the API, 2026-07-12):
- [X] Open the **Whiskey Flip** (whole egg): the **Egg** allergen banner is **present, prominent, near the top of the detail view** (colored chip above the fold), not buried below the instructions.
- [X] Open the **Mai Tai** (orgeat → tree nuts): the **Tree nut** allergen banner is **present, prominent, near the top of the detail view**.
This prominence judgment is the specific thing tests can't make — confirm both actually *read* as prominent.

### 2a. Walkthrough-defect regressions (fixed 2026-07-12 — verify the fixes)
- [ ] **T157**: Discover browse subtitles show localized family names ("Sour", "Flip"), never raw keys like `family.sour`. Allergen chips likewise show "Egg"/"Tree nut", not `egg`/`treeNut`.
- [ ] **T158**: The Daiquiri detail shows **"Ice: None (served up)"** and **"Garnish: Lime wheel"** as two separate, correctly-labeled lines — no contradiction.

### 3. T150 — responsible-consumption messaging placement (FR-067/FR-069)
- [ ] Every recipe detail page shows a persistent responsible-consumption message banner (below the content) with a **"Support resources"** button.
- [ ] Tapping "Support resources" opens a sheet listing at least one resource.
- [ ] The **About** surface (info icon, top-right of the Discover screen) shows the same responsible-use banner (footer/about placement) + support resources.

### 4. Guest posture (US1 scenario 6)
- [ ] All of the above works with **no sign-in** (guest). No account/sign-in wall blocks browsing or reading.
- [ ] (No gated actions are wired into US1 screens yet — save/rate/etc. arrive with later stories — so there's nothing to trigger the sign-in prompt here. The prompt mechanism itself is unit-tested; T043.)

## Known-deferred (not defects — tracked)
- Glossary terms in recipe text are **not** yet clickable inline links (T152 → Phase 10 / US7).
- SEO pages use ID URLs, not keyword slugs (T153).
- Per-jurisdiction message/support-resource copy and the FR-070 encyclopedia articles
  are launch-content-checklist items (see tasks.md Notes), not built in code.
