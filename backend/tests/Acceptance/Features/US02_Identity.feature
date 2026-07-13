Feature: US2 - Create an account and manage identity
  spec.md User Story 2, acceptance scenarios 1-8. T045: failing first — registration
  (T047), age predicates (T048), social sign-in (T049), MFA/recovery (T050),
  sessions (T051), lifecycle (T052), and export/deletion (T053) land across Phase
  4's sub-checkpoints, so several scenarios below are expected to stay red until
  their sub-checkpoint lands; each Then step's own comment says which task it's
  gated on. Step wording is its own vocabulary, distinct from every other feature
  file's [Binding] class (the Reqnroll cross-binding-state trap).

  Scenario: 1 - Registering with email/password captures and encrypts date of birth
    When a visitor registers with a valid adult date of birth
    Then the account is created
    And the stored date of birth is encrypted, never the plaintext value
    And the registration response never contains a date of birth

  Scenario: 2 - An underage registration attempt is rejected without persisting anything
    When a visitor registers with an underage date of birth
    Then the registration is rejected
    And no account exists for that attempt

  Scenario: 3 - A registered user can sign in
    Given a registered adult user
    When the user signs in with their password
    Then the sign-in succeeds

  Scenario: 4 - A user who lost their credentials can run account recovery
    Given a registered adult user
    When the user requests account recovery
    Then the recovery request is accepted

  Scenario: 5 - A user can export their data before deleting their account
    Given a registered adult user
    When the user requests their data export
    Then the export includes their date of birth

  Scenario: 6 - Deleting an account anonymizes public attribution
    Given a registered adult user
    When the user requests account deletion
    Then the account is deleted

  Scenario: 7 - Every new user receives the default tier via configuration
    Given a registered adult user
    When the user requests their entitlements
    Then the entitlements reflect the default tier

  Scenario: 8 - Age information is exposed only as an audited derived predicate
    Given a registered adult user
    When a feature checks whether the user is of legal drinking age
    Then the predicate check succeeds without exposing the raw date of birth
    And the predicate check is audit-logged
