# API Contract Surface: `/api/v1` (REST over HTTPS, OpenAPI 3.1)

Contract-first per constitution Principle II: the OpenAPI documents authored from this
surface are the source of truth, reviewed before implementation on either side. The
Dart client is generated from them. This document enumerates the v1 surface by module;
the bundled OpenAPI root lives at `contracts/openapi/openapi.yaml` once authored
(authoring the per-path documents is an implementation task — see tasks.md).

Global conventions:
- Auth: OAuth2/OIDC bearer tokens from the identity module; anonymous (guest) access
  permitted on public read endpoints, rate-limited (FR-004b).
- Errors: RFC 9457 problem+json. Pagination: cursor-based (`cursor`, `limit`).
- All AI-generated content fields carry `aiGenerated: true` (Principle V).
- Entity IDs are stable UUIDv7 strings (FR-059).
- Breaking changes require `/api/v2` + deprecation window.
- Sensitive PII: no schema outside `GET /me/export` may contain a raw DOB field —
  registration accepts DOB as input (rejecting underage without retention, FR-002c);
  every other surface exposes only derived age predicates or verified status
  (FR-002b, SC-017). Contract tests enforce this invariant.

## identity
| Method & Path | Purpose | Auth |
|---|---|---|
| POST `/auth/register` | Email/password registration (captures DOB) | anon |
| POST `/auth/token` / `/auth/refresh` | Token issuance (OIDC code + refresh) | anon |
| GET `/auth/external/providers` | Which social providers are configured — names only, no secrets (T173) | anon |
| GET `/auth/external/{provider}` (+callback) | Social sign-in | anon |
| POST `/auth/recovery` (+confirm) | Secure account recovery | anon |
| GET/POST/DELETE `/me/mfa` | TOTP MFA enroll/disable | user |
| GET `/me/sessions` / DELETE `/me/sessions/{id}` | Device/session management | user |
| POST `/me/sessions/sign-out-everywhere` | Revoke all active sessions in one action (FR-001b) — task filed near T166, not yet implemented | user |
| POST `/me/deactivate` / POST `/me/reactivate` | Lifecycle (grace period) | user |
| GET `/me/export` | Full personal data export (SC-015) | user |
| DELETE `/me` | Account deletion | user |
| GET/PATCH `/me/preferences` | Units, locale, channel opt-ins | user |

## authorization & platform administration (staff endpoints: web client only, FR-066; every mutation audit-logged, FR-065)
| Method & Path | Purpose | Auth |
|---|---|---|
| GET `/me/entitlements` | Capability manifest for UI shaping | user/guest |
| GET/PUT `/admin/tiers` `/admin/tiers/{id}/capabilities` | Tier & capability config | super admin |
| GET/PUT `/admin/roles` | Platform role catalog (config data, FR-061) | super admin |
| GET/POST/DELETE `/admin/role-grants` | (user, role, scope) grants; platform-scope grants carry a Super Admin approval step (FR-062) | super admin |
| GET `/admin/audit-log` | Append-only audit review with filters (FR-062/FR-065) | super admin |
| GET `/admin/accounts?query=…` | Account search, non-sensitive state (Support, FR-061) | support+ |
| POST `/admin/accounts/{id}/suspend` / `/reinstate` | Account intervention (audit-logged) | support+ |
| POST `/admin/accounts/{id}/fulfill-export` / `/fulfill-deletion` | Operational counterpart of lifecycle rights (FR-062) | support+ |
| POST `/admin/accounts/{id}/trigger-reset` | Assisted credential reset | support+ |

Note: curation consoles (`/admin/recipes|ingredients|equipment|glossary|concepts|taxonomy`)
and the moderation queue are listed under their owning modules; all are staff-role-gated
per the FR-061 catalog and audit-logged. MFA is mandatory at token issuance for any
platform-scoped role holder (FR-064). First Super Admin exists only via deployment
seeding; no signup path yields a platform role (FR-063).

## catalog (recipes & concept pages)
| Method & Path | Purpose | Auth |
|---|---|---|
| GET `/recipes` | Search/browse with all facets (FR-050): family, category, tags, flavor, glassware, ice, equipment, allergen-exclude, ABV range, rating, source, makeable | guest+ |
| GET `/recipes/{id}` | Full recipe incl. derived ABV/standard drinks/allergens/cost | guest+ (public/core), owner (private) |
| POST/PUT/DELETE `/recipes/{id}` | Author CRUD (personal/bar library) | user |
| POST `/recipes/{id}/publish` | Publish (returns FR-008a cascade manifest for consent; FR-008b first-publish warning ack) | user |
| POST `/recipes/{id}/unpublish` | Owner unpublish toggle (FR-008b) | owner |
| POST `/recipes/{id}/copy` | Copy core/public recipe with provenance (FR-008) | user |
| GET `/recipes/{id}/scale?servings=N` | Scaled output, batched vs at-service separation | guest+ |
| POST `/recipes/{id}/batch` | Dilution-aware batch calculation (FR-034); save → BatchResult | user |
| GET `/recipes/{id}/costing` | Pour cost, breakdown, pour-cost %, suggested price (FR-035) | user |
| GET `/concepts` / GET `/concepts/{id}` | Concept pages with variants (FR-021) | guest+ |
| POST `/concepts/{id}/variants` | Attach own published variant (moderated) | user |
| CRUD `/admin/concepts` `/admin/taxonomy/*` | Curator concept/taxonomy management | curator role |

