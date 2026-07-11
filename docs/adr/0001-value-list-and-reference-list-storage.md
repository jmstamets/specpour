# ADR-0001: Storage convention for list-valued entity fields

**Status**: Accepted
**Date**: 2026-07-11
**Decided during**: Phase 3 (US1) sub-checkpoint 1, before building the Catalog/
Ingredients/Equipment/Glossary domain models, all of which have several list-valued
fields per data-model.md.

## Context

The only precedent in the codebase for a list-valued column was
`Authorization.PlatformRole.PermissionSet`, stored via
`HasConversion(v => string.Join(',', v), v => v.Split(','))` plus a `ValueComparer`.
That's safe there because permission keys are a closed, machine-controlled
vocabulary (`"curation.publish"`, never containing a comma).

Phase 3's modules introduce three different shapes of "list" that this one pattern
does not safely cover:

1. **Row-owned scalar value lists** — free text with no shared identity, e.g.
   `Recipe.AlternateNames`, `Recipe.Garnishes`, `Ingredient.Sources`,
   `GlossaryTerm.Definitions`. A curator-entered value containing a comma
   (a very plausible free-text input) would silently corrupt neighboring list
   entries under the comma-join convention.
2. **References to other entities** — `Recipe.CategoryIds`, `Recipe.GlassewareIds`,
   `Recipe.EquipmentIds`, `GlossaryTerm`'s links to recipes/ingredients/equipment.
   Storing these as `Guid[]` (whether comma-joined or a native array) loses
   relational structure: no per-relationship indexing, no way to query "what
   references this row" from the other side, no place to hang a relationship
   attribute (e.g. a differentiator note) without another table anyway.
3. **Tags** (`Recipe.Tags`, FR-019/FR-050) — free-form today, but explicitly required
   to support faceted filtering and (per FR-028's cross-discovery pattern for
   Glossary) is exactly the kind of field that benefits from being a shared,
   deduplicated vocabulary rather than repeated free text.

## Decision

1. **Row-owned scalar value lists** are stored as native PostgreSQL array columns
   (`text[]`) via Npgsql's EF Core provider (`IReadOnlyList<string>` / `string[]`
   property, no `HasConversion` needed). No delimiter, no corruption risk.
2. **References to other entities** are always modeled as real join tables with
   one row per relationship (e.g. `RecipeCategory(RecipeId, CategoryId)`), never as
   an array of IDs on the owning row. Where both sides live in the same module
   schema, the join table carries a real FK constraint. Where the reference crosses
   a module schema boundary (e.g. `Recipe.EquipmentIds` pointing into the
   `equipment` schema), the column is a plain indexed `Guid` with **no** FK
   constraint, per constitution Principle III (modules never take a hard dependency
   on another module's schema) — this mirrors the existing
   `RoleGrant.UserId`/`GrantedBy` precedent, which already crosses into `identity`
   the same way.
3. **Tags** are promoted to a first-class `Tag` entity plus a join table
   (`RecipeTag`), rather than a `text[]` column, so the vocabulary is deduplicated
   and queryable from either direction. Scoped to the `catalog` schema for now,
   since Recipe is the only V1 consumer; a future module that needs tags gets its
   own scoped tag table rather than a shared cross-schema one (same Principle III
   reasoning as #2).
4. **Retrofit**: `Authorization.PlatformRole.PermissionSet` migrates from the
   comma-join conversion to a native `text[]` column (case #1), via a new
   `AuthorizationDbContext` migration. `PermissionSet`'s values happen to be safe
   under the old scheme, but there's no reason to keep two different list-storage
   idioms in the codebase, and the array column is simpler code besides.

## Consequences

- More tables than a naive "array of IDs" design (a join table per relationship,
  a lookup table for each curator-managed taxonomy: `Family`, `Category`,
  `FlavorProfile`, `Tag`, `IngredientCategory`). This is the intended trade — real
  referential structure over compactness.
- Cross-schema join tables cannot enforce referential integrity at the database
  level (consistent with every other cross-module reference in the codebase);
  orphaned references are prevented at the application layer (e.g. publish-time
  validation, FR-008a's cascade check) rather than by a DB constraint.
- Every future module with a list-valued or reference-valued field should follow
  this same three-way split rather than reintroducing a delimiter-joined string or
  an array-of-IDs column.
