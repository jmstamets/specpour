Feature: Acceptance harness smoke test
  T026's own proof that the composed host + Testcontainers PostgreSQL actually work
  end-to-end, before any user story depends on the harness.

  Scenario: The composed host reports healthy
    When I request "/health/live"
    Then the response status is 200

  Scenario: The composed host is connected to the real PostgreSQL container
    When I request "/health/ready"
    Then the response status is 200

  Scenario: An anonymous caller resolves to the guest tier
    When I request "/api/v1/me/entitlements"
    Then the response status is 200
    And the response body contains "guest"