## ingredients
| GET `/ingredients` (+`/{id}`) | Hierarchy-aware browse/search | guest+ |
|---|---|---|
| POST/PUT/DELETE `/ingredients/{id}` | Author CRUD incl. house-made definition (FR-017) | user |
| GET `/ingredients/{id}/substitutions` | Curated + hierarchy-implied subs (FR-013) | guest+ |
| CRUD `/admin/ingredients` `/admin/substitutions` `/admin/categories` | Curator management | curator role |
| PUT `/me/ingredient-prices/{ingredientId}` | Bottle size + price (costing input) | user |

## equipment
| GET `/equipment` (+`/{id}`) | Browse with recipe/article links (FR-024) | guest+ |
|---|---|---|
| POST/PUT/DELETE `/equipment/{id}` | User additions (private) | user |
| CRUD `/admin/equipment` | Curator management | curator role |

## glossary
| GET `/glossary/terms` (+`/{id}`), `/glossary/articles` (+`/{id}`) | Terms (numbered definitions) & articles | guest+ |
|---|---|---|
| GET `/glossary/autolink?context=…` | Auto-link resolution for a content page (FR-027) | guest+ |
| CRUD `/admin/glossary/*` + `/admin/glossary/link-overrides` | Curator authoring, suppress/force | curator role |

## community
| POST `/ratings` | Append rating event (subject-agnostic; latest-per-user projection) | user |
|---|---|---|
| GET `/ratings/mine?subject=…` | User's current rating (editable display) | user |
| GET `/moderation/queue` / POST `/moderation/actions` | Flag/unpublish (FR-010) | curator role |

## inventory
| GET/POST/PUT/DELETE `/inventory/items` | Product- or class-level items, quantity (FR-029) | user |
|---|---|---|
| POST `/inventory/recognize` | Label photo → candidate product (AI; degrade to pre-filled form) (FR-030) | user |
| GET `/inventory/makeable` | "What can I make?" + near-misses + substitutions (FR-031) | user |

## shopping
| POST `/shopping-lists` | From recipes / menu+guest-count / prep list (FR-036) | user |
|---|---|---|
| GET `/shopping-lists/{id}` / POST `/{id}/export` | View, export/share (FR-038) | user |
| GET `/shopping/unlock-analysis` | Leverage-ranked recommendations (FR-037) | user |

## prep
| CRUD `/prep-lists` (+items) | Assignment-ready checklists (FR-039) | user |
|---|---|---|
| POST `/prep-items/{id}/complete` | Made-on date; snapshot composition/cost | user |
| GET `/prep/expiring` | Expiring/expired preps (FR-040) | user |

## collections & menus
| CRUD `/collections` (+pin) | Groupings; per-account offline pins (FR-052) | user |
|---|---|---|
| POST `/collections/{id}/promote-to-menu`; CRUD `/menus` | Priced menus (FR-041) | user (pro) |
| GET `/print/{artifact}/{id}` | Print/export layouts: recipe card, spec sheet, menu, prep list, shopping list (FR-042) | user |

## ai
| POST `/ai/chat` | Grounded chat assistant (FR-043) | user |
|---|---|---|
| GET `/ai/insights?page=…` | Contextual insight blocks (FR-044) | guest+ |
| POST `/ai/authoring-assist` | Draft generation (human review before publish) (FR-045) | curator/user |
| GET `/discovery/similar?recipe=…` | "If you like X, try Y" (deterministic fallback) (FR-046) | user |
| GET/PUT `/me/ai-toggles`, GET/PUT `/admin/ai-toggles` | Per-feature toggles (FR-047) | user/admin |

## tasting log
| CRUD `/tasting-log/entries` | Private made-it history (FR-048) | user |

## search
| GET `/search?q=…&facets…` | Full-text across recipes/ingredients/equipment/glossary via search port (FR-049) | guest+ |

## notifications (thin slice)
| GET `/inbox` / POST `/inbox/{id}/read` | In-app inbox (FR-040a) | user |
|---|---|---|
| GET/PUT `/me/channels` | Channel opt-in preferences (email active in V1; push preference modeled, delivery Phase 2 per FR-040a) | user |

## compliance
| Method & Path | Purpose | Auth |
|---|---|---|
| GET `/compliance/age-gate?surface=…` | Per-surface gate config + jurisdiction rule (coarse geo; strictest default) (FR-002a) | anon |
| GET `/compliance/messaging?surface=…` | Jurisdiction-configured responsible-consumption message + placement per surface class (FR-067) | anon |
| GET `/compliance/support-resources` | Jurisdiction-aware support resources (helplines/organizations) (FR-069) | anon |

## venues
| CRUD `/venues` | Multi-venue ownership, bar-library scoping | user (pro) |

## sync (offline protocol, versioned — R9)
| POST `/sync/handshake` | Protocol version + device profile registration | user |
|---|---|---|
| GET `/sync/changes?cursor=…` | Change-log pull filtered by profile tier + pinned collections | user |
| POST `/sync/push` | User-authored edit queue; conflict responses drive merge-or-prompt (FR-053) | user |

## seo (guest web surface — R18)
| GET `/pages/recipes/{slug}` etc. | Crawlable HTML projections of public content (FR-004b) | anon |
