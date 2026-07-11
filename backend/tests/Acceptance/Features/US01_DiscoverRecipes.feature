Feature: US1 - Discover and follow curated recipes
  spec.md User Story 1, scenarios 1-7 (scenario 8's responsible-consumption
  messaging is covered separately by T150's extension of this feature). Failing
  first (T030): GET /recipes, /recipes/{id}, /concepts/{id}, and /search don't
  exist yet (they land in T037/T038), so every scenario below is expected to fail
  until then. Scenario 7 is the one exception — the anonymous age-gate flow it
  exercises was already built in Phase 2 (T144), so it's expected to pass today;
  it's included here because spec.md scopes it as part of US1, not because it's
  new in this checkpoint.

  Background:
    Given the curated library contains the Mai Tai, with an egg-white Flip variant, and a Daiquiri concept with variants

  Scenario: 1 - Search finds a curated recipe by primary or alternate name and opens to its full detail
    When I search "Mai Tai"
    Then the search results include a recipe named "Mai Tai"
    When I request the found recipe
    Then the recipe response includes the ordered ingredient lines, instructions, garnish, glassware, ice spec, equipment, flavor profile, creator "Trader Vic", and history

  Scenario: 2 - A recipe containing egg white displays a prominent, automatically rolled-up allergen flag
    When I request the egg-white recipe
    Then the recipe response includes the rolled-up allergen "egg"

  Scenario: 3 - A concept page lists each variant with a differentiator and routes to its full recipe
    When I request the Daiquiri concept page
    Then the concept response lists each variant with a differentiator and a recipe id

  Scenario: 4 - Every recipe shows calculated ABV and standard drinks per serving
    When I request the Mai Tai recipe
    Then the recipe response includes a calculated ABV and standard drinks per serving

  Scenario: 5 - Faceted filters return only matching recipes
    When I browse recipes filtered by family "family.flip"
    Then only recipes in the "family.flip" family are returned

  Scenario: 6 - Guest visitors can browse and search without an account
    When I request the recipe list, the concept list, the ingredient list, the equipment list, and the glossary term list anonymously
    Then every anonymous request succeeds

  Scenario: 7 - An unauthenticated visitor is presented a jurisdiction-aware age gate
    When I request the age gate for the "registration" surface
    Then the age gate responds successfully
    And the age gate response includes a legal drinking age
