# Data Model: SpecPour V1

Conventions: all entities carry a stable, non-reusable identifier (UUIDv7) suitable for
future POS mapping (FR-059); timestamps are UTC; cross-module references are by ID only
(no cross-schema foreign keys); each module owns its PostgreSQL schema. Soft state
transitions are listed where lifecycle matters. Quantities are stored canonically in
millilitres (counts as counts with documented ml equivalences) per research R14.

## Module: identity (`identity` schema)

### User
- id, email (unique, verified flag), password hash (nullable when social-only),
  display name, date_of_birth (required at registration, FR-002 — **sensitive PII**:
  application-layer encrypted column, module-private, exposed only as derived
  predicates/age bands, every decrypt audit-logged, raw value surfaced solely in the
  owner's data export, deleted with the account — FR-002b/SC-017), unit_preference
  (ml|oz|cl), locale, created_at.
- Underage registration attempts persist nothing — no DOB, no identifying attempt
  record (FR-002c); abuse resistance is client-side flagging + anonymous rate
  limiting.
- lifecycle_state: `active → deactivated → deleted`, plus staff-driven
  `active ↔ suspended` (Support/Moderator action, audit-logged — FR-062). Deactivation
  grace period is operator-configurable, default 12 months; warning before expiry;
  expiry triggers the standard deletion flow (FR-003). Deletion anonymizes public
  attribution and de-identifies rating events (edge case + assumptions).
- Relationships: 1:N ExternalLogin, Session/Device, MfaEnrollment; 1:1 Preferences.

### ExternalLogin
- id, user_id, provider key (google|apple|microsoft|…), subject identifier (unique per
  provider).

### SessionDevice
- id, user_id, device name/platform, created_at, last_seen_at, refresh-token family
  reference, revoked_at. Backs the session/device management UI (US2-2).

### MfaEnrollment
- id, user_id, method (totp), secret reference, enabled_at.

## Module: authorization (`authz` schema)

### Tier
- id, stable identifier key (e.g., `default`, `guest`), localizable display-name key,
  active flag. Guest is the configured floor pseudo-tier (FR-004b).

### CapabilityGrant
- tier_id, capability_key (feature-declared string), granted (bool). New tiers are
  rows, not code (FR-004, SC-011).

### PlatformRole  *(catalog — configuration data, FR-061)*
- id, stable role key (super_admin|curator|moderator|support|billing_admin), permission
  set, active flag (billing_admin dormant until paid tiers). Changes are configuration,
  never releases.

### RoleGrant
- id, user_id, role_id (→ PlatformRole for platform scope), scope_type
  (platform|venue), scope_id (null for platform), permissions set
  (view|edit|delete|publish), granted_at, granted_by, approval (Super Admin approval
  reference required for platform-scope grants — FR-062) (FR-004a). V1 issues
  platform-scope grants only; no signup path can create a grant (FR-063). Holding any
  platform-scope grant makes MFA mandatory at sign-in (FR-064).

### AuditLogEntry  *(append-only — FR-065, SC-016)*
- id, actor_user_id, action key, target (entity type + id), timestamp, before/after
  state snapshots where applicable. Written through a single audit port by every
  module's administrative operations (curation, moderation, role grants, tier
  configuration, account interventions); no UPDATE/DELETE permitted on the table.
  First Super Admin bootstrap (deployment-time seeding) writes the inaugural entry.

## Module: catalog (`catalog` schema) — recipes & concept pages

### Recipe
- id, owner (system=curated core | user_id | venue_id), library scope
  (core|personal|bar), primary_name, alternate_names[] (all searchable, FR-018),
  family_id (nullable, single), category_ids[] (multi), tags[] (free-form),
  instructions (ordered steps), garnishes[], glassware_ids[] (≥1 acceptable),
  ice_spec, equipment_ids[], flavor_profile[] (multi), creator_attribution (nullable),
  history text, notes, visibility (`private → public → private…` reversible toggle,
  FR-008b), created/updated timestamps.
- Derived (never stored as truth): ABV + standard drinks per serving (method dilution
  conventions, FR-022), allergen roll-up, per-serving cost (when pricing exists).
- Validation: primary name required; ≥1 ingredient line; publishing requires all
  referenced private ingredients/equipment co-published (FR-008a cascade) and triggers
  the copies-survive warning on first publish (FR-008b).

### RecipeIngredientLine
- id, recipe_id, position, ingredient_id (any hierarchy level, FR-012), quantity,
  unit, purpose/role (nullable, FR-015), scaling_rule
  (linear|stepwise|omit_in_batch|add_fresh_at_service — FR-033).

### RecipeRelation
- recipe_id ↔ related_recipe_id, relationship note (curated, FR-020).

