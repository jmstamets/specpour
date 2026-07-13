# ADR-0002: Event-maintained recipe search document

**Status**: Implemented (architecture approved by John 2026-07-12; T155 landed
2026-07-12 — see tasks.md's T155 entry for implementation notes, including the
outbox-wiring gap this work surfaced and fixed across all 10 modules)
**Date**: 2026-07-12
**Decided during**: Phase 3 human review reconciling amended FR-049
(specification-statement.md §13 search-document composition).

## Context

Amended FR-049 requires a recipe's search document to include its ingredient
names (at the referenced hierarchy level), garnishes, and description/history —
so searching "rum" surfaces recipes *using* rum, not only recipes named for it.

The current recipe search column (`catalog."Recipes"."SearchVector"`, ADR-noted
in T013/T141's "tsvector columns live in owning-module schemas, maintained via
events") is a PostgreSQL `GENERATED ALWAYS ... STORED` column over
`PrimaryName` + `AlternateNames`. A generated column **cannot reference another
table**, let alone another module's schema — ingredient names live in
`ingredients."Ingredients"`, and a cross-module generated column (or trigger
reading across schemas) would violate the module-owns-schema boundary
(constitution Principle III).

## Decision

Replace the generated column with an **event-maintained denormalized search
document** on the recipe row, refreshed through the existing outbox dispatcher:

- Catalog refreshes a recipe's search document when the recipe or its ingredient
  lines change (same-module, synchronous with the write or via its own event).
- Ingredients publishes an outbox event on ingredient rename; a Catalog handler
  refreshes the search documents of recipes referencing that ingredient
  (resolving names through the existing Contracts lookup port, never a
  cross-schema query).
- **Backfill**: shipping the event-maintained document includes an idempotent,
  re-runnable backfill of all existing recipe rows — events only cover changes
  going forward.
- **Acceptance test** (T155 rider): rename an ingredient → recipes using it
  become searchable under the new name and stop matching the old one.

## Eventual-consistency window

The search document is **eventually consistent**: after an ingredient rename,
recipe search results may be briefly stale until the outbox event dispatches and
the refresh handler runs (bounded by outbox dispatch latency, seconds in
practice). John explicitly accepted this window ("brief staleness after rename is
acceptable"). Recipe-detail reads are unaffected — they resolve ingredient names
live through the lookup port; only full-text *search matching* lags.

## Alternatives considered

- Cross-schema generated column / trigger: violates module-owns-schema
  (Principle III); rejected.
- Search-time join across schemas in the FTS adapter: pushes the boundary
  violation into query composition and defeats index-backed ranking; rejected.
- Dedicated search engine now: R8 reserved that as a future adapter swap behind
  ISearchPort; unnecessary for V1 scale.
