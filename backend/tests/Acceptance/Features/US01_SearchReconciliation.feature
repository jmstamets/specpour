Feature: US1 - Search reconciliation (T155, amended FR-049/FR-050/FR-014a)
  Backend half of the 2026-07-12 human review reconciling specification-statement.md
  §13/§2: a recipe's search document must include ingredient names (so searching an
  ingredient surfaces recipes using it, not only recipes named for it), a
  hierarchy-aware "uses:<ingredient>" facet on GET /recipes and /search, and the
  FR-014a ingredient->recipes bidirectional surface (GET /ingredients/{id}/recipes).
  Architecture (event-maintained search document) approved by John, recorded as
  ADR-0002; this feature covers its riders — the rename-refresh acceptance test and
  the "uses" facet's hierarchy-aware matching. Step wording throughout is
  deliberately distinct from US01DiscoverRecipesSteps' phrasing (the Reqnroll
  cross-binding-state trap — identical step text defined in two [Binding] classes
  either throws AmbiguousBindingException or silently reads the wrong class's state).

  Background:
    Given the curated library contains a Rum ingredient class with a Jamaican Rum child, a T155 Mai Tai recipe using it, and a T155 Old Fashioned recipe using an unrelated Bourbon

  Scenario: 1 - A recipe's search document includes its ingredient names, not only its own name
    When I look up "Jamaican" in the recipe search
    Then the matching recipes include "T155 Mai Tai"

  Scenario: 2 - The hierarchy-aware "uses" facet on GET /recipes matches a class-level ingredient's descendants
    When I browse recipes that use the ingredient "Rum (T155)"
    Then only the recipe "T155 Mai Tai" is browsed

  Scenario: 3 - The hierarchy-aware "uses" facet on GET /search narrows recipe results
    When I look up "T155" in the recipe search filtered to ingredient "Rum (T155)"
    Then the matching recipes include "T155 Mai Tai"
    And the matching recipes exclude "T155 Old Fashioned"

  Scenario: 4 - FR-014a: an ingredient entry surfaces the recipes that use it, hierarchy-aware
    When I look up the recipes that use ingredient "Rum (T155)"
    Then the ingredient's recipe usage includes "T155 Mai Tai"
    And the ingredient's recipe usage excludes "T155 Old Fashioned"

  Scenario: 5 - Renaming an ingredient refreshes dependent recipes' search documents (ADR-0002 rider)
    When I rename the ingredient "Ginger Liqueur (T155)" to "Elderflower Liqueur (T155)"
    Then eventually looking up "Elderflower" in the recipe search includes "T155 Mule"
    And eventually looking up "Ginger Liqueur" in the recipe search excludes "T155 Mule"
