Feature: Author a Personal Library
  As a signed-in user
  I want to create and manage private recipes and ingredients (including house-made
  ingredients) and, as a professional user, a venue-scoped bar library
  So that I have my own authoring workspace distinct from the curated core library

  T056 (Phase 5 entry, US3, spec.md scenarios 1-4). Failing first per constitution
  Principle I (ATDD, NON-NEGOTIABLE): none of the author CRUD endpoints these
  scenarios call (POST /recipes, POST /ingredients, POST /venues) are mapped yet —
  T058/T059/T061 build them. Every scenario below is expected RED until then.

  Scenario: 1 - A signed-in user creates a private recipe with full detail (spec.md scenario 1)
    Given a signed-in user
    And a curated ingredient the user can reference in a recipe line
    When the user creates a recipe with a primary name, alternate names, ingredient lines, instructions, and taxonomy
    Then the recipe is saved and appears in the user's personal library
    And the recipe is not returned by an anonymous browse of the public catalog

  Scenario: 2 - A house-made ingredient behaves as an ingredient everywhere it's used (spec.md scenario 2)
    Given a signed-in user
    And a curated ingredient the user can reference in a recipe line
    When the user defines "House Grenadine" as a house-made ingredient with a component recipe, yield, shelf life, and storage instructions
    Then the house-made ingredient is saved in the user's personal library
    And the house-made ingredient can be used as an ingredient line in a new recipe

  Scenario: 3 - A professional user maintains a bar library scoped to a venue (spec.md scenario 3)
    Given a signed-in user
    And a curated ingredient the user can reference in a recipe line
    When the user creates a venue with a name, address, coordinates, and external references
    Then the venue is saved under the user's ownership
    And the user can create a recipe scoped to that venue's bar library

  Scenario: 4 - A private recipe never appears for another user (spec.md scenario 4)
    Given a signed-in user
    And a curated ingredient the user can reference in a recipe line
    And that user has created a private recipe
    And a second, different signed-in user
    When the second user searches for the first user's private recipe by name
    Then the private recipe never appears in the second user's search results
    When the second user browses the first user's personal library directly
    Then the private recipe is not accessible to the second user
