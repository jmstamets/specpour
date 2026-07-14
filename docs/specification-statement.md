# Spec-Kit Specification Statement — Craft Cocktail Platform

Use the following statement as the input to spec-kit's `/specify` step. It defines the business logic and functional requirements of the application. Engineering principles (stack, architecture, testing practice) are defined separately in the constitution. V1 may be released in phases, but everything marked V1 below is in the V1 scope.

---

Build a cross-platform (Android, iOS, web) craft-cocktail application for home enthusiasts and professional bartenders. The product's positioning is category leader: it must deliver every established killer feature of the cocktail-app market plus the gap-filling capabilities specified here, with terminology and technique conforming to professional craft-cocktail standards.

## 1. Users, Content Ownership, and Sharing

- **Accounts and authentication — first-class V1 feature.** Robust, consumer-scale authentication ships in V1, sized for the platform's future rather than V1's modest needs: email/password registration with modern credential handling, social sign-in (OIDC-based providers), optional multi-factor authentication, secure account recovery, session and device management, and full account lifecycle (deactivation, data export, deletion). Account recovery covers MFA loss, not only passwords: one-time backup codes (stored as salted hashes, shown once at generation) are the self-service path, and an audited staff MFA-reset (platform-admin console) is the assisted path — password reset alone must never bypass an MFA gate, and MFA loss must never be a permanent lockout. **Date of birth is captured at registration** and stored — unused for gating in V1, but required so future age-gated consumer features activate without re-collecting from the installed base. Identity/auth is its own isolated module per the constitution.
- **DOB is sensitive PII with mandated handling.** Purpose-bound to age verification and legal compliance only (any new use requires updated disclosure/consent). The identity module exclusively owns the stored DOB and exposes only derived predicates (e.g., of-legal-drinking-age for a given jurisdiction) to all other modules, APIs, and analytics — the raw value never appears in API responses (except the owner's data export), logs, traces, analytics events, staff/admin views (staff see verified status, not DOB), or BI exports; age bands only where analytics need age at all. Stored with application/column-level encryption beyond disk encryption, with access audit-logged; deleted with the account. **Underage registration attempts are rejected without persisting the entered DOB or any identifying record of the attempt** (a minor's data must not be retained — COPPA-relevant when under 13); retry-gaming is resisted with client-side flagging and rate limiting, not server-side storage of the failed DOB.
- **Guest (unauthenticated) access.** The app is usable without an account: guests can browse and full-text search the read-only public surface — the curated core library (recipes, ingredients, equipment), the glossary/encyclopedia, and public user recipes with their aggregate ratings. Everything that writes or personalizes requires an account: personal/bar libraries, copying, rating, inventory, shopping lists, tasting log, offline profiles, and AI chat. Guest capability is modeled as the floor of the entitlement map (a configurable pseudo-tier below all account tiers), so what guests can see is tier configuration, not code. When a guest attempts an account-gated action, the app prompts registration/sign-in and **completes the original action after signup** (no lost intent). Public content on the web surface is crawlable/shareable (SEO as a growth channel), with abuse controls (rate limiting) on anonymous traffic.
- **Guest age affirmation (capability ships in V1).** The platform includes a jurisdiction-aware age-gate capability for unauthenticated access: a **date-of-birth-entry form** (not a yes/no checkbox, per FTC self-regulation guidance and industry codes), with the applicable legal drinking age selected by coarse geolocation and defaulting to the strictest applicable rule when jurisdiction is uncertain. The entered DOB is **checked and never stored** — only a client-side "affirmed" flag persists (data-minimization). Gate strictness is **configurable per surface**: it may be off or soft for purely informational content (V1's recipes/glossary) and is mandatory for any surface carrying producer or establishment marketing content (activated in later phases). Registered users are gated by their account DOB instead. Terms of service state the service is intended for users of legal drinking age. The framework is a platform requirement; the per-jurisdiction configuration values are set on legal counsel's review per launch market.
- **Tiers.** V1 ships with a single default account tier that unlocks all end-user capabilities (the complete home and professional feature sets), but every feature is entitlement-gated so free/home/professional/consumer tiers can be introduced later purely through configuration. Curator/admin powers are platform-staff roles assigned explicitly, independent of the tier map (see Section 18's authorization model).
- **Content model.** A **curated core library** of recipes, ingredients, equipment, and glossary content is maintained by platform curators/admins. Users create **private** recipes and ingredients in their personal library. Professional users can build a **bar library** for their venue (structurally the same as a personal library, scoped to a venue entity, ready for future multi-user staff access).
- **Publishing and community (V1: view + rank, no threads).** Users may optionally make their creations public. Other users can browse public recipes, **copy** them into their own library (copy records provenance/attribution to the original), and **rate** them. Ratings are stored as **individual, per-user rating events** (who, what, value, when, context); displayed aggregates are derived, recomputable projections — never the stored truth. This is a hard requirement: future phases will re-weight and re-segment ratings (e.g., verified-visit weighting, multiple rating subjects), which must be possible by recomputation over existing events without data loss or migration of meaning. Public content displays aggregate ratings. Commenting threads are explicitly out of scope for V1 (moderation cost); the data model should not preclude adding them later. Public content is subject to curator moderation actions (unpublish, flag).

## 2. Ingredients

Full CRUD for ingredients with:

- Name, category, source(s), description, photo(s).
- **Classification hierarchy — best-in-class requirement.** Ingredients form a taxonomy from broad class to specific product, e.g., Spirit → Rum → Rhum Agricole → _specific brand/bottling_. Recipes may reference any level (a recipe calls for "London dry gin"; a user's inventory holds "Beefeater"). The hierarchy powers:
  - **Substitution:** curated substitution relationships (with suitability notes, e.g., "acceptable in stirred drinks, changes profile") plus hierarchy-implied substitution (any descendant satisfies an ancestor requirement). Substitution suggestions appear wherever an ingredient gap blocks a recipe.
  - **Inventory matching** (Section 6) and shopping intelligence (Section 8).
- **Bidirectional recipe links:** every ingredient entry surfaces the recipes that use it (hierarchy-aware: a class-level ingredient lists recipes using it or any descendant), mirroring the equipment↔recipe bidirectional linking in Section 4.
- Categories include (extensible, curator-managed): spirit, liqueur, fortified wine, mixer, syrup, bitters, juice, dairy/egg, produce/garnish ingredient, and others as needed. Categories are curator-extensible, not hard-coded.
- **Purpose-in-recipe:** when an ingredient is used in a recipe, its functional role can be captured (base spirit, modifier, sweetener, sour/acid, lengthener, aromatic, garnish, etc.).
- **Allergen and dietary attributes** per ingredient (egg, dairy, nuts — e.g., orgeat, sulfites, gluten, etc.), which roll up automatically to recipes (Section 5).
- **House-made ingredients are first-class (feature-rich requirement).** Syrups, infusions, cordials, shrubs, tinctures, and other house preparations are ingredients that are _themselves defined by a recipe_ (ingredients, method, yield). They carry: yield quantity, shelf life, storage instructions, batch/prep tracking hooks (Section 9), and cost roll-up from their component ingredients (Section 7). A house-made ingredient appears in recipes, inventory, prep lists, and costing exactly like any other ingredient.

## 3. Recipes

Full CRUD for recipes with:

- **Names:** one primary name plus any number of alternate names (all searchable).
- **Taxonomy** (resolving industry inconsistency in favor of professional convention; curator-managed and documented):
  - **Family** — single-valued, optional, from the structural families: Cocktail (spirit + sugar + bitters), Spirit-Forward, Sour, Highball, Cobbler (with julep/smash subtypes), Flip (nog as dairy subtype), and curator-approved additions. Family describes the drink's structural DNA.
  - **Category** — multi-valued serving-style/format descriptors (buck, collins, fizz, cooler, colada, daisy, punch, etc.).
  - **Tags** — free-form, multi-valued, filterable labels for everything that isn't structural: Tiki, IBA official, low-ABV, seasonal, house original, etc. (Tiki is deliberately a tag/style, not a family.)
- **Content fields:** main photo; photo gallery; ordered ingredient lines (ingredient reference at any hierarchy level + quantity + unit + purpose/role + per-ingredient scaling rule, Section 7); step-by-step instructions; garnish(es); glassware (one or more acceptable glasses); ice specification (type/format); required equipment (shakers, strainers — Hawthorne/julep/fine-mesh — mixing glass, etc.); flavor profile descriptors (multi-valued: bitter, sweet, aromatic, fruity, smoky, etc.); related cocktails (curated relationships with a relationship note, e.g., Negroni ↔ Boulevardier ↔ Kingston Negroni ↔ Sbagliato); creator/originator (optional, e.g., Trader Vic for the Mai Tai); history; free-form notes.
- **Versions/variations.** A cocktail may exist as a **concept page** (e.g., "Daiquiri") with linked **variant recipes**, each carrying a short differentiator description ("uses rhum agricole," "split-base Hemingway riff"). The concept page lists variants and routes to each full recipe. An AI-generated comparison summary of the variants may appear on the concept page (Section 11).
- **Derived data displayed per recipe:** calculated ABV and standard-drinks per serving (accounting for dilution assumptions by preparation method); rolled-up allergen/dietary flags with prominent display; per-serving cost when the user has pricing data (Section 7).
- **Media future-proofing:** the recipe media model is a generic media-attachment structure so video attachments can be added later without remodeling.

## 4. Equipment

Full CRUD (curated core + user additions) for bar equipment: strainers, shakers, mixing glasses, spoons, jiggers, muddlers, ice tools, blenders, glassware, etc. Fields: name, type/category, cost, photo, description, how-to-use guidance, and typical applications. Equipment entries link bidirectionally to recipes that require them and to relevant glossary articles.

## 5. Glossary / Encyclopedia

- A reference knowledge base split into two content types:
  - **Definitions (dictionary model):** a term exists **exactly once**; if multiple meanings apply, the single entry holds multiple numbered definitions (e.g., "punch" — the drink family; the serving format). Terms have tags linking them to related recipes, ingredients, and equipment.
  - **Articles (informational/how-to):** longer-form content — what Agricole is and how it differs from other rum, bitters styles and uses, glassware guidance, ice types and why they matter, technique guides. Articles link freely to definitions, recipes, ingredients, and equipment.
- **Automatic linking (no manual linking anywhere).** When a glossary term appears in recipe text, ingredient descriptions, article bodies, or other content, it is auto-linked to its glossary entry — first occurrence per page, with straightforward return navigation to the exact spot the reader left. Matching is best-effort automated with curator override (suppress or force a link) for edge cases. Users never manually create links.
- **Tag-based cross-discovery:** glossary tags surface related recipes and vice versa ("recipes using Agricole" from the Agricole entry).

## 6. Inventory and "What Can I Make?"

- Users (and venues) maintain an inventory of owned ingredients — at product level (specific bottle) or class level ("I have _a_ London dry gin"), with optional quantity/bottle-size tracking.
- **Bottle recognition:** add a bottle by photographing the label (AI vision through the platform's AI abstraction) with barcode-scan fallback and manual entry always available. Recognition failures degrade to a pre-filled manual form.
- **What can I make?** — filter/browse recipes fully makeable from current inventory, honoring the ingredient hierarchy and substitution rules. Also surface **near-misses**: "one ingredient away," with the missing item(s) identified and substitution options offered.

## 7. Measurements, Scaling, Batching, and Costing

- **Units:** all quantities stored canonically; displayed per user preference (oz, ml, cl); full unit conversion including counts (dashes, barspoons) with documented conversion conventions.
- **Scaling:** any recipe scales to N servings. Each ingredient line carries a **scaling rule**: scale linearly (default), scale stepwise/rounded, **omit in batch** (e.g., citrus juiced fresh at service), or **add fresh at service** (e.g., egg white shaken per drink). Scaled output clearly separates the batched portion from at-service additions.
- **Batching (industry-standard, dilution-aware).** Batch calculations support: pre-diluted vs. non-diluted batches (adding water to replace shake/stir dilution, with method-appropriate target dilution percentages); target-ABV calculation; guidance for kegged/on-tap and pre-chilled/bottled service including force-carbonation considerations; batch yield in user-chosen container sizes. Batch outputs can be saved, sent to prep lists (Section 9), and printed/exported (Section 10).
- **Pour costing (pro).** Ingredient pricing (bottle size + price) produces per-drink cost, cost breakdown per ingredient, pour-cost percentage against a menu price, and suggested price for a target pour-cost %. House-made ingredients roll up cost from their component recipe. Costing feeds menu building (Section 10).

## 8. Shopping Intelligence

- Generate shopping lists from: selected recipes, a menu/event (with guest count driving quantities via batching math), or prep lists.
- **Unlock analysis:** recommend purchases by leverage — "buying these 2 bottles unlocks 14 more recipes you can make" — computed against inventory, hierarchy, and substitutions.
- **Future (model for it, don't build it):** integration with online liquor retailers for auto/semi-auto ordering. Because retailer APIs are scarce, the design must anticipate a spectrum: exportable/shareable lists (V1), deep links or cart hand-offs to retailers where possible, affiliate-style linking, and true API ordering if/when partners exist. Nothing in V1 may preclude this. **Hard boundary regardless of integration depth: the platform is never the merchant of record and never takes payment for alcohol** — every purchase completes with the retailer, who carries the point-of-sale and delivery age-verification obligations. This keeps the platform permanently outside direct-to-consumer alcohol-sale verification regimes.

## 9. Prep Management (Pro)

- Prep lists for house-made ingredients, juices, and batches: what to make, quantities (yield math from Section 7), and assignment-ready checklists.
- **Shelf-life tracking:** prepared items carry made-on dates and shelf life; the app surfaces expiring/expired preps ("your grenadine expires Thursday") and reflects prep availability in inventory and what-can-I-make.

## 10. Collections, Menus, and Print/Export

- **Collections:** user-curated recipe groupings (home: "Tiki night"; pro: working lists).
- **Menus (pro):** collections promote to menus with per-item pricing (costing-aware), descriptions, and ordering.
- **Print/export integration:** print-friendly and PDF export for recipe cards (single and batch), spec sheets, menus, prep lists, and shopping lists, with layout appropriate to each artifact (e.g., spec-sheet format for staff, styled menu for guests). Printing uses each platform's native print pipeline; no direct printer-driver integration is required.

## 11. AI-Assisted Features (all individually toggleable, all gracefully degrading)

- **Chat assistant:** conversational help across the app (recipe questions, technique, substitutions), grounded in the platform's own content.
- **Contextual insight blocks:** a relevant AI-generated paragraph presented in-context — e.g., at the bottom of a recipe (background, technique pointers) or on a concept page (summarizing how the variants differ). Presentation adapts to page type.
- **Authoring assist:** drafting help when curators/users create glossary entries and articles (draft generation, tone/terminology conformance to professional standards), with human review before publish.
- **Discovery:** "if you like X, try Y" recommendations from flavor profiles, families, shared ingredients, and the user's tasting log — with a deterministic similarity fallback when AI is off.
- **Bottle recognition** (Section 6) rides the same AI abstraction.
- All AI output is labeled; every AI feature has a defined non-AI fallback or clean absence.

## 12. Personal Tasting Log

Per-user, private-by-default log: "made it" history, personal ratings and notes per recipe (distinct from public rankings), date and variations tried. Feeds discovery/recommendations.

## 13. Search and Filtering

Full-text search across recipes, ingredients, equipment, glossary definitions, and articles. **Search-document composition:** a recipe's search document includes all its names, its ingredient names (at the referenced hierarchy level), garnishes, and description/history text — so searching an ingredient (e.g., "rum") surfaces recipes that use it, not only recipes named for it. **Results are typed and grouped** in presentation (recipes / ingredients / equipment / glossary), so the user always knows what kind of entity each result is. Faceted filtering by family, category, tags, flavor profile, glassware, ice, equipment, allergens (exclude), ABV range, makeable-from-inventory, rating, and source (core library / my library / public); an ingredient-contains facet ("uses: <ingredient>", hierarchy-aware) complements text search. Tag search available wherever tags exist.

## 14. Bar Mode (Hands-Free Operation)

A high-contrast, large-type, step-through recipe view designed for wet-hands, behind-the-bar use: one step at a time, oversized touch targets, optional voice-advance ("next"), screen stays awake. Available for any recipe and for prep-list execution.

## 15. Offline Behavior (Business Rules)

Users choose an offline profile (none / recipes-text / + glossary / + key photos / full media within storage budget) and can pin specific collections for guaranteed offline availability. The app clearly reports storage used, syncs changes on reconnect, and prompts on conflicting edits to user-authored content. Offline scope is user-tunable and expected to be refined through iteration.

## 16. Explicitly Deferred (design-compatible, not built in V1)

- Recipe import from URLs/other apps.
- Venue multi-user staff accounts and staff-training/quiz mode.
- Social layer beyond view/copy/rank (comments, following, feeds).
- Video attachments on recipes (media model ready in V1).
- Retailer API ordering (Section 8 posture).
- **Bar-operations expansion:** future companion capability (or companion app) for running the bar — sales tracking, top-seller trending, and/or integration with existing POS/venue software. V1 must not preclude this: recipe, menu, and costing entities need stable identifiers suitable for future POS mapping.
- Kegged-cocktail/monitoring and other smart-bar hardware integrations.
- Content translation/localization rollout (architecture supports from day one).

## 17. Non-Functional Business Expectations

Professional terminology throughout, with the platform glossary as the internal authority where the industry disagrees. Curated core content quality is a product feature: launch content must cover the canonical craft-cocktail repertoire, standard equipment, and a substantial glossary. Allergen display accuracy is a duty-of-care requirement and must be prominent, conservative (flag when uncertain), and clearly disclaimed.

## 18. Forward-Compatibility Requirements (Phase 2 Enablers — build in V1, cheap now, expensive later)

These are V1 requirements whose full payoff arrives in later phases; each is deliberately small in V1 scope:

- **Consumer-scale identity** and **DOB at registration** per Section 1 — no age gating behavior in V1, only the data and the module isolation.
- **Rating events, derived aggregates** per Section 1 — no weighting logic in V1, only the event-shaped storage.
- **Search behind an internal port:** all full-text/tag search (Section 13) is consumed through a search abstraction. The V1 implementation may be PostgreSQL full-text search; a future move to a dedicated search engine must be an adapter swap, invisible to feature code.
- **Geospatial readiness:** the database includes geospatial capability (PostGIS or equivalent) from day one, and venue entities carry location coordinates — unused by any V1 feature, but eliminating a risky live-database enablement later.
- **Venue entity completeness:** venues carry the identity fields future claiming/verification will attach to (name, address, coordinates, external references), even though V1 venues are single-user containers for a pro's bar library.
- **Scope-aware authorization model:** role grants are modeled as (user, role, scope) from day one, where scope is the platform (curator/admin staff roles) or a specific venue. Roles carry granular permissions (e.g., view/edit/delete/publish) on library resources. Tiers, platform roles, and venue-scoped roles are three independent concepts: tiers are commercial entitlements, platform roles are staff trust, venue roles are per-establishment access. V1 uses only the platform scope and single-member venues, but the model must already support a future venue owner granting staff differentiated access (e.g., all bartenders view the bar's specs; only designated members edit or delete) as pure data — no authorization redesign.

## 19. Platform Administration (staff-facing — V1 requirement)

The operator side of the platform is a first-class specified feature set, exercising the Section 18 authorization model at platform scope.

- **Platform role catalog.** Roles and their permission sets are configuration data on the (user, role, scope) model, not code. Initial catalog: **Super Admin** (full platform scope: role-grant management, tier/capability configuration, all lower-role capabilities), **Curator** (curated core library CRUD — recipes, ingredients, equipment, glossary definitions and articles; taxonomy management; autolink suppress/force overrides), **Moderator** (public-content moderation: unpublish, flag, handle reports), **Support** (account assistance: search accounts, view non-sensitive account state, trigger resets). A **Billing Admin** role is defined in the catalog but activates with paid tiers (Phase 2). New roles or permission changes are configuration, never releases.
- **Administrative capabilities (each a testable feature):** tier and capability-map configuration; role-grant management (grant/revoke, with Super Admin approval required for platform-scope grants); curation console for all core content; moderation queue for public user content; account administration — suspend/reinstate accounts and fulfill data-export and deletion requests (the operational counterpart to the account-lifecycle rights in Section 1); audit-log review.
- **Bootstrap and break-glass.** The first Super Admin is provisioned at deployment time through environment configuration/seeding — never through public signup, and no signup path can ever yield a platform-scoped role. A documented break-glass recovery procedure exists for loss of all Super Admin access.
- **Staff security posture.** MFA is mandatory (not optional) for any account holding a platform-scoped role. Every administrative action is audit-logged (actor, action, target, timestamp, before/after where applicable) in an append-only record, per the constitution. Least privilege applies: staff receive the narrowest sufficient role.
- **Surface:** administrative functionality is required on the web client only; mobile parity is not required for staff features (a deliberate exception to the platform-parity default, justified here).

## 20. Responsible Consumption (functional requirements — V1)

These requirements operationalize the constitution's Regulated-Industry Posture principle ("a product requirement, not decoration"):

- **Messaging surface:** a persistent responsible-consumption message appears on recipe pages, batch/scaling outputs, and the app footer/about surface. Message text and placement are jurisdiction-configurable content (per launch market, counsel-reviewed), localizable per the i18n principle — never hard-coded.
- **Quantified transparency:** the per-serving ABV and standard-drinks display (Section 3) is designated as serving this principle. Batch and scaling outputs additionally display the **total standard drinks in the batch** and per-serving strength, so hosts and professionals see the real alcohol content of what they are preparing.
- **Support resources:** jurisdiction-aware support resources (localized helpline/organization links, configuration-driven) are reachable from the responsible-consumption messaging and from settings/about.
- **Encyclopedia coverage:** responsible service and responsible consumption are required launch content in the encyclopedia (professional responsible-beverage-service knowledge — service limits, recognizing intoxication, host duties — treated as craft knowledge with the same editorial quality as any other article), auto-linked like all glossary content.
- ToS legal-age and responsible-use statements remain, but are explicitly insufficient alone to satisfy the constitutional principle.

---

_Assumptions encoded above (veto any):_ copy-with-attribution for public recipes; ratings are 1–5 stars aggregate; venues are modeled as entities in V1 even with single-user access; ABV math uses method-standard dilution assumptions with documented conventions; "printer integration" = native print pipeline + PDF export rather than direct printer drivers.