### ConceptPage
- id, name, description, curator-owned (FR-021).
### ConceptVariantLink
- concept_id, recipe_id (must be public or core), differentiator text, state
  (`proposed → approved | rejected` — user attachments are curator-moderated).

### Family / Category (curator-managed taxonomy, FR-019)
- id, name key, definition, (Family: optional subtype parent — julep/smash under
  Cobbler, nog under Flip). Curator-extensible; Tiki is a tag, never a family.

## Module: ingredients (`ingredients` schema)

### Ingredient
- id, owner/library scope (core|personal|bar), name, category_id
  (curator-extensible, FR-014), parent_id (hierarchy: class → … → product, FR-012),
  sources[], description, allergen/dietary attributes[] with per-attribute certainty
  (certain|uncertain → conservative flagging, FR-055), visibility (private/public,
  same cascade rules as recipes).
- House-made extension (nullable 1:1): defining_recipe_id, yield quantity, shelf_life
  (duration), storage instructions (FR-017). Validation: defining recipe must not
  transitively include the ingredient itself (circular-reference rejection, edge
  case).

### SubstitutionRule
- from_ingredient_id, to_ingredient_id, suitability note (curated, FR-013);
  hierarchy-implied substitution is computed (descendant satisfies ancestor), not
  stored.

### IngredientPrice
- ingredient_id, owner (user/venue), bottle size, price, currency, effective_at
  (drives costing, FR-035).

## Module: equipment (`equipment` schema)

### Equipment
- id, owner/library scope (core|personal|bar), name, type/category, cost, description,
  usage guidance, typical applications, visibility (private; co-published via cascade;
  no standalone publishing in V1 — FR-024). Bidirectional links to recipes (via
  recipe.equipment_ids) and glossary articles (via glossary tags).

## Module: glossary (`glossary` schema)

### GlossaryTerm
- id, term (unique — a term exists exactly once, FR-025), definitions[] (ordered,
  numbered), tags[] linking recipes/ingredients/equipment.
### Article
- id, title, body, links to terms/recipes/ingredients/equipment (FR-026).
### LinkOverride
- id, context (page/content ID), term_id, action (suppress|force) — curator override
  for auto-linking (FR-027). Auto-links themselves are computed at render, not stored;
  longest-match wins (edge case).

## Module: community (`community` schema)

### PublicationRecord
- subject_id (recipe/ingredient/equipment), published_at, unpublished_at (nullable),
  actor (owner|curator), first_publish_warning_acknowledged (FR-008b).
### ModerationAction
- id, subject_id, action (unpublish|flag), curator_id, reason, at (FR-010).
### CopyProvenance
- copy_recipe_id, source_id (core or public recipe — one uniform mechanic), source
  owner attribution snapshot (anonymized on source-owner deletion), copied_at.
### RatingEvent  *(immutable, append-only — FR-009/FR-057)*
- id, user_id, subject_type + subject_id (subject-agnostic), value (1–5), occurred_at,
  context. Never updated or deleted; user deletion de-identifies (user_id →
  tombstone), events retained.
### RatingProjection  *(derived, recomputable)*
- subject_id, aggregate mean over each user's latest event (one-person-one-vote),
  rating count, computed_at, projection_version. Rebuildable from events; SC-010
  asserts recompute == displayed. Hidden from public display while subject is
  unpublished (FR-008b), restored on republish.

## Module: inventory (`inventory` schema)

### InventoryItem
- id, owner (user_id|venue_id), ingredient_id (product or class level, FR-029),
  optional quantity + bottle size, source (photo-recognition|barcode|manual|prep),
  added_at. Prep-sourced items link to PrepItem and expire with it (US10-2).

## Module: measurements (`measurements` schema) — units, scaling, batching, costing

### ConventionTable  *(versioned reference data — R14)*
- version, unit equivalences (dash/barspoon ml), method dilution percentages,
  standard-drink gram values per jurisdiction. Documented; curator-adjustable.
### BatchResult
- id, owner, recipe_id, servings, pre_diluted flag, target dilution/ABV inputs,
  computed output snapshot (batched vs at-service separation; total standard drinks
  for the batch and per container, jurisdiction-aware conventions), container size,
  saved_at (savable, sendable to prep, printable — FR-034).
- Menu pricing/costing outputs are computed, not stored, except MenuItem price fields.

## Module: shopping (`shopping` schema)

### ShoppingList
- id, owner, source context (recipes[]|menu_id+guest_count|prep_list_id), line items
  (ingredient_id, quantity), created_at, export format history (FR-036/FR-038).
- Unlock analysis is computed on demand (inventory × hierarchy × substitutions,
  FR-037), not stored.

