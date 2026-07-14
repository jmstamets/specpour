# Feature Specification: SpecPour V1

**Feature Branch**: `001-specpour-v1`

**Created**: 2026-07-10

**Status**: Draft

**Input**: User description: "docs/specification-statement.md — Build a
cross-platform (Android, iOS, web) craft-cocktail application for home enthusiasts and
professional bartenders. Category-leader positioning: every established killer feature
of the cocktail-app market plus the gap-filling capabilities specified, with terminology
and technique conforming to professional craft-cocktail standards."

## Clarifications

### Session 2026-07-10

- Q: Does the V1 default tier's "super-admin-equivalent" capability include curation and
  moderation powers, or are staff roles a separate axis from commercial tiers? → A:
  Resolved by source revision (docs/specification-statement.md §18): tiers,
  platform roles, and venue-scoped roles are three independent concepts. Role grants
  are modeled as (user, role, scope) — scope is the platform (curator/admin staff
  roles) or a specific venue — and roles carry granular permissions (view/edit/delete/
  publish) on library resources. The V1 default tier grants all end-user (home and
  professional) features; curation/moderation requires a platform-scoped staff role.
  V1 uses only the platform scope and single-member venues, but future venue-scoped
  staff access must be pure data on this model — no authorization redesign.
- Q: Can unauthenticated visitors use the app, and to what extent? → A: Resolved by
  source revision (docs/phase2-specification-statement.md §1): Guest (no account) is
  the entitlement floor, modeled in the V1 tier/entitlement map. Guests browse and
  search all public surfaces — curated core library, glossary, equipment, and public
  recipes. All personalized or interactive actions (personal libraries, inventory,
  ratings, tasting log, offline profiles, publishing) require an account.
