Feature: Track Inventory and Ask "What Can I Make?"
  As a signed-in user
  I want to record what I own and see which recipes I can make, including near-misses
  So that I know what's ready to pour tonight and what to shop for

  T064 (Phase 6 entry, US4, spec.md scenarios 1-4). Failing first per constitution
  Principle I (ATDD, NON-NEGOTIABLE): none of the inventory endpoints these scenarios
  call (POST/GET/DELETE /inventory/items, POST /inventory/recognize,
  GET /inventory/makeable) are mapped yet — T066/T067/T069 build them. Every scenario
  below is expected RED until then.

  Match-quality ladder (docs/specification-statement.md §2, 2026-07-19 revision):
  exact-product > class-satisfied > substitution > missing. A recipe's own reported
  match quality is the LOOSEST quality among its satisfied lines (the one match that
  needed the most help) — an extensible field from day one so T201's facet-partial
  value slots in later without a shape change.

  Ratified (John, 2026-07-19): the recipe-level match quality is a DERIVED SUMMARY,
  never independent truth — every recipe entry also carries its own per-line "lines"
  array (requirement as stated, that line's own match quality, and the inventory item
  or substitution satisfying it, null when missing). T067 computes lines first and
  folds to the aggregate; every downstream consumer (near-miss surfacing, substitution
  display naming the held item, shopping's cheapest-completion logic, T201's future
  facet-partial grade) needs this line-level detail, so it belongs in the shape from
  day one rather than as a later breaking change.

  Every read/write path below also carries its own both-directions privacy proof
  (owner/non-owner/guest) per Phase 6 entry guidance: inventory has no public/curator
  variant at all, ever, unlike recipes/ingredients/equipment/venues.

  Scenario: 1 - A user adds inventory by manual entry, and photo recognition degrades to a pre-filled manual form when it can't identify the bottle (spec.md scenario 1)
    Given an inventory-tracking signed-in user
    And a curated ingredient hierarchy of "Beefeater" (product) under "London Dry Gin" (class)
    When the user adds "Beefeater" to inventory by manual entry
    Then the item is saved in the user's inventory
    When the user submits an unrecognizable bottle photo for recognition
    Then the recognition response degrades to a pre-filled manual entry form rather than failing

  Scenario: 2 - A held product satisfies a recipe that specifies its class (spec.md scenario 2)
    Given an inventory-tracking signed-in user
    And a curated ingredient hierarchy of "Beefeater" (product) under "London Dry Gin" (class)
    And the user has "Beefeater" in inventory
    And the user has a private recipe requiring "London Dry Gin" at the class level
    When the user asks what they can make
    Then the recipe is listed as makeable with match quality "class-satisfied"
    And the recipe's requirement for "London Dry Gin" is satisfied by the held "Beefeater" item

  Scenario: 3 - A near-miss recipe names its missing ingredient with a substitution suggestion, and is not also listed as fully makeable (spec.md scenario 3)
    Given an inventory-tracking signed-in user
    And a curated ingredient hierarchy of "Beefeater" (product) under "London Dry Gin" (class)
    And the user has "Beefeater" in inventory
    And the user has a private recipe requiring "London Dry Gin" and a second ingredient the user does not own
    When the user asks what they can make
    Then the recipe is listed as a near-miss naming the missing ingredient
    And the recipe does not also appear in the fully-makeable list
    And the near-miss recipe's lines show the "London Dry Gin" requirement satisfied by the held "Beefeater" item and the second requirement missing

  Scenario: 4 - An inventory item displays its tracked quantity and bottle size (spec.md scenario 4)
    Given an inventory-tracking signed-in user
    And a curated ingredient hierarchy of "Beefeater" (product) under "London Dry Gin" (class)
    And the user has "Beefeater" in inventory with quantity 750 and bottle size "750ml"
    When the user views their inventory
    Then the item displays the tracked quantity and bottle size

  Scenario: 5 - An empty inventory does not near-miss every recipe indiscriminately (T064 edge case: near-miss thresholds don't list everything)
    Given an inventory-tracking signed-in user
    And a curated ingredient hierarchy of "Beefeater" (product) under "London Dry Gin" (class)
    And the user has a private recipe requiring "London Dry Gin" and a second ingredient the user does not own
    And the user's inventory is empty
    When the user asks what they can make
    Then the recipe does not appear in the fully-makeable list
    And the recipe does not appear in the near-miss list

  Scenario: 6 - Inventory is invisible to a second user, both reading and writing
    Given an inventory-tracking signed-in user
    And a curated ingredient hierarchy of "Beefeater" (product) under "London Dry Gin" (class)
    And the user has "Beefeater" in inventory
    And a second, unrelated signed-in user
    When the second user requests the first user's inventory item directly
    Then the item is not accessible to the second user
    When the second user attempts to delete the first user's inventory item
    Then the deletion is not permitted for the second user

  Scenario: 7 - Inventory is invisible to a guest
    When an anonymous guest requests the inventory list
    Then the request is rejected as unauthenticated
    When an anonymous guest requests what can be made
    Then the request is rejected as unauthenticated

  Scenario: 8 - Inventory items never appear in search results
    Given an inventory-tracking signed-in user
    And a curated ingredient hierarchy of "Beefeater" (product) under "London Dry Gin" (class)
    And the user has "Beefeater" in inventory
    When the user searches for "Beefeater"
    Then the search results do not include an inventory entity type