## Module: prep (`prep` schema)

### PrepList
- id, owner (venue|user), name, items[], created_at (FR-039).
### PrepItem
- id, prep_list_id, target (house-made ingredient_id | batch_result_id | juice),
  required quantity (yield math), state (`planned → completed → expired`), made_on,
  shelf_life snapshot, composition/cost snapshot at completion (edge case: later
  recipe changes don't rewrite completed preps), completed_by.
- Expiry triggers a notification event (FR-040/FR-040a) and removes availability from
  makeability (US10-2).

## Module: collections (`collections` schema)

### Collection
- id, owner, name, recipe_ids[] ordered, pinned_offline flag (per-account pin,
  FR-052).
### Menu  *(promotion of a collection — FR-041)*
- id, venue_id, collection_id, items[]: recipe_id, price, description, display order.
  Stable IDs for future POS mapping (FR-059).

## Module: tastinglog (`tastinglog` schema)

### TastingLogEntry
- id, user_id (private by default, FR-048), recipe_id, made_on date, personal rating,
  notes, variation notes. Fully independent of community RatingEvent (US13-2). Feeds
  discovery locally.

## Module: media (`media` schema)

### MediaAttachment
- id, owner, subject (recipe|ingredient|equipment|article|…), kind (photo now; video
  later without remodeling — FR-023), object-storage key, content type, size, position
  (gallery order), created_at. Binary lives in object storage only.

## Module: notifications (`notifications` schema) — thin V1 slice (FR-040a)

### InboxMessage
- id, user_id, type (prep_expiry|account_deactivation_warning|…), payload, created_at,
  read_at. Always-on channel.
### ChannelPreference
- user_id, channel (push|email), opted_in — email is the V1 opt-in alert channel and
  also carries identity transactional mail; the push preference is modeled in V1 but
  push delivery is deferred to Phase 2 (FR-040a) — updated_at. All deliveries audited
  (audit log table).

## Module: ai (`ai` schema)

### PromptVersion  *(registry — Principle V; analyze-U1 decision, T141 ADR)*
- id, prompt key, version, template reference (template text lives in the repo for
  code review), model, provider, created_at.
### PromptEvaluation
- prompt_version_id, evaluation run reference, dataset reference (e.g., the SC-008
  labeled bottle-photo set from T147), metrics, evaluated_at.
### AiFeatureToggle
- feature key, operator-scope enabled flag, updated_at (per-user toggles live in user
  preferences).
- Note: **Search deliberately owns no schema** — it is a port, not a domain-data
  owner; tsvector/trigram columns live in each owning module's schema, maintained via
  ContentChanged events. A future dedicated engine brings its own external index via
  the adapter (interpretation of Principle III recorded as an ADR).

## Module: compliance (`compliance` schema)

### SurfaceGateConfig
- surface key, strictness (off|soft|mandatory) — per-surface age-gate configuration
  (FR-002a).
### JurisdictionRule
- jurisdiction code, legal drinking age, source/citation, effective_at
  (legal-counsel-supplied; strictest-rule default applies when unresolved).
- Note: guest-entered DOB is never stored anywhere (client-side affirmed flag only).
### ResponsibleConsumptionMessage  *(FR-067)*
- jurisdiction code (or default), surface class (recipe|batch_output|footer_about),
  placement descriptor, localizable message content key, effective_at — text and
  placement set on legal counsel's review per launch market.
### SupportResource  *(FR-069)*
- jurisdiction code (or default), resource name, localized link/phone, display order,
  effective_at — jurisdiction-aware helpline/organization links, configuration-driven,
  surfaced from the responsible-consumption messaging and settings/about.

## Module: venues (`venues` schema)

### Venue
- id, owner_user_id (1:N — one professional may own many venues), name, address,
  location (PostGIS point — stored, unused by V1 features, FR-058), external
  references[], created_at. Single-user container in V1; shaped for future
  claiming/verification and venue-scoped role grants (FR-004a/FR-060).

## Cross-module event flows (outbox-dispatched domain events)

- `RecipePublished` / `RecipeUnpublished` (catalog → community, search).
- `RatingRecorded` (community → projection updater).
- `PrepCompleted` / `PrepExpired` (prep → inventory availability, notifications).
- `AccountDeactivated` / `DeactivationExpiryApproaching` (identity → notifications).
- `ContentChanged` (any content module → search indexer, glossary auto-link cache,
  offline sync change log).

## Sync change log (supports offline protocol — R9)

### SyncChange
- monotonic cursor, entity type + id, change kind, occurred_at, sync protocol version.
  Pull-based device sync consumes this log filtered by the device's offline profile
  tier and the account's pinned collections.