- Q: What happens to references to the author's private ingredients (e.g., a
  house-made "House Grenadine") when a recipe is published? → A: Cascade with consent:
  the publish flow lists the referenced private ingredients (including a house-made
  ingredient's defining recipe) and asks the author to publish them together or cancel;
  a published recipe never carries private or placeholder ingredient references.
- Q: Do search, faceted filtering, and "what can I make?" work offline, or is offline
  limited to opening synced content? → A: Synced-content intelligence: search, faceted
  filtering, and "what can I make?" (including near-misses and substitutions) work
  offline over whatever content the user's offline profile has synced; inherently
  online features (community browsing, AI features, bottle photo recognition) are
  clearly indicated as unavailable offline.
- Q: How long is a deactivated account retained before deletion? → A: An
  operator-configurable grace period, default 12 months: the user is warned before
  expiry, can reactivate any time within the period, and the account is then
  automatically deleted via the standard deletion flow.
- Q: Does constitution Principle XIII (legal-drinking-age gating) apply to V1's
  community features (browse/copy/rate), given FR-002 ships no age gating? → A:
  Resolved by source revision (specification-statement.md §1): a
  jurisdiction-aware age-affirmation capability ships in V1 — a DOB-entry gate (not a
  checkbox), jurisdiction selected by coarse geolocation, strictest applicable rule
  when uncertain, DOB checked and never stored (client-side "affirmed" flag only).
  Gate strictness is configurable per surface: off or soft for V1's informational
  surfaces (recipes/glossary), mandatory for any surface carrying producer or
  establishment marketing content (later phases). Registered users are gated by their
  account DOB instead. Per-jurisdiction configuration values are set on legal
  counsel's review per launch market; terms of service state the service is intended
  for users of legal drinking age.
- Q: How are expiring-prep warnings (and similar platform-to-user alerts) delivered?
  → A: Through a thin V1 slice of the constitution's notifications module: the in-app
  inbox is the default, always-on channel for prep shelf-life warnings and
  account-lifecycle warnings (e.g., deactivation-expiry); push notifications are
  per-user opt-in. No email digests in V1.
- Q: Can users copy curated core recipes into their own library, or only public user
  recipes? → A: Yes — one uniform copy mechanic: any curated core or public recipe can
  be copied into a personal or bar library, with provenance/attribution to the source
  recorded identically in both cases.
- Q: Can users rate curated core recipes, or only public user recipes? → A: Yes —
  core recipes are rateable exactly like public user recipes: one subject-agnostic
  rating-event model covers all public content, and the rating facet applies across
  the whole catalog. Private tasting-log ratings remain separate.
- Q: Who creates and maintains concept pages? → A: Curator-owned with open linkage:
  curators create and manage concept pages; users may attach their published variant
  recipes to a concept page, subject to curator moderation (consistent with FR-010).
  Private (unpublished) recipes cannot appear on concept pages.
- Q: When a user re-rates the same recipe, does the aggregate count all events or the
  latest per user? → A: Latest-per-user: a new rating event supersedes the user's
  previous one in the projection (all events remain stored, immutable); the aggregate
  is the mean over each user's most recent event, and the UI shows the user's current
  rating as editable.
- Q: Can a recipe owner unpublish their own public recipe? → A: Yes, as a reversible
  toggle: unpublishing returns the recipe to private, its aggregate is no longer
  publicly displayed (rating events are retained), and republishing restores the
  rating history. Existing copies are unaffected — and the publish flow MUST make
  the author aware, before they first publish, that copies made while public survive
  later unpublishing or deletion.
- Q: How many venues can one professional user own in V1? → A: Any number — a
  professional user can create and own multiple venues, each with its own bar library,
  with a venue switcher in the UI. V1 venues remain single-user containers.
- Q: Are user-added equipment entries private, publishable, or shared? → A: Same
  model as user ingredients: private to the user's library by default; when a recipe
  being published requires the author's private equipment, the FR-008a consent
  cascade co-publishes it. No standalone equipment publishing in V1.
- Q: Is the offline profile a per-device or per-account setting? → A: Hybrid: the
  offline profile (fidelity tier + storage budget) is chosen per device; pinned
  collections are per account and honored on every device at that device's profile
  fidelity or better.
- Q: The spec used "admins" only in the venue-owner sense — what about platform/system
  administration (curation, account maintenance, billing)? → A: Resolved by source
  revision (specification-statement.md §19, constitution v1.2.0): platform
  administration is a first-class V1 feature set on the (user, role, scope) model —
  a configuration-data role catalog (Super Admin, Curator, Moderator, Support; Billing
  Admin defined but dormant until paid tiers), administrative capabilities (tier
  configuration, role grants, curation console, moderation queue, account
  administration, audit-log review), deployment-time Super Admin bootstrap with
  break-glass recovery, mandatory MFA for platform-scoped roles, append-only audit of
  every administrative action, and a justified web-only staff surface. See User
  Story 16 and FR-061–FR-066.
- Q: Stored DOB was flowing into the database like ordinary profile data — what
  handling does it require? → A: Resolved by source revision
  (specification-statement.md §1, constitution v1.3.0): DOB is sensitive PII,
  purpose-bound to age verification and legal compliance. The identity capability
  exclusively owns the stored value and exposes only derived predicates (e.g.,
  of-legal-drinking-age for a jurisdiction) to all other features, APIs, staff views
  (verified status, never the DOB), analytics (age bands at most), logs, and exports —
  the raw value appears only in the owner's own data export. Stored with
  application/column-level encryption beyond disk encryption; access audit-logged;
  deleted with the account. Underage registration attempts are rejected without
  persisting the entered DOB or any identifying record of the attempt (COPPA-relevant
  under 13); retry-gaming is resisted with client-side flagging and rate limiting, not
  server-side storage. See FR-002b/FR-002c.
- Q: (/speckit-analyze C1) Constitution XIII requires responsible-consumption
  messaging as a product requirement — the spec had none. → A: Resolved by source
  revision (specification-statement.md §20, four-part package) as FR-067–FR-070:
  (1) persistent messaging on recipe pages, batch/scaling outputs, and app
  footer/about, jurisdiction-configurable text and placement; (2) quantified
  transparency — per-serving ABV/standard drinks designated to the principle, batch
  output showing total standard drinks and per-serving strength; (3) jurisdiction-
  aware support resources reachable from the messaging and settings/about;
  (4) responsible-service/consumption encyclopedia content required at launch.
  ToS-only is explicitly insufficient. Constitution v1.4.0 additionally forbids
  volume-rewarding gamification and additional-drink prompts (governs Phase 2's
  engagement layer; V1 notifications already comply).
- Q: (/speckit-analyze G2) Notification channel adapters were stubs, blocking US2
  recovery email and US10 push. → A: Split: a real email adapter is required before
  US2 (dev SMTP mail-catcher locally, production provider config-selected per the
  adapter rule); push delivery is deferred to Phase 2 (FR-040a amended; prep-expiry
  alerts served by inbox + email opt-in), per the Long-Horizon Rule applied in the
  deferring direction.
- Q: (/speckit-analyze A1) SC-012 "10,000 concurrent users without functional
  degradation" had no measurable pass criteria. → A: Ratified thresholds: 10,000
  concurrent sessions sustained 30 minutes at ~80/15/5 read/search/write mix; p95
  ≤ 300 ms reads, ≤ 500 ms search, ≤ 600 ms writes; error rate < 0.1%; no degradation
  trend; AI endpoints excluded and measured separately with graceful degradation
  asserted.

## User Scenarios & Testing _(mandatory)_

### User Story 1 - Discover and Follow Curated Recipes (Priority: P1)

A home enthusiast or professional bartender opens the app, searches or browses the
curated core library, and views a complete recipe: ingredients with quantities in their
preferred units, step-by-step instructions, garnish, glassware, ice, required equipment,
flavor profile, calculated ABV/standard drinks, prominent allergen flags, history, and
related cocktails. Concept pages (e.g., "Daiquiri") list linked variant recipes with
short differentiators and route to each full recipe.

**Why this priority**: The curated reference library is the product's core value and the
minimum thing a user must be able to do. Every other feature builds on recipes existing
and being findable. This is the MVP.

**Independent Test**: Seed curated content, then search for a canonical cocktail by
primary or alternate name, open it, and verify every content field, derived ABV,
allergen roll-up, and variant navigation render correctly — with no account features,
inventory, or community features present.

**Acceptance Scenarios**:

1. **Given** the curated library contains the Mai Tai, **When** a user searches
   "Mai Tai" (or an alternate name), **Then** the recipe appears in results and opens to
   show ordered ingredient lines, instructions, garnish, glassware, ice spec, equipment,
   flavor profile, creator (Trader Vic), history, and photos.
2. **Given** a recipe containing egg white, **When** a user views it, **Then** an egg
   allergen flag is prominently displayed, rolled up automatically from the ingredient.
3. **Given** the "Daiquiri" concept page with linked variants, **When** a user opens it,
   **Then** each variant lists a short differentiator and routes to its full recipe.
4. **Given** any recipe, **When** a user views it, **Then** calculated ABV and standard
   drinks per serving are shown, accounting for the preparation method's dilution
   assumptions.
5. **Given** faceted filters (family, category, tags, flavor profile, glassware, ice,
   equipment, allergen-exclude, ABV range, rating, source), **When** a user applies any
   combination, **Then** only matching recipes are returned.
6. **Given** an unauthenticated (guest) visitor, **When** they browse or search the
   curated library, glossary, equipment, or public recipes, **Then** all reading and
   reference workflows function without an account; **When** they attempt any
   personalized or interactive action, **Then** they are prompted to register or sign
   in, and the original action completes after signup (no lost intent).
7. **Given** a surface configured to require age affirmation, **When** an
   unauthenticated visitor first arrives, **Then** a jurisdiction-aware
   date-of-birth-entry gate is presented (strictest applicable rule when jurisdiction
   is uncertain — including when the jurisdiction lookup fails or the device is
   offline), the entered DOB is checked and never stored (it appears in no network
   request payload, and nothing DOB-derived exists outside local storage), and only a
   client-side "affirmed" flag persists; registered users are gated by their account
   DOB instead.
8. **Given** a recipe page, batch/scaling output, or the app footer/about surface,
   **When** it renders, **Then** the persistent responsible-consumption message is
   present per the jurisdiction-configured content and placement (FR-067), and
   jurisdiction-aware support resources are reachable from the message and from
   settings/about (FR-069).

---

### User Story 2 - Create an Account and Manage Identity (Priority: P1)

A new user registers with email/password or social sign-in, provides their date of birth,
and can later enable multi-factor authentication, recover access, manage active
sessions/devices, and exercise full account lifecycle rights (deactivate, export data,
delete).

**Why this priority**: Accounts are a first-class V1 feature and the prerequisite for
every personalized capability (personal library, inventory, ratings, offline profile).
Identity is sized for the platform's future, not V1's modest needs.

**Independent Test**: Register, sign out, sign back in via each supported method, run
recovery, enable/disable MFA, list and revoke a session, export data, and delete the
account — all without any other feature present.

**Acceptance Scenarios**:

1. **Given** a visitor, **When** they register with email/password, **Then** the account
   is created with modern credential handling and date of birth is captured and stored
   encrypted, owned exclusively by the identity capability.
2. **Given** a visitor whose entered DOB is under the applicable legal drinking age,
   **When** they attempt registration, **Then** the attempt is rejected and neither
   the DOB nor any identifying record of the attempt is persisted; repeated attempts
   are limited client-side and by rate limiting.
3. **Given** a registered user, **When** they sign in from a second device, **Then**
   both sessions appear in device/session management and either can be revoked.
4. **Given** a user who lost their credentials, **When** they complete secure recovery,
   **Then** they regain access without support intervention.
5. **Given** a user who requests deletion, **When** the request completes, **Then**
   their personal data — including the stored DOB — is deleted and they can export
   their data beforehand (the export is the only surface where their raw DOB appears).
6. **Given** a user who requests deletion, **When** the request completes, **Then**
   their public data, such as ratings and attribution, is anonymized.
7. **Given** V1's single default tier, **When** any user is created, **Then** they
   receive the default tier granting all end-user (home and professional) features via
   configuration — and no curation or moderation powers, which require a
   platform-scoped staff role.
8. **Given** any feature, staff view, log, trace, or analytics event outside the
   identity capability, **When** it needs age information, **Then** it receives only a
   derived predicate (or age band for analytics) — never the raw DOB — and each access
   to the stored value is audit-logged.
9. **Given** a user with MFA enabled who resets their password via account recovery,
   **When** they sign in with the new password, **Then** they are still required to
   complete the MFA challenge — password recovery never bypasses an enabled MFA gate.
10. **Given** a user who has lost their MFA factor (e.g., a replaced phone), **When**
    they use a self-service recovery path (e.g., a backup code generated at
    enrollment), **Then** they regain access without permanent lockout and without
    requiring support intervention for this common case; a staff-assisted, audited
    reset remains available when self-service recovery is also unavailable.

---

### User Story 3 - Author a Personal Library (Priority: P2)

A user creates and manages private recipes and ingredients in their personal library —
including house-made ingredients (syrups, infusions, cordials, shrubs, tinctures)
defined by their own recipe with yield, shelf life, and storage instructions. A
professional user creates a venue and builds a bar library scoped to it.

**Why this priority**: Authoring is the primary creation loop and the foundation for
publishing, inventory of house-made items, prep, and costing. It depends only on
accounts and the curated content model.

**Independent Test**: Create a private recipe referencing curated and personal
ingredients at any hierarchy level, create a house-made ingredient with its own recipe,
use it in a cocktail recipe, and verify both remain private; create a venue and add a
recipe to its bar library.

**Acceptance Scenarios**:

1. **Given** a signed-in user, **When** they create a recipe with a primary name,
   alternate names, ingredient lines (with quantity, unit, purpose/role, scaling rule),
   instructions, and taxonomy, **Then** it is saved privately and searchable only by
   them under "my library."
2. **Given** a user creating "House Grenadine" as a house-made ingredient, **When**
   they define its component recipe, yield, shelf life, and storage instructions,
   **Then** it behaves as an ingredient everywhere: usable in recipe lines, inventory,
   prep lists, and cost roll-ups.
3. **Given** a professional user, **When** they create a venue (with name, address,
   coordinates, external references), **Then** they can maintain a bar library scoped
   to that venue, structurally identical to a personal library.
4. **Given** a private recipe, **When** any other user searches or browses, **Then**
   the recipe never appears for them.

---

### User Story 4 - Track Inventory and Ask "What Can I Make?" (Priority: P2)

A user records the bottles and ingredients they own — at product level ("Beefeater") or
class level ("a London dry gin") — by photographing a label, scanning a barcode, or
manual entry, then filters recipes to what is fully makeable from inventory, including
near-misses ("one ingredient away") with substitution suggestions.

**Why this priority**: "What can I make?" is an established killer feature of the
category and a top driver of daily engagement. It depends on the ingredient hierarchy
and recipes, not on community or pro features.

**Independent Test**: Build an inventory via all three entry paths, then verify the
makeable list honors the hierarchy (a specific gin satisfies "London dry gin"),
curated substitutions, and near-miss surfacing with missing items identified.

**Acceptance Scenarios**:

1. **Given** a user photographs a recognizable bottle label, **When** recognition
   succeeds, **Then** the product is added at the correct hierarchy level; **When**
   recognition fails, **Then** a pre-filled manual form is offered (barcode scan and
   manual entry always available).
2. **Given** an inventory containing "Beefeater," **When** the user runs "what can I
   make?", **Then** recipes calling for "London dry gin" or "gin" count as satisfied
   via the hierarchy.
3. **Given** a recipe one ingredient short of makeable, **When** the user views
   near-misses, **Then** the missing ingredient is identified and acceptable
   substitutions (curated or hierarchy-implied, with suitability notes) are offered.
4. **Given** optional quantity/bottle-size tracking is enabled, **When** the user views
   an inventory item, **Then** remaining quantity is shown.

---

### User Story 5 - Scale, Batch, and Cost Recipes (Priority: P2)

A user scales any recipe to N servings with per-ingredient scaling rules (linear,
stepwise/rounded, omit-in-batch, add-fresh-at-service), produces dilution-aware batch
calculations (pre-diluted vs. not, target ABV, keg/bottle service guidance, container
yields), and — with pricing data — sees per-drink cost, pour-cost percentage, and
suggested menu pricing.

**Why this priority**: Measurement intelligence is the platform's key professional
differentiator and feeds shopping, prep, and menus. It requires only recipes and units.

**Independent Test**: Scale a recipe containing citrus (omit-in-batch) and egg white
(add-fresh-at-service) to 20 servings; verify the batched portion and at-service
additions are separated, dilution math matches documented conventions, and pour cost
computes from bottle price data including a house-made ingredient's rolled-up cost.

**Acceptance Scenarios**:

1. **Given** any recipe, **When** the user changes unit preference (oz/ml/cl), **Then**
   all quantities re-render from canonical storage with documented conversions,
   including counts (dashes, barspoons).
2. **Given** a Daiquiri scaled to 20 servings pre-diluted, **When** batch output is
   generated, **Then** added water reflects the shake-method target dilution, fresh
   lime is listed as at-service, yield is expressed in the user's chosen container
   size, and total standard drinks (batch and per container) plus per-serving strength
   are shown.
3. **Given** bottle sizes and prices for a recipe's ingredients, **When** the user
   views costing, **Then** per-drink cost, per-ingredient breakdown, pour-cost % against
   a menu price, and suggested price for a target pour-cost % are shown.
4. **Given** a batch result, **When** the user saves it, **Then** it can be sent to a
   prep list and printed/exported.

---

### User Story 6 - Publish, Copy, and Rate Community Recipes (Priority: P3)

A user optionally makes a creation public. Other users browse public recipes, copy them
into their own library (with provenance/attribution recorded), and rate them 1–5 stars.
Aggregates displayed on public content are derived from individual per-user rating
events. Curators can moderate (unpublish, flag) public content.

**Why this priority**: Community view/copy/rank drives content network effects but is
meaningless before authoring (US3) and discovery (US1) exist. Comment threads are
explicitly out of scope for V1.

**Independent Test**: Publish a recipe from one account, find/copy/rate it from a
second account, verify attribution on the copy, verify the aggregate updates and is
recomputable from stored events, and verify a curator can unpublish it.

**Acceptance Scenarios**:

1. **Given** a private recipe, **When** its owner publishes it, **Then** it becomes
   browsable by all users and displays an aggregate rating once rated.
2. **Given** a private recipe referencing the author's private house-made ingredient,
   **When** the owner publishes it, **Then** the flow lists the private ingredient
   (and its defining recipe) for co-publication and the author must consent or cancel
   — the published recipe is never visible with unresolvable ingredient references.
3. **Given** a public recipe, **When** another user copies it, **Then** the copy lands
   in their library with provenance/attribution to the original recorded.
4. **Given** a user rates a public recipe, **Then** a rating event (who, what, value,
   when, context) is stored; the displayed aggregate is a derived, recomputable
   projection — never the stored truth.
5. **Given** a flagged public recipe, **When** a curator unpublishes it, **Then** it is
   no longer publicly visible, while copies already made remain in their owners'
   libraries.

---

### User Story 7 - Consult the Glossary and Encyclopedia (Priority: P3)

A user encounters an unfamiliar term (e.g., "orgeat," "agricole," "Hawthorne strainer")
anywhere in the app, taps the automatically created link, reads the single glossary
entry (with numbered definitions when a term has multiple meanings) or a longer-form
article, and returns to exactly where they left off. Glossary tags surface related
recipes, ingredients, and equipment.

**Why this priority**: The knowledge base is a core content pillar and a duty-of-care
support for professional terminology, but reading flows work without it.

**Independent Test**: Publish a glossary term and an article; verify the first
occurrence of the term in a recipe body auto-links (no manual linking anywhere),
navigation returns to the departure point, curator overrides can suppress/force links,
and "recipes using Agricole" surfaces from the entry's tags.

**Acceptance Scenarios**:

1. **Given** "punch" has two meanings, **When** a user opens the glossary entry,
   **Then** one entry shows both numbered definitions (never two entries).
2. **Given** a recipe description mentioning "orgeat," **When** the page renders,
   **Then** the first occurrence links to the glossary entry and return navigation
   restores the reader's exact position.
3. **Given** a false-positive auto-link, **When** a curator suppresses it, **Then** the
   link no longer appears; curators can equally force a missed link.
4. **Given** an article on rhum agricole, **When** a user reads it, **Then** in-text
   references link to definitions, recipes, ingredients, and equipment.

---

### User Story 8 - Reference and Manage Equipment (Priority: P3)

A user browses curated bar equipment (strainers, shakers, mixing glasses, jiggers,
glassware, etc.) with photos, descriptions, how-to-use guidance, and typical
applications, adds their own entries, and navigates bidirectionally between equipment,
the recipes that require it, and related glossary articles.

**Why this priority**: Equipment completes the reference triad (recipes, ingredients,
equipment) and feeds recipe requirements, but is lower-traffic than recipes.

**Independent Test**: View a curated equipment entry, create a user-added entry, and
verify links to requiring recipes and glossary articles work in both directions.

**Acceptance Scenarios**:

1. **Given** the curated equipment library, **When** a user opens "Hawthorne strainer,"
   **Then** name, category, cost, photo, description, usage guidance, and typical
   applications display, with links to recipes requiring it and related articles.
2. **Given** a recipe requiring a fine-mesh strainer, **When** a user views the recipe,
   **Then** the equipment requirement links to the equipment entry and back.

---

### User Story 9 - Generate Shopping Intelligence (Priority: P3)

A user generates a shopping list from selected recipes, a menu/event (guest count
driving quantities via batching math), or a prep list — and sees leverage-ranked
purchase recommendations: "buying these 2 bottles unlocks 14 more recipes."

**Why this priority**: Shopping closes the loop between inventory, recipes, and
purchasing and is a strong differentiator, but depends on inventory (US4) and batching
(US5).

**Independent Test**: With a known inventory, generate lists from each of the three
sources and verify quantities; verify unlock analysis correctly counts newly makeable
recipes honoring hierarchy and substitutions; export/share a list.

**Acceptance Scenarios**:

1. **Given** a menu and a guest count, **When** a shopping list is generated, **Then**
   quantities derive from batch math for the expected servings.
2. **Given** current inventory, **When** the user views unlock analysis, **Then**
   recommendations are ranked by recipes unlocked per purchase, computed against
   hierarchy and substitution rules.
3. **Given** any shopping list, **When** the user exports or shares it, **Then** a
   usable copy leaves the app (V1 posture; retailer hand-offs and API ordering are
   future phases the design must not preclude).

---

### User Story 10 - Manage Prep and Shelf Life (Pro) (Priority: P3)

A professional builds prep lists for house-made ingredients, juices, and batches —
what to make and how much (yield math) as assignment-ready checklists — records made-on
dates, and is warned about expiring or expired preps ("your grenadine expires
Thursday"), with prep availability reflected in inventory and makeability.

**Why this priority**: Prep management is a pro killer feature but depends on
house-made ingredients (US3), batching (US5), and inventory (US4).

**Independent Test**: Send a batch and a house-made ingredient to a prep list, complete
prep with a made-on date, verify shelf-life warnings appear at the right time and that
the prepared item counts toward "what can I make?" until expiry.

**Acceptance Scenarios**:

1. **Given** a prep list containing House Grenadine (shelf life 14 days), **When** prep
   is completed on the 1st, **Then** the app surfaces it as expiring before the 15th
   and as expired after — with an expiry warning delivered to the user's in-app inbox
   (and via email if the user opted in; push delivery is deferred to Phase 2),
   alongside in-place indicators.
2. **Given** an expired prep, **When** the user runs "what can I make?", **Then**
   recipes depending on it are no longer counted as makeable from that prep.
3. **Given** a prep list, **When** viewed, **Then** items show required quantities from
   yield math and can be checked off as completed.

---

### User Story 11 - Build Collections, Menus, and Print/Export (Priority: P3)

A user curates recipe collections ("Tiki night"; a pro's working list). A professional
promotes a collection to a menu with per-item pricing (costing-aware), descriptions, and
ordering, then prints or exports recipe cards, spec sheets, menus, prep lists, and
shopping lists in layouts appropriate to each artifact.

**Why this priority**: Collections organize the libraries users have already built;
menus and print/export deliver pro workflow value on top of costing (US5).

**Independent Test**: Create a collection, promote it to a priced menu, and produce a
print/export artifact of each type, verifying layout fitness (spec-sheet format for
staff vs. styled menu for guests) via the platform's native print pipeline.

**Acceptance Scenarios**:

1. **Given** a collection of 8 recipes, **When** promoted to a menu, **Then** each item
   carries price, description, and display order, with pour-cost guidance available
   from costing data.
2. **Given** any printable artifact (recipe card single/batch, spec sheet, menu, prep
   list, shopping list), **When** the user prints or exports, **Then** output uses a
   layout appropriate to that artifact and the platform's native print pipeline or
   document export (no direct printer-driver integration).

---

### User Story 12 - Use AI-Assisted Features (Priority: P4)

A user converses with a chat assistant grounded in platform content, reads contextual
insight blocks (recipe background, variant comparisons on concept pages), gets
authoring assistance for glossary entries and articles (human review before publish),
and receives "if you like X, try Y" recommendations. Every AI feature is individually
toggleable, labeled as AI-generated, and degrades gracefully to a deterministic
fallback or clean absence.

**Why this priority**: AI features enrich every pillar but must never be load-bearing:
by principle they degrade gracefully, so all other stories function with AI off.

**Independent Test**: With AI enabled, exercise chat, insight blocks, authoring assist,
and discovery; then disable AI globally and per-feature and verify zero broken UI —
discovery falls back to deterministic similarity; other features hide cleanly.

**Acceptance Scenarios**:

1. **Given** AI is enabled, **When** a user asks the chat assistant a substitution
   question, **Then** the answer is grounded in platform content and labeled as
   AI-generated.
2. **Given** AI is disabled by the user, operator, or an outage, **When** any surface
   that hosts AI content renders, **Then** the feature falls back deterministically or
   disappears cleanly — never a broken UI.
3. **Given** the discovery feature with AI off, **When** a user views "if you like X,
   try Y," **Then** recommendations come from deterministic similarity (flavor
   profiles, families, shared ingredients, tasting log).
4. **Given** a curator drafting an article with authoring assist, **When** the draft is
   generated, **Then** it requires human review before publish.

---

### User Story 13 - Keep a Personal Tasting Log (Priority: P4)

A user records "made it" history with dates, personal ratings and notes per recipe
(distinct from public ratings), and variations tried — private by default — and this
log feeds discovery recommendations.

**Why this priority**: The tasting log deepens personalization and improves discovery
but is additive to core flows.

**Independent Test**: Log a made-it entry with note and personal rating, verify it is
private, distinct from any public rating by the same user on the same recipe, and
visible in the user's history.

**Acceptance Scenarios**:

1. **Given** a user made a Negroni tonight, **When** they log it with a note and
   personal rating, **Then** the entry stores date, rating, note, and variation, and is
   private by default.
2. **Given** a user who both publicly rated and privately logged a recipe, **When**
   either value changes, **Then** the other is unaffected.

---

### User Story 14 - Work Hands-Free in Bar Mode (Priority: P4)

Behind the bar with wet hands, a user opens any recipe (or a prep list) in a
high-contrast, large-type, one-step-at-a-time view with oversized touch targets,
optional voice advance ("next"), and a screen that stays awake.

**Why this priority**: Bar mode is an operational differentiator for pros and
accessibility-aligned, but it presents existing content rather than creating new
capability.

**Independent Test**: Enter bar mode on a recipe, step through via touch and voice,
verify the screen does not sleep, and repeat for a prep list.

**Acceptance Scenarios**:

1. **Given** any recipe, **When** bar mode is opened, **Then** steps display one at a
   time in high-contrast large type with oversized controls and the screen stays awake.
2. **Given** voice advance is enabled, **When** the user says "next," **Then** the view
   advances to the next step.

---

### User Story 15 - Configure Offline Access (Priority: P4)

A user chooses an offline profile (none / recipes-text / + glossary / + key photos /
full media within a storage budget), pins specific collections for guaranteed offline
availability, sees clear storage-usage reporting, and syncs on reconnect — with a
prompt to resolve conflicting edits to their own content.

**Why this priority**: Offline is architecturally foundational (constitution) but as a
user-facing feature it layers on content that must exist first; it is user-optional
because full offline content is storage-heavy.

**Independent Test**: Select each profile tier, verify the promised content class opens
with connectivity disabled, verify storage reporting, edit the same user-authored
recipe on two devices offline, and verify a merge-or-prompt resolution on reconnect
(never silent last-writer-wins for user-authored content).

**Acceptance Scenarios**:

1. **Given** the "recipes-text" profile is synced, **When** the device is in airplane
   mode, **Then** any synced recipe's text opens and reference workflows function —
   including search, faceted filtering, and "what can I make?" over the synced content,
   while online-only features (community browsing, AI, bottle recognition) are clearly
   marked unavailable.
2. **Given** a collection pinned on the account, **When** any of the user's devices is
   offline, **Then** every recipe in it is available on that device at the device's
   profile fidelity or better, regardless of the device's general profile tier.
3. **Given** the same user-authored recipe edited offline on two devices, **When** both
   reconnect, **Then** the user is prompted to merge or choose — the edit is never
   silently discarded.
4. **Given** any profile change, **When** applied, **Then** storage used is reported
   clearly before and after.

---

### User Story 16 - Administer the Platform (Staff) (Priority: P2)

A platform staff member — Super Admin, Curator, Moderator, or Support — signs in with
mandatory MFA and works the operator side: configuring tiers and capability maps,
granting/revoking roles (platform-scope grants require Super Admin approval), curating
the core library through a curation console, working the public-content moderation
queue, administering accounts (suspend/reinstate, fulfill export/deletion requests),
and reviewing the append-only audit log. Staff features are web-only.

**Why this priority**: The curation console is the prerequisite for the launch-content
workstream (SC-013), and moderation/account administration are the operational
counterpart of the community and identity features — the platform cannot operate
without its operator side. It depends only on identity and the authorization model.

**Independent Test**: Provision the first Super Admin via deployment seeding (verify no
signup path can yield a platform role), grant a Curator role with Super Admin approval,
exercise each console (curation, moderation, account administration, tier
configuration), and verify every action lands in the append-only audit log with actor,
action, target, timestamp, and before/after state.

**Acceptance Scenarios**:

1. **Given** a fresh deployment, **When** the environment-configured bootstrap runs,
   **Then** the first Super Admin exists without any public signup involvement — and
   no registration path can ever produce a platform-scoped role.
2. **Given** a user holding any platform-scoped role, **When** they sign in, **Then**
   MFA is required (not optional), and staff capabilities appear only on the web
   client.
3. **Given** a Super Admin granting Curator to a staff account, **When** the grant
   completes, **Then** the grantee can edit curated core content but cannot moderate,
   administer accounts, or change tiers (least privilege), and the grant is
   audit-logged.
4. **Given** a Support staff member assisting a user, **When** they suspend and later
   reinstate the account or fulfill an export/deletion request, **Then** each action
   is recorded in the append-only audit log with actor, action, target, timestamp, and
   before/after state.
5. **Given** a new role or permission-set change is needed, **When** an operator edits
   the role catalog configuration, **Then** the change takes effect without a code
   release.
6. **Given** all Super Admin access is lost, **When** the documented break-glass
   procedure is executed, **Then** access is recoverable through deployment-level
   action only.

---

### Edge Cases

- Bottle-label recognition fails, is ambiguous, or matches multiple products → degrade
  to a pre-filled manual form; never block inventory entry.
- A recipe references an ingredient at a hierarchy level the user's inventory satisfies
  only via substitution with a suitability caveat ("acceptable in stirred drinks") →
  surface the caveat, don't silently count as makeable-equivalent.
- Allergen information for an ingredient is uncertain → flag conservatively (flag when
  uncertain) with the disclaimer, per duty-of-care.
- A published recipe is copied, then the original is unpublished (by owner or curator),
  deleted, or edited → copies are unaffected snapshots; provenance still records the
  original. The author is warned of this at first publish.
- A user deletes their account after publishing recipes and rating others' content →
  personal data is removed while the community record remains coherent (e.g.,
  attribution anonymized, rating events retained in de-identified form).
- Scaling a one-drink recipe to hundreds of servings → stepwise/rounded rules and
  container-size yields keep quantities practical; at-service items scale by count.
- Unit conversion of non-volumetric counts (dashes, barspoons) at large batch scale →
  documented conventions apply and are shown.
- A house-made ingredient's component recipe changes after batches were prepped →
  existing preps keep their recorded composition and cost; future preps use the new
  definition.
- Circular references (house-made ingredient whose recipe transitively includes
  itself) → rejected at save with a clear message.
- Offline storage budget exceeded mid-sync → sync stops at the budget, reports what was
  and wasn't synced, and offers profile adjustment.
- Two meanings collide in auto-linking (term appears inside a longer term) → longest
  match wins; curator override available.
- AI provider outage mid-conversation → chat degrades cleanly with an explanatory
  message; no other surface breaks.
- What-can-I-make with an empty inventory → returns zero-ingredient recipes (if any)
  and treats near-miss thresholds sensibly rather than listing everything.
- A venue's single professional user later needs staff accounts → V1 data model (venue
  as entity with identity fields) must not preclude it; no V1 behavior required.
- An underage visitor retries registration with adjusted birthdates → resisted with
  client-side flagging and anonymous-traffic rate limiting; the failed DOBs are never
  stored server-side (FR-002c).

## Requirements _(mandatory)_

### Functional Requirements

#### Identity, Accounts, and Tiers

- **FR-001**: System MUST support email/password registration with modern credential
  handling, social sign-in via established external identity providers, optional
  multi-factor authentication, secure account recovery, and session/device management.
- **FR-001a**: Password recovery MUST NOT bypass an enabled MFA gate — a user who
  resets their password via account recovery still MUST complete the MFA challenge
  to sign in, the same as any other sign-in method. Loss of the MFA factor itself
  MUST NOT result in permanent account lockout: the system MUST provide a
  self-service recovery path (e.g., one-time backup codes issued at enrollment) not
  contingent on possessing the lost factor, escalating to a staff-assisted,
  audit-logged reset (FR-065) when self-service recovery is also unavailable.
- **FR-002**: System MUST capture and store date of birth at registration; V1 enforces
  no mandatory age gating on its informational surfaces (per-surface configuration per
  FR-002a), but the data must exist for future age-gated features without
  re-collection.
- **FR-002a**: The platform MUST ship a jurisdiction-aware age-affirmation capability:
  a date-of-birth-entry gate (not a yes/no checkbox) for unauthenticated access, with
  the applicable legal drinking age selected by coarse geolocation and defaulting to
  the strictest applicable rule when jurisdiction is uncertain. The entered DOB is
  checked and never stored — only a client-side "affirmed" flag persists. Gate
  strictness MUST be configurable per surface (off or soft for V1's informational
  surfaces; mandatory for any future surface carrying producer or establishment
  marketing content). Registered users are gated by their account DOB instead.
  Per-jurisdiction configuration values are set on legal counsel's review per launch
  market; terms of service state the service is intended for users of legal drinking
  age.
- **FR-002b**: Stored DOB MUST be handled as sensitive PII, purpose-bound to age
  verification and legal compliance (any new use requires updated disclosure/consent).
  The identity capability exclusively owns the stored DOB and exposes only derived
  predicates (e.g., of-legal-drinking-age for a given jurisdiction) to all other
  features, APIs, and analytics. The raw value MUST NOT appear in API responses
  (except the owner's data export), logs, traces, analytics events, staff/admin views
  (staff see verified status, not DOB), or BI exports; where analytics need age at
  all, age bands only. Stored with application/column-level encryption beyond disk
  encryption; access is audit-logged; deleted with the account.
- **FR-002c**: Underage registration attempts MUST be rejected without persisting the
  entered DOB or any identifying record of the attempt (a minor's data must not be
  retained — COPPA-relevant when under 13). Retry-gaming MUST be resisted with
  client-side flagging and rate limiting, never server-side storage of the failed DOB.
- **FR-003**: System MUST provide full account lifecycle: deactivation, data export, and
  deletion. Deactivated accounts are retained for an operator-configurable grace
  period (default 12 months) during which the user can reactivate; the user is warned
  before expiry, and on expiry the account is automatically deleted via the standard
  deletion flow.
- **FR-004**: Every feature MUST be declared against a configuration-driven
  capability/entitlement map; V1 ships a single default tier granting all end-user
  (home and professional) features, and new tiers MUST be introducible purely by
  configuration, without feature-code change.
- **FR-004a**: Authorization MUST follow a scope-aware model: role grants are
  (user, role, scope), where scope is the platform (curator/admin staff roles) or a
  specific venue, and roles carry granular permissions (e.g., view/edit/delete/publish)
  on library resources. Tiers, platform roles, and venue-scoped roles are three
  independent concepts: tiers are commercial entitlements, platform roles are staff
  trust, venue roles are per-establishment access. V1 uses only the platform scope and
  single-member venues, but future venue-owner staff grants (e.g., all bartenders view
  the bar's specs; only designated members edit or delete) MUST be achievable as pure
  data — no authorization redesign.
- **FR-004b**: Unauthenticated (guest) access MUST be modeled as the floor of the
  tier/entitlement map (a configurable pseudo-tier below all account tiers): guests
  can browse and full-text search all public surfaces (curated core library, glossary,
  equipment, public recipes with their aggregate ratings); everything that writes or
  personalizes (personal/bar libraries, copying, rating, inventory, shopping lists,
  tasting log, offline profiles, AI chat, publishing) requires an account. When a
  guest attempts an account-gated action, the app prompts registration/sign-in and
  completes the original action after signup (no lost intent). Public content on the
  web surface is crawlable/shareable, with rate limiting on anonymous traffic.

#### Content Model, Libraries, and Community

- **FR-005**: System MUST maintain a curated core library (recipes, ingredients,
  equipment, glossary) editable only by holders of platform-scoped curator/admin roles
  (per FR-004a), never by tier entitlement alone.
- **FR-006**: Users MUST be able to create private recipes and ingredients in a personal
  library; private content MUST never be visible to other users.
- **FR-007**: Professional users MUST be able to create any number of venue entities
  (name, address, coordinates, external references), each with its own bar library
  scoped to it, structurally identical to a personal library; the UI provides a venue
  switcher. V1 venues are single-user containers.
- **FR-008**: Users MUST be able to publish their creations; public recipes MUST be
  browsable by all users, copyable into a user's own library with provenance and
  attribution to the original recorded, and ratable. The same copy-with-provenance
  mechanic MUST apply to curated core recipes: any core or public recipe can be copied
  into a personal or bar library as a starting point for the user's own version.
- **FR-008a**: Publishing a recipe that references the author's private ingredients or
  private equipment MUST cascade with consent: the publish flow lists every referenced
  private item (including a house-made ingredient's defining recipe) and requires the
  author to publish them together or cancel. A published recipe MUST NOT carry private
  or placeholder ingredient references — its ingredient definitions, allergen roll-ups,
  and cost roll-ups must be fully resolvable by any viewer.
- **FR-008b**: Owners MUST be able to unpublish their own public recipe at any time as
  a reversible toggle: the recipe returns to private, its aggregate rating is no
  longer publicly displayed (rating events are retained, per FR-009 immutability), and
  republishing restores the rating history. Existing copies are unaffected. The
  publish flow MUST inform the author, before first publication, that copies made
  while the recipe is public survive later unpublishing or deletion.
- **FR-009**: Ratings MUST be stored as individual, immutable per-user rating events
  (who, what, value, when, context); all displayed aggregates MUST be derived,
  recomputable projections. Storing only computed aggregates is prohibited. The rating
  subject space is all public content — curated core recipes and public user recipes
  alike — under one subject-agnostic event model (future phases add further subject
  types by data, not remodeling). Re-rating appends a new event that supersedes the
  user's previous one in the projection: the displayed aggregate is the mean over each
  user's most recent event (one-person-one-vote), and users see and can revise their
  current rating.
- **FR-010**: Curators MUST be able to moderate public content (unpublish, flag).
  Commenting threads are out of scope for V1; the data model MUST NOT preclude adding
  them later.

#### Ingredients

- **FR-011**: System MUST provide full create/read/update/delete for ingredients with
  name, category, source(s), description, and photo(s).
- **FR-012**: Ingredients MUST form a classification hierarchy from broad class to
  specific product (e.g., Spirit → Rum → Rhum Agricole → specific bottling); recipes
  MUST be able to reference any level, and inventory MUST be able to hold any level.
- **FR-013**: System MUST support curated substitution relationships with suitability
  notes, plus hierarchy-implied substitution (any descendant satisfies an ancestor
  requirement); substitution suggestions MUST appear wherever an ingredient gap blocks
  a recipe.
- **FR-014**: Ingredient categories (spirit, liqueur, fortified wine, mixer, syrup,
  bitters, juice, dairy/egg, produce/garnish, etc.) MUST be curator-extensible, not
  hard-coded.
- **FR-014a** *(added 2026-07-12, reconciling specification-statement.md §2)*: Every
  ingredient entry MUST surface the recipes that use it, hierarchy-aware — a
  class-level ingredient lists recipes using it or any descendant — mirroring the
  equipment↔recipe bidirectional linking in FR-024.
- **FR-015**: When used in a recipe, an ingredient's functional role (base spirit,
  modifier, sweetener, sour/acid, lengthener, aromatic, garnish, etc.) MUST be
  capturable per line.
- **FR-016**: Ingredients MUST carry allergen and dietary attributes (egg, dairy, nuts,
  sulfites, gluten, etc.) that roll up automatically to recipes.
- **FR-017**: House-made ingredients MUST be first-class ingredients defined by their
  own recipe (components, method, yield), carrying yield quantity, shelf life, storage
  instructions, batch/prep hooks, and cost roll-up — usable in recipes, inventory, prep
  lists, and costing exactly like any other ingredient.

#### Recipes

- **FR-018**: System MUST provide full create/read/update/delete for recipes with one
  primary name plus any number of alternate names, all searchable.
- **FR-019**: Recipe taxonomy MUST comprise: single-valued optional Family (Cocktail,
  Spirit-Forward, Sour, Highball, Cobbler with julep/smash subtypes, Flip with nog
  subtype, plus curator-approved additions), multi-valued Category (serving
  style/format: buck, collins, fizz, cooler, colada, daisy, punch, etc.), and free-form
  multi-valued filterable Tags (Tiki is a tag, not a family). Taxonomy is
  curator-managed and documented.
- **FR-020**: Recipes MUST support: main photo and gallery; ordered ingredient lines
  (ingredient reference at any hierarchy level + quantity + unit + purpose/role +
  per-line scaling rule); step-by-step instructions; garnish(es); one or more
  acceptable glasses; ice specification; required equipment; multi-valued flavor
  profile descriptors; curated related-cocktail relationships with a relationship note;
  optional creator/originator; history; free-form notes.
- **FR-021**: System MUST support concept pages (e.g., "Daiquiri") linking variant
  recipes, each with a short differentiator, routing to each full recipe. Concept
  pages are created and managed by curators; users MAY attach their published variant
  recipes to a concept page, subject to curator moderation. Private recipes cannot
  appear on concept pages.
- **FR-022**: Each recipe MUST display derived data: calculated ABV and standard drinks
  per serving using method-appropriate dilution assumptions with documented
  conventions; rolled-up allergen/dietary flags displayed prominently; per-serving cost
  when pricing data exists.
- **FR-023**: Recipe media MUST use a generic media-attachment structure so video can be
  added later without remodeling.

#### Equipment

- **FR-024**: System MUST provide full create/read/update/delete for equipment (curated
  core plus user additions) with name, type/category, cost, photo, description,
  how-to-use guidance, and typical applications, linked bidirectionally to requiring
  recipes and related glossary articles. User-added equipment follows the same privacy
  model as user ingredients: private to the owner's library, co-published via the
  FR-008a consent cascade when a published recipe requires it; no standalone equipment
  publishing in V1.

#### Glossary / Encyclopedia

- **FR-025**: Glossary definitions MUST follow a dictionary model: a term exists exactly
  once; multiple meanings are numbered definitions within the single entry; terms carry
  tags linking related recipes, ingredients, and equipment.
- **FR-026**: System MUST support longer-form articles (informational/how-to) that link
  freely to definitions, recipes, ingredients, and equipment.
- **FR-027**: Glossary linking MUST be automatic everywhere (recipe text, ingredient
  descriptions, article bodies): first occurrence per page links to the entry, with
  return navigation to the exact departure point; matching is best-effort automated
  with curator override (suppress or force); users never manually create links.
- **FR-028**: Glossary tags MUST power cross-discovery in both directions (e.g.,
  "recipes using Agricole" from the Agricole entry).

#### Inventory and Makeability

- **FR-029**: Users and venues MUST be able to maintain an inventory of owned
  ingredients at product or class level, with optional quantity/bottle-size tracking.
- **FR-030**: System MUST support adding a bottle by photographing its label (via the
  platform's AI abstraction), with barcode-scan fallback and manual entry always
  available; recognition failures MUST degrade to a pre-filled manual form.
- **FR-031**: System MUST filter/browse recipes fully makeable from current inventory,
  honoring the ingredient hierarchy and substitution rules, and MUST surface
  near-misses ("one ingredient away") with missing items identified and substitutions
  offered.

#### Measurements, Scaling, Batching, Costing

- **FR-032**: All quantities MUST be stored canonically and displayed per user unit
  preference (oz, ml, cl) with full conversion, including counts (dashes, barspoons)
  under documented conventions.
- **FR-033**: Any recipe MUST scale to N servings; each ingredient line MUST carry a
  scaling rule — linear (default), stepwise/rounded, omit-in-batch, or
  add-fresh-at-service — and scaled output MUST clearly separate the batched portion
  from at-service additions.
- **FR-034**: Batch calculations MUST support pre-diluted vs. non-diluted batches with
  method-appropriate target dilution percentages, target-ABV calculation, guidance for
  kegged/on-tap and pre-chilled/bottled service including force-carbonation
  considerations, and yield in user-chosen container sizes; batch and scaling output
  MUST include total standard drinks for the whole batch (and per chosen container)
  plus per-serving strength, using the same jurisdiction-aware standard-drink
  conventions as per-serving display (FR-022/FR-068); batch outputs MUST be savable,
  sendable to prep lists, and printable/exportable.
- **FR-035**: With ingredient pricing (bottle size + price), system MUST compute
  per-drink cost, per-ingredient cost breakdown, pour-cost percentage against a menu
  price, and suggested price for a target pour-cost %; house-made ingredients MUST roll
  up cost from their component recipes; costing MUST feed menu building.

#### Shopping Intelligence

- **FR-036**: System MUST generate shopping lists from selected recipes, from a
  menu/event with guest count driving quantities via batching math, or from prep lists.
- **FR-037**: System MUST provide unlock analysis: purchase recommendations ranked by
  leverage ("buying these 2 bottles unlocks 14 more recipes"), computed against
  inventory, hierarchy, and substitutions.
- **FR-038**: Shopping lists MUST be exportable/shareable in V1; the design MUST
  anticipate (not build) retailer deep links, cart hand-offs, affiliate linking, and
  API ordering — nothing in V1 may preclude these. Hard boundary regardless of
  integration depth: the platform is never the merchant of record and never takes
  payment for alcohol — every purchase completes with the retailer, who carries the
  point-of-sale and delivery age-verification obligations.

#### Prep Management (Pro)

- **FR-039**: System MUST produce prep lists for house-made ingredients, juices, and
  batches — items, quantities from yield math, assignment-ready checklists.
- **FR-040**: Prepared items MUST carry made-on dates and shelf life; the system MUST
  surface expiring/expired preps and reflect prep availability in inventory and
  makeability. Expiry warnings are delivered through the notifications channel per
  FR-040a in addition to in-place indicators on prep lists and inventory.
- **FR-040a**: V1 MUST include a thin slice of the platform notifications capability:
  an in-app inbox as the default, always-on channel for platform-to-user alerts (prep
  shelf-life warnings, account deactivation-expiry warnings), with email as a per-user
  opt-in alert channel; the same email capability carries identity transactional mail
  (recovery, verification). Push notification delivery is deferred to Phase 2 — the
  channel-preference model ships in V1, but FCM/APNs adapters are justified by
  Phase 2's consumer engagement (Long-Horizon Rule applied in the deferring
  direction). Email digests remain out of scope for V1. All such communication flows
  through this single capability — never ad hoc per feature.

#### Collections, Menus, Print/Export

- **FR-041**: Users MUST be able to create collections (user-curated recipe groupings);
  professionals MUST be able to promote collections to menus with per-item pricing
  (costing-aware), descriptions, and ordering.
- **FR-042**: System MUST provide print-friendly and document export for recipe cards
  (single and batch), spec sheets, menus, prep lists, and shopping lists, each with an
  artifact-appropriate layout, using each platform's native print pipeline (no direct
  printer-driver integration).

#### AI-Assisted Features

- **FR-043**: System MUST provide a chat assistant grounded in platform content
  (recipes, technique, substitutions).
- **FR-044**: System MUST present contextual AI insight blocks adapted to page type
  (e.g., recipe background/technique at the bottom of a recipe; variant comparison on a
  concept page).
- **FR-045**: System MUST offer authoring assistance for glossary entries and articles
  (draft generation, tone/terminology conformance) with mandatory human review before
  publish.
- **FR-046**: System MUST provide "if you like X, try Y" discovery from flavor
  profiles, families, shared ingredients, and the tasting log, with a deterministic
  similarity fallback when AI is off.
- **FR-047**: Every AI feature MUST be individually toggleable, MUST label its output as
  AI-generated, and MUST degrade gracefully (deterministic fallback or clean absence)
  when disabled by user, operator, or outage — never a broken UI.

#### Tasting Log

- **FR-048**: System MUST keep a per-user, private-by-default tasting log: "made it"
  history with dates, personal ratings and notes per recipe (distinct from public
  ratings), and variations tried; the log feeds discovery.

#### Search and Filtering

- **FR-049** *(amended 2026-07-12, reconciling specification-statement.md §13)*:
  System MUST provide full-text search across recipes, ingredients, equipment,
  glossary definitions, and articles, consumed through an internal search abstraction
  so the engine can be replaced without feature change. **Search-document
  composition**: a recipe's search document MUST include all its names, its
  ingredient names (at the referenced hierarchy level), garnishes, and
  description/history text — so searching an ingredient (e.g., "rum") surfaces
  recipes that use it, not only recipes named for it. **Results MUST be typed and
  grouped in presentation** (recipes / ingredients / equipment / glossary), so the
  user always knows what kind of entity each result is.
- **FR-050** *(amended 2026-07-12, reconciling specification-statement.md §13)*:
  System MUST provide faceted filtering by family, category, tags, flavor
  profile, glassware, ice, equipment, allergens (exclude), ABV range,
  makeable-from-inventory, rating, and source (core library / my library / public),
  with tag search wherever tags exist; an ingredient-contains facet
  ("uses: <ingredient>", hierarchy-aware — a class-level ingredient matches recipes
  using it or any descendant) complements text search.

#### Bar Mode

- **FR-051**: System MUST provide a hands-free mode for any recipe and for prep-list
  execution: high-contrast, large-type, one step at a time, oversized touch targets,
  optional voice advance ("next"), screen kept awake.

#### Offline Behavior

- **FR-052**: Users MUST be able to choose an offline profile (none / recipes-text /
  plus-glossary / plus-key-photos / full media within a storage budget) and pin
  specific collections for guaranteed offline availability. The offline profile is a
  per-device setting; pinned collections are per account and honored on every device
  at that device's profile fidelity or better.
- **FR-053**: The app MUST clearly report storage used, sync changes on reconnect, and
  prompt on conflicting edits to user-authored content (merge-or-prompt; silent
  last-writer-wins is prohibited for user-authored content).
- **FR-053a**: While offline, search, faceted filtering, and "what can I make?"
  (including near-misses and substitution suggestions) MUST function over the content
  synced by the user's offline profile; inherently online features (community
  browsing, AI features, bottle photo recognition) MUST be clearly indicated as
  unavailable rather than failing silently or breaking the UI.

#### Content Quality and Duty of Care

- **FR-054**: Launch curated content MUST cover the canonical craft-cocktail repertoire,
  standard equipment, and a substantial glossary; terminology MUST follow professional
  craft-cocktail convention with the platform glossary as internal authority where the
  industry disagrees.
- **FR-055**: Allergen display MUST be prominent, conservative (flag when uncertain),
  and clearly disclaimed.
- **FR-067**: The platform MUST present a persistent responsible-consumption message
  on recipe pages, batch/scaling outputs, and the app footer/about surface. Message
  text and placement are jurisdiction-configurable content (per launch market,
  counsel-reviewed) served by the compliance capability, localizable per the i18n
  principle — never hard-coded. ToS legal-age and responsible-use statements remain
  but are explicitly insufficient alone to satisfy constitution Principle XIII
  ("a product requirement, not decoration").
- **FR-068**: Quantified transparency: the per-serving ABV and standard-drinks display
  (FR-022) is designated as serving Principle XIII; batch and scaling outputs MUST
  additionally display the total standard drinks in the batch and per-serving
  strength, so hosts and professionals see the real alcohol content of what they are
  preparing (calculation requirements in FR-034).
- **FR-069**: Jurisdiction-aware support resources (localized helpline/organization
  links, configuration-driven) MUST be reachable from the responsible-consumption
  messaging and from settings/about.
- **FR-070**: Responsible service and responsible consumption MUST be required launch
  content in the encyclopedia — professional responsible-beverage-service knowledge
  (service limits, recognizing intoxication, host duties) treated as craft knowledge
  with the same editorial quality as any other article, auto-linked like all glossary
  content (extends FR-054/SC-013).

#### Forward-Compatibility (build in V1, payoff later)

- **FR-056**: Identity MUST be an isolated module at consumer scale from launch
  (per FR-001–FR-003), independent of tier count.
- **FR-057**: Evaluative user data MUST be event-shaped per FR-009; no weighting logic
  ships in V1, but future re-weighting/re-segmentation MUST be achievable by
  recomputation over existing events without loss of meaning.
- **FR-058**: The data platform MUST include geospatial capability from day one, and
  venue entities MUST carry location coordinates, unused by any V1 feature.
- **FR-059**: Recipe, menu, and costing entities MUST have stable identifiers suitable
  for future point-of-sale mapping (bar-operations expansion is deferred; V1 must not
  preclude it).
- **FR-060**: The following are explicitly deferred but MUST NOT be precluded by V1
  design: recipe import from URLs/other apps; venue multi-user staff accounts and
  staff-training mode (activates as pure data on the FR-004a scope-aware authorization
  model); social layer beyond view/copy/rank; video attachments; retailer API ordering;
  kegged-cocktail/smart-bar hardware integrations; content translation/localization
  rollout; billing and subscription operations (self-serve subscription management,
  dunning, staff billing administration — activates with paid tiers on the V1-defined
  Billing Admin role and the payment-processor port); push-notification channel
  delivery (per FR-040a — the channel-preference model ships in V1, FCM/APNs adapters
  land in Phase 2).

#### Platform Administration (staff-facing)

- **FR-061**: Platform roles and their permission sets MUST be configuration data on
  the (user, role, scope) model, not code. Initial catalog: Super Admin (full platform
  scope: role-grant management, tier/capability configuration, all lower-role
  capabilities), Curator (curated core library CRUD, taxonomy management, auto-link
  overrides), Moderator (public-content moderation and reports), Support (account
  search, non-sensitive account state, reset triggers). A Billing Admin role is
  defined in the catalog but activates with paid tiers. New roles or permission
  changes are configuration, never releases.
- **FR-062**: The platform MUST provide staff consoles for: tier and capability-map
  configuration; role-grant management (platform-scope grants require Super Admin
  approval); curation of all core content; the public-content moderation queue;
  account administration (suspend/reinstate, fulfill data-export and deletion
  requests); and audit-log review.
- **FR-063**: The first Super Admin MUST be provisioned at deployment time through
  environment configuration/seeding — never through public signup; no signup path may
  ever yield a platform-scoped role. A documented break-glass recovery procedure MUST
  exist for loss of all Super Admin access.
- **FR-064**: MFA MUST be mandatory (not optional) for any account holding a
  platform-scoped role; least privilege applies — staff receive the narrowest
  sufficient role.
- **FR-065**: Every administrative action (curation, moderation, role grants, tier
  configuration, account interventions) MUST be recorded in an append-only audit log
  with actor, action, target, timestamp, and before/after state where applicable.
- **FR-066**: Administrative functionality is required on the web client only; mobile
  parity is not required for staff features (a documented, justified exception to the
  platform-parity default).

### Key Entities

- **User**: An account holder (home enthusiast, professional, curator/admin) with
  credentials, date of birth (sensitive PII: encrypted at column level, owned
  exclusively by the identity capability, exposed only as derived age predicates,
  access audit-logged, deleted with the account), unit and offline preferences,
  entitlements via tier, sessions/devices, and lifecycle state.
- **Tier / Entitlement Map**: Configuration-driven mapping of features to commercial
  entitlements; V1 has one default tier granting all end-user features. Independent of
  roles.
- **Role Grant**: A (user, role, scope) assignment where scope is the platform
  (staff trust) or a specific venue (per-establishment access); roles carry granular
  permissions (view/edit/delete/publish) on library resources. V1 uses platform scope
  only.
- **Platform Role (catalog)**: Configuration-data definition of a staff role and its
  permission set — Super Admin, Curator, Moderator, Support, Billing Admin (dormant
  until paid tiers). Changes are configuration, never releases.
- **Audit Log Entry**: Append-only record of an administrative action — actor, action,
  target, timestamp, before/after state where applicable. Never updated or deleted.
- **Venue**: A professional's establishment — name, address, coordinates, external
  references — owning a bar library; single-user in V1 but one user may own many
  venues; shaped for future claiming and staff access.
- **Ingredient**: A node in the classification hierarchy (class → product) with
  category, sources, description, photos, allergen/dietary attributes, and optional
  substitution relationships (with suitability notes). May be house-made, in which case
  it carries its own defining recipe, yield, shelf life, and storage instructions.
- **Recipe**: Primary and alternate names; taxonomy (family, categories, tags); ordered
  ingredient lines (hierarchy-level reference, quantity, unit, role, scaling rule);
  instructions; garnish; glassware; ice; equipment; flavor profile; related recipes
  with notes; creator; history; media attachments; derived ABV/standard
  drinks/allergens/cost. May belong to the curated core, a personal library, or a bar
  library; may be private or public.
- **Concept Page**: A curator-owned cocktail concept (e.g., Daiquiri) linking variant
  recipes with differentiators; users attach published variants subject to curator
  moderation.
- **Equipment**: Bar tool or glassware with category, cost, photo, guidance, and
  bidirectional links to recipes and articles.
- **Glossary Term**: Unique term with one or more numbered definitions and tags linking
  related content.
- **Article**: Long-form knowledge content linking to terms, recipes, ingredients, and
  equipment.
- **Inventory Item**: A user's or venue's held ingredient at product or class level,
  optional quantity/bottle size, including available preps.
- **Rating Event**: Immutable record — who, what, value (1–5), when, context; aggregates
  are derived projections.
- **Tasting Log Entry**: Private made-it record — recipe, date, personal rating, notes,
  variation.
- **Collection / Menu**: User-curated recipe grouping; a menu adds per-item pricing,
  descriptions, and ordering.
- **Prep Item**: A planned or completed preparation — target quantity from yield math,
  made-on date, shelf life, completion state.
- **Shopping List**: Generated purchasable items with quantities and source context
  (recipes, menu/event, prep list); exportable.
- **Copy/Provenance Record**: Attribution linking a copied recipe to its source — a
  curated core recipe or a public user recipe — via one uniform mechanic.
- **Media Attachment**: Generic attachment (photo now, video later) bound to recipes and
  other content.

## Success Criteria _(mandatory)_

### Measurable Outcomes

- **SC-001**: A new user can register and open their first curated recipe in under
  3 minutes.
- **SC-002**: 95% of searches return results in under 1 second; a user can reach any
  curated recipe in at most 3 interactions from the home screen.
- **SC-003**: 100% of recipes containing allergenic ingredients display the rolled-up
  allergen flag prominently; uncertain allergen status is always flagged conservatively.
- **SC-004**: "What can I make?" results are 100% consistent with inventory, hierarchy,
  and substitution rules across the acceptance test suite, including near-miss
  identification.
- **SC-005**: Scaling and batch outputs match documented dilution and conversion
  conventions exactly in acceptance tests, including separation of batched vs.
  at-service items.
- **SC-006**: With pricing data present, pour cost, pour-cost %, and suggested price are
  produced for any recipe, including house-made ingredient cost roll-ups.
- **SC-007**: With all AI features disabled, zero user-facing surfaces are broken:
  every AI feature falls back deterministically or is cleanly absent, verified across
  all AI touchpoints.
- **SC-008**: At least 70% of clear, well-lit label photos of common products are
  recognized correctly; every recognition failure reaches a pre-filled manual form in
  at most 2 interactions.
- **SC-009**: On any configured offline profile, 100% of content promised by that
  profile opens with no connectivity; conflicting offline edits to user-authored
  content always produce a merge-or-prompt resolution, never silent loss.
- **SC-010**: Rating aggregates recomputed from stored events match displayed values
  exactly, demonstrating projections are fully derivable.
- **SC-011**: A new commercial tier can be introduced and verified in a test
  environment purely through configuration, with zero feature-code changes.
- **SC-012**: The platform sustains 10,000 concurrent sessions for 30 minutes under a
  workload mix of ~80% reads (recipe/glossary/browse), ~15% search, ~5% writes
  (ratings, library edits, batch calculations) with: p95 latency ≤ 300 ms for reads,
  ≤ 500 ms for search (consistent with SC-002), ≤ 600 ms for writes; error rate
  < 0.1%; and no degradation trend across the sustain window. AI-assisted endpoints
  are excluded (provider-latency-bound) and measured separately with their
  graceful-degradation behavior asserted instead.
- **SC-013**: Launch curated content includes the canonical craft-cocktail repertoire
  (at minimum, all current IBA official cocktails plus recognized classics), standard
  bar equipment, a glossary of at least 300 terms, and the responsible-service/
  responsible-consumption encyclopedia articles required by FR-070.
- **SC-014**: Bar mode is fully operable without touching the screen (voice advance)
  once opened, and the screen never sleeps during use.
- **SC-015**: Users can export their complete personal data and delete their account
  without support intervention.
- **SC-016**: 100% of administrative actions appear in the append-only audit log with
  actor, action, target, and timestamp; zero platform-scoped roles exist that were not
  created by deployment bootstrap or an audited explicit grant; zero staff accounts
  operate without MFA.
- **SC-017**: Raw DOB values appear in exactly one place outside encrypted identity
  storage — the owner's own data export. Zero occurrences in logs, traces, analytics
  events, BI exports, staff views, or any other API response, verified across the
  acceptance suite; underage registration attempts leave zero persisted records.

## Assumptions

- Copy-with-attribution is the sharing model for public recipes; copies are snapshots
  unaffected by later changes to the original.
- Ratings are 1–5 stars; the displayed aggregate is a simple derived projection in V1
  (future re-weighting happens by recomputation over events).
- Venues are modeled as entities in V1 even with single-user access, carrying identity
  fields (name, address, coordinates, external references) for future
  claiming/verification.
- ABV and standard-drinks math uses method-standard dilution assumptions with
  documented conventions.
- "Printer integration" means each platform's native print pipeline plus document (PDF)
  export — no direct printer-driver integration.
- V1 launches with a single default tier granting all end-user (home and professional)
  features; commercial tiers are a configuration exercise later. Curator/admin powers
  come from platform-scoped staff roles, never from the tier.
- Content curation staffing and sourcing for launch content (SC-013) are handled as a
  product/content workstream parallel to engineering; the numeric targets (IBA
  repertoire, ~300 glossary terms) are working targets, adjustable by the product
  owner.
- The 70% bottle-recognition target (SC-008) is an initial working bar for "clear,
  well-lit photos of common products"; the non-negotiable requirement is the graceful
  manual fallback.
- Account deletion removes personal data while retaining community coherence:
  attribution on copies is anonymized and rating events are retained de-identified,
  consistent with a GDPR-grade posture.
- English is the launch language; internationalization architecture (externalized
  strings, locale-aware formatting, unit preference) is in place from day one per the
  constitution, with content translation deferred.
- The age-affirmation gate ships as a V1 capability with V1 informational surfaces
  configured off or soft; per-jurisdiction values (ages, strictness) are legal-counsel
  decisions per launch market, not engineering defaults.
- Staff/administrative features are web-only in V1 — a documented, justified exception
  to the platform-parity default (spec statement §19).
