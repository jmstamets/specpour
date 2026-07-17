import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/auth/refresh_coordinator.dart';

/// T177 frozen-tab hardening (John's PR #2 merge review): unit coverage for
/// the effective-token selection decision, extracted as a pure function
/// specifically so it's testable here — coordinatedRefresh's real web-only
/// live-read can't run under this VM test target.
void main() {
  group('selectEffectiveRefreshToken', () {
    test('prefers the live token when it differs from the starting token', () {
      final effective = selectEffectiveRefreshToken(
        startingRefreshToken: 'stale-token',
        liveToken: 'fresh-token',
      );

      expect(effective, 'fresh-token');
    });

    test('keeps the starting token when the live token matches it', () {
      final effective = selectEffectiveRefreshToken(
        startingRefreshToken: 'same-token',
        liveToken: 'same-token',
      );

      expect(effective, 'same-token');
    });

    test('keeps the starting token when there is no live token', () {
      final effective = selectEffectiveRefreshToken(
        startingRefreshToken: 'only-token',
        liveToken: null,
      );

      expect(effective, 'only-token');
    });
  });
}
