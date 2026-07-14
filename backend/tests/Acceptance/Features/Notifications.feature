Feature: Notifications - inbox and channel preferences
  T151 (FR-040a): the in-app inbox is the always-on notification channel; email
  is a per-user opt-in alert channel. Step wording is its own vocabulary,
  distinct from every other feature file's [Binding] class (the Reqnroll
  cross-binding-state trap).

  Scenario: 1 - A signed-up user's channel preferences default to opted-out
    Given a signed-up user
    When the signed-up user fetches their channel preferences
    Then both notification channels are present and opted out

  Scenario: 2 - A signed-up user can opt into the email channel
    Given a signed-up user
    When the signed-up user opts into the email channel
    Then the signed-up user's channel preferences show email opted in

  Scenario: 3 - Updating an unrecognized channel is rejected
    Given a signed-up user
    When the signed-up user tries to update an unrecognized channel
    Then the channel update attempt is rejected

  Scenario: 4 - A signed-up user can mark an inbox message as read
    Given a signed-up user
    And an inbox message exists for the signed-up user
    When the signed-up user marks that inbox message as read
    Then the inbox message shows as read

  Scenario: 5 - Marking an already-read inbox message as read again does not change its read time
    Given a signed-up user
    And an inbox message exists for the signed-up user
    When the signed-up user marks that inbox message as read
    And notification time passes
    And the signed-up user marks that inbox message as read again
    Then the inbox message's read time is unchanged from the first mark
