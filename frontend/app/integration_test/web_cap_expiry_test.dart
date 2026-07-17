// T177 #101(c): live 90-day-absolute-cap-expiry check.
//
// John's ruling (2026-07-17): a modified Option 3 — backdate the test
// session's own SessionDevices.CreatedAt directly via SQL from the WRAPPING
// SCRIPT (scripts/run-cap-expiry-test.sh), not from any application code or
// new API surface. This Dart test's only role is: sign in with a uniquely
// tagged email, sleep for a generous fixed window while the wrapping script
// finds and backdates that row out-of-band, then cold-restart and assert the
// next refresh (server-side cap check) lands the client cleanly signed out —
// the SAME client-observable shape web_session_persistence_test.dart's (b)
// already exercises end-to-end (TokenEndpoints.HandleTokenAsync's cap branch
// calls the identical TryRevokeAsync + Results.Forbid sequence RevokeAsync's
// explicit-revoke path does), which is the whole basis for treating that
// pass as strong evidence this client-side handling generalizes to the cap.
//
// The wrapping script identifies the right row by querying for the most
// recent SessionDevice belonging to a user whose email starts with the
// 'capexpiry-' tag below — NOT by having this test print a marker for the
// script to scrape. Empirically confirmed (2026-07-17): print() calls from
// code running inside the browser under `flutter drive -d web-server
// --headless` never surface in the driver process's own captured stdout at
// all (not a timing issue — the marker line was never present in the log
// regardless of how long the script waited), so a print-and-grep handshake
// is a dead end on this target. Querying Postgres directly for the
// already-tagged row needs no signal from this side at all.
//
// Option 2 (a Development-gated clock-control endpoint) is REJECTED
// PERMANENTLY (John, 2026-07-17): a live clock-control surface is an
// attack-surface-shaped object whose test value this investigation showed to
// be near zero — do not re-propose it.
//
// Reuse-detection-revocation's live trigger is accepted as covered WITHOUT a
// dedicated live test here: backend Acceptance scenario 18 already proves the
// server-side mechanics (redeem-twice -> second fails, authorization
// revoked), and web_session_persistence_test.dart's (b) already proves the
// CLIENT's reaction to a Forbid'd refresh end-to-end through a real browser.
// Reuse detection produces the exact same Forbid shape the cap and explicit-
// revoke branches produce — there is no separate client code path reuse
// detection could break that (b) doesn't already exercise. Building leeway-
// reconfiguration infrastructure to trigger reuse live would only re-prove a
// client seam already proven, for a live-only mechanics check backend
// scenario 18 already owns.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/auth/identity_auth_service.dart';

import 'support/cold_restart.dart';
import 'support/register_fresh_account.dart';

/// Must match run-cap-expiry-test.sh's own copy of this tag — it's how the
/// wrapping script finds the right SessionDevice row to backdate (see
/// register_fresh_account.dart's testTag doc).
const _testTag = 'capexpiry';

/// Generous window for the wrapping script to poll Postgres for this run's
/// freshly-created session and run its psql UPDATE (a `docker compose exec`
/// has real process-startup overhead on top of the query itself) — widened
/// from an initial 8s after empirical runs showed that cut it too close and
/// the cold restart raced ahead of the backdate landing.
const _backdateWindow = Duration(seconds: 20);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  testWidgets(
    'T177 #101(c): a session past the 90-day absolute cap lands the next '
    'refresh cleanly signed out',
    (tester) async {
      final ref = await coldRestart(tester);
      await registerFreshAccount(tester, ref, testTag: _testTag);

      final sessions = await ref
          .read(identityAuthServiceProvider)
          .listSessions();
      expect(sessions, hasLength(1));

      // No signal is sent to the wrapping script here — it finds this run's
      // session itself by polling for the most recent SessionDevice row
      // belonging to a '$_testTag-'-tagged user (see the file-level doc
      // comment for why print() couldn't be used instead).
      await Future<void>.delayed(_backdateWindow);

      // The "next refresh": a genuine cold restart reading the persisted
      // (now over-cap) refresh token.
      final ref2 = await coldRestart(tester);

      expect(
        tester.takeException(),
        isNull,
        reason:
            'an expired-by-cap session landing must never surface an error '
            'screen',
      );
      expect(
        ref2.read(authTokenProvider),
        isNull,
        reason:
            'a session past the 90-day absolute cap must land signed out, '
            'not silently resumed',
      );
      // Standing rule: post-auth landing assertions target unconditional
      // screen chrome — see web_session_persistence_test.dart's (b) for the
      // full rationale (discoverBrowseList depends on seeded catalog data
      // this CI job doesn't provide; discoverSearchField doesn't).
      expect(
        find.byKey(const Key('discoverSearchField')),
        findsOneWidget,
        reason:
            'must land on the normal home shell, never a stuck/blank/error '
            'screen',
      );
    },
  );
}
