# Spec-Kit Specification Statement — Phase 2 Addendum: Establishment & Patron Network

Use this statement with spec-kit's `/specify` step as an addendum to the V1 specification. V1 (the recipe platform) ships and operates first; Phase 2 builds the two-sided network on top of it. Phase 2 is internally sequenced as **2A** (network foundation) and **2B** (depth features) so a revenue-generating, testable release exists at each stage. Everything references and reuses V1 entities — nothing here duplicates V1 functionality.

---

Extend the craft-cocktail platform into a two-sided network connecting consumers ("Patrons") with establishments (bars, distilleries, breweries, wineries). Strategic positioning: the trusted, professional-grade counterpart to consumer check-in apps — executing the check-in/discovery model with better rating integrity, no pay-to-be-verified gatekeeping, no per-item-type pricing penalties, brandable venue content, and a unique menu-recipe fusion no competitor can replicate.

## 1. Tiers Activated (Phase 2A)

The V1 entitlement infrastructure activates real tiers (names are configurable/localizable; identifiers stable):

- **Guest** (no account; the entitlement floor from V1): browses and searches all public surfaces — core library, glossary, public recipes, and now the discovery map, establishment profiles, and published menus. All interactive/social actions (check-ins, reviews, wishlists, subscriptions) require an account, whose registration DOB enforces age gating. Guest browsing uses the V1 age-affirmation capability: a jurisdiction-aware **DOB-entry gate** (checked, never stored; client-side affirmation flag only), **mandatory on all surfaces carrying producer or establishment marketing content** (profiles with promotions, specials, producer portfolios) per industry self-regulatory codes, and configurable for informational surfaces (per the constitution's Regulated-Industry Posture principle).
- **Patron** (free): discovery, check-ins, reviews, wishlists, subscriptions to establishments, limited personal recipe library.
- **Enthusiast** (paid, consumer): everything in Patron plus the full V1 home suite (unlimited recipes, inventory, what-can-I-make, batching, offline profiles).
- **Venue** (establishment; free claim + paid feature tiers): claimed profile, menus, publishing, subscriber communications, analytics — depth gated by paid tier.
- **Producer** (distillery/brewery/winery; free claim + paid feature tiers): Venue capabilities plus product-portfolio management.

Establishment **claiming and baseline presence are free** — deliberate market positioning. Paid establishment tiers gate publishing volume, analytics depth, subscriber tools, and integrations, never basic verified existence.

**Billing and subscription operations (activate with paid tiers).** Paid tiers require the operational layer around the payment-processor adapter (constitution Principle 3): self-serve subscription management for users and establishments (subscribe, upgrade/downgrade with proration, cancel, payment-method management, invoices/receipts — invoicing suitable for business customers on establishment tiers); dunning/failed-payment handling with grace periods before entitlement downgrade; and staff-side billing administration via the V1-defined **Billing Admin** role (refunds, comps/trials, manual tier overrides with reason codes — all audit-logged per the constitution's Trust, Verification, and Content Integrity principle). Entitlement changes from billing events flow through the existing tier/capability map; billing never toggles features directly. The platform stores no raw payment credentials (processor-tokenized only).

## 2. Establishments (Phase 2A)

- **Entity model:** Establishment with subtypes: bar/venue, restaurant-with-program, distillery, brewery, winery (subtypes extensible). Producers (distillery/brewery/winery) additionally carry a product portfolio (Section 7). The V1 venue entity is the foundation; a Pro user's bar library attaches to their claimed establishment.
- **Profile:** name, locations (multi-location supported), geocoordinates, hours (with holiday/exception support), contact/links, photos, program description, tags (craft cocktail, tiki bar, tasting room, etc.).
- **Claiming and verification.** Claiming is instant but _soft_ (limited abilities, visibly "pending verification"). Verification methods, any one sufficient: (a) automated phone/SMS code to the establishment's publicly listed number; (b) email verification on the establishment's website domain; (c) **liquor-license verification** — submitted license details matched against public license records (jurisdiction-aware); (d) postcard-with-code fallback; (e) manual curator review as backstop. Verified establishments display a verification mark. Include dispute, transfer (ownership change), and stale-claim reclamation workflows. Verification evidence handled per the constitution's Trust, Verification, and Content Integrity principle.

## 3. Discovery Map (Phase 2A)

Geolocated establishment discovery: map and list views; filters for open-now, establishment type, program tags, rating, distance, "serves [cocktail/product]", active specials/happy hour, and subscribed establishments. Establishment detail routes to profile, menus, reviews, events, and posts. Location use per the constitution's Geolocation Privacy principle (consent-gated; feature works degraded with manual location entry).

## 4. Check-Ins, Reviews, and Rating Integrity (Phase 2A)

- **Check-in** — the core engagement mechanic: "I had [drink] at [establishment]" with optional rating, structured tasting notes, free-form note, and photo(s). Two-tap flow from an establishment page or scanned venue menu; retroactive check-ins supported; private or public per check-in. Check-ins extend the V1 personal tasting log (one journal across home and out-in-the-world consumption).
- **Wishlist:** "want to try" for drinks, products, and establishments — the passive counterpart to check-ins; feeds discovery and recommendations.
- **Structured tasting-note templates.** Review templates are curator-managed data, defined per product type and optionally specialized per family/style — grounded in industry-standard frameworks (WSET-style appearance/nose/palate/finish for wine and spirits; appearance/aroma/flavor/mouthfeel for beer; presentation/aroma/taste/balance for cocktails; all field sets to be curator-refined). Every structured field is optional; free-form text is always available. Structured data powers aggregate insights ("most reviewers note citrus"), filtering, and AI summaries. Templates are data — new types or refinements require no release.
- **Two rating subjects, never conflated:** the _drink/product_ (optionally at-this-establishment) and the _establishment_ itself.
- **Rating integrity — a headline differentiator:** geofence-verified check-ins earn a "verified visit" marker and higher weight in aggregates (weighting rules per the constitution's Trust, Verification, and Content Integrity principle); establishments can publicly **respond to reviews**; aggregate displays separate verified from unverified signal. Anti-brigading and anomaly detection hooks from day one.
- **Photos in reviews/check-ins** ride the V1 media model.

## 5. Menus — Including Menu-Recipe Fusion (Phase 2A)

- Establishments publish menus composed of: **platform recipes** (from their bar library), **beverage products** (spirits, beer, wine — Section 7), and free-text items. Multiple menus (main, seasonal, happy hour), each with pricing, sections, and per-item photo optionality.
- **Menu-recipe fusion — the capability no competitor can match:** menu items backed by real platform recipes automatically surface calculated ABV, allergen flags, flavor profile, and (venue opt-in) story/history to patrons. Patrons can tap-to-wishlist or check in directly from a menu item.
- Menu delivery: in-app, QR code, and web-embed. Menus are **brandable** (venue fonts/colors/layout within accessible templates) — a direct answer to competitors' template lock-in. No per-item-type caps or surcharges, ever.
- Printable/exportable via the V1 print pipeline. (Digital signage / TV menus: Phase 2B, engineered for reliability — a known competitor weakness.)

## 6. Publishing, Subscriptions, and Communications (Phase 2A: follow + inbox; 2B: full publishing suite)

- **Publishing:** establishments post news/blog entries, events (with dates/times), and specials (with active time windows that light up map filters like "happy hour near me now"). Posting volume gated by establishment tier; platform-enforced rate limits and moderation per the constitution's Communications and Notification Infrastructure and Trust, Verification, and Content Integrity principles.
- **Subscriptions:** patrons follow establishments. All establishment-to-subscriber communication lands in the **in-app inbox** by default; email and SMS/push require explicit per-channel patron opt-in, honoring per-establishment unsubscribe and global quiet settings. Alcohol-marketing compliance controls per the constitution's Regulated-Industry Posture principle.

## 7. Beverage Products and Producers (Phase 2B; producer claiming available in 2A)

- **Beverage product** — a generic, first-class rateable/consumable entity covering **spirits, beer, and wine** (extensible). Spirits products bind directly into the V1 ingredient hierarchy (a distillery's gin _is_ a product node under its class), so product ratings, inventory, recipes, and substitution logic all interconnect. Beer and wine products use the same pattern without requiring recipe integration. V1 bottle-recognition reuses for product identification/label scanning.
- **Producer portfolios:** distilleries, breweries, and wineries manage their product lineup — details, photos, where-to-buy links, availability notes.
- **Signature recipes:** a producer links its spirits to featured cocktail recipes (product→recipe relationships on the V1 relationship model), surfaced on the product page, the producer profile, and in patron discovery.
- **Tasting-room experience:** producer profiles carry tasting-room hours/details and participate fully in discovery, check-ins, reviews (product- and establishment-level), menus, and subscriptions.
- **Explicitly deferred:** beer _brewing recipes_ (a distinct domain; decide later whether to enter), and deep wine-vertical features (cellar management, vintage databases) — wine is a product and menu item here, not a conquered vertical.

## 8. Engagement Layer (Phase 2B)

Badges and achievements (styles explored, families tasted, establishments visited) and **passports/trails** (curated multi-venue journeys — city cocktail trails, distillery trails) with completion tracking; designed for tourism-board and guild partnerships. Tone: tasteful and craft-credible, not gimmicky. All gamification is opt-out-able. Per the constitution's Regulated-Industry Posture principle, every mechanic is **volume-neutral by design**: rewards recognize exploration, variety, knowledge, and places — never quantity or frequency of consumption; no drinking streaks; no same-session prompts or notifications that encourage another drink; trail/badge criteria are reviewed against this invariant before launch (an explicit anti-pattern set, learned from competitor criticism, is part of the design acceptance criteria).

## 9. Establishment Analytics (Phase 2B)

Three provenance-tagged data tiers (per the constitution's Analytics and External Data Ingestion principle), surfaced in dashboards ("top sellers this period," "trending in your area," subscriber growth, menu-view and check-in analytics):

1. **In-app signal** (all establishments, free): check-ins, menu views, wishlists, favorites — popularity analytics with zero integration burden.
2. **Manual/CSV import** of sales data mapped to menu items/recipes.
3. **POS integration** (premium): read-only sales ingestion through the Clean Architecture adapter layer; **Toast and Square adapters first** (market leaders with public/partner APIs), others as adapters over time; items mapped to platform recipes/products via V1's stable identifiers. The platform remains analytics-on-top — never a POS, never the financial system of record.

## 10. Trust, Safety, and Compliance (Phase 2A, non-negotiable at network launch)

Legal-drinking-age gating on all consumer social/discovery features (jurisdiction-aware): account DOB for registered users, the DOB-entry affirmation gate for guests (checked, never stored). App-store age-rating compliance (Apple/Google alcohol-content ratings) is treated as a parallel launch obligation alongside statutory requirements. Responsible-consumption messaging; review/content moderation tooling and reporting flows; establishment-response and dispute workflows; anti-spam enforcement in communications; location-privacy behavior per the constitution's Geolocation Privacy principle.

## 11. Phasing Summary

- **V1 (already specified, ships first):** the recipe platform — revenue from Enthusiast and Pro subscriptions begins here.
- **Phase 2A — network foundation:** tiers activation, establishments + claiming/verification, discovery map, check-ins/reviews/templates/integrity, menus with fusion, follow + in-app inbox, trust & compliance baseline.
- **Phase 2B — network depth:** producer portfolios and beverage products (beer/wine/spirits), signature recipes, full publishing + multi-channel communications, analytics tiers + Toast/Square POS adapters, badges/passports/trails, digital signage.
- **Deferred beyond Phase 2:** brewing recipes; comment threads and social feeds; reservations (integrate, don't build, if ever); retailer API ordering (per V1 posture); staff training mode and venue multi-user (activates with Venue tier maturity — when activated, it rides the V1 scope-aware authorization model: the venue owner invites staff and assigns venue-scoped roles with granular view/edit/delete/publish permissions on the bar's library and menus; this is configuration on the existing model, not new authorization design).

---

_Assumptions encoded (veto any):_ multi-location establishments modeled from the start; check-ins default private with easy public toggle (privacy-first for an alcohol app); verified-visit weighting values determined during design, documented and versioned; producer claiming opens in 2A (presence) even though portfolio tooling lands in 2B; Toast/Square adapter order may swap based on partnership access at build time.
