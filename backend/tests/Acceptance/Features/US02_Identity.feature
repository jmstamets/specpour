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

  Scenario: 9 - A user can enroll TOTP MFA and must use it to sign in afterward
    Given a registered adult user
    When the user enrolls TOTP multi-factor authentication
    Then MFA is enabled for the account
    And the enrollment secret is never shown again
    When the user signs in with their password
    Then the sign-in requires an MFA code
    When the user completes sign-in with a valid MFA code
    Then the sign-in succeeds

  Scenario: 10 - A user can disable TOTP MFA
    Given a registered adult user with MFA enabled
    When the user disables MFA
    Then MFA is no longer enabled for the account

  Scenario: 11 - A user who loses their MFA device can sign in with a backup code (T163, spec.md scenario 10)
    Given a registered adult user with MFA enabled
    When the user signs in with their password
    And the user completes sign-in with a valid backup code
    Then the sign-in succeeds

  Scenario: 12 - A used backup code cannot be reused (T163)
    Given a registered adult user with MFA enabled
    When the user signs in with their password
    And the user completes sign-in with a valid backup code
    Then the sign-in succeeds
    When the user signs in with their password
    And the user completes sign-in with the same backup code again
    Then the sign-in is rejected

  Scenario: 13 - Regenerating backup codes invalidates the prior set (T163)
    Given a registered adult user with MFA enabled
    When the user regenerates their backup codes
    Then a fresh set of backup codes is issued
    When the user signs in with their password
    And the user completes sign-in with the original backup code
    Then the sign-in is rejected

  Scenario: 14 - Password recovery never bypasses an enabled MFA gate (T163, FR-001a, spec.md scenario 9)
    Given a registered adult user with MFA enabled
    When the user resets their password via account recovery
    And the user signs in with their new password
    Then the sign-in requires an MFA code

  Scenario: 15 - A user can list and revoke active sessions (T051, spec.md scenario 3)
    Given a registered adult user
    When the user signs in from two devices
    Then both sessions appear in the session list
    When the user revokes the first session
    Then only the second session remains active
    And the first device's session can no longer be refreshed

  Scenario: 20 - The session list marks exactly the caller's own session as current (T188, FR-001b)
    Given a registered adult user
    When the user signs in from two devices
    Then exactly one listed session is marked as the current device
    And each device sees a different session as its own current device

  Scenario: 18 - A redeemed refresh token cannot be reused (T177, ADR-0005)
    Given a registered adult user
    When the user acquires a refresh token
    And the refresh token is redeemed once
    And time passes beyond the refresh-token reuse leeway
    Then the second redemption of the same refresh token is rejected
    And the session is no longer active

  Scenario: 19 - A session older than the absolute cap must re-authenticate (T177, ADR-0005)
    Given a registered adult user
    When the user acquires a refresh token
    And the user refreshes the session every 10 days until the absolute cap is reached
    Then the refresh token is rejected
    And the session is no longer active

  Scenario: 16 - A user can deactivate and reactivate their account (T052, FR-003)
    Given a registered adult user
    When the user deactivates their account
    Then the account is deactivated
    And the session can no longer be refreshed
    When the user reactivates their account
    Then the account is active again

  Scenario: 17 - A deactivated account is warned before its grace period expires, then automatically deleted (T052, FR-003)
    Given a registered adult user
    When the user deactivates their account
    And time passes to the deactivation warning window
    Then the user receives a deactivation-expiry-warning notification
    When time passes past the deactivation grace period
    Then the account no longer exists
