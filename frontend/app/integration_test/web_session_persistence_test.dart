// ADR-0005 (T177 #101) browser-tier session persistence + revocation-linkage
// tests — two real headless-Chrome scenarios that a widget test can't cover
// because they depend on a genuinely persisted (window.localStorage) refresh
// token surviving a fresh app boot. Both use coldRestart (integration_test/
// support/cold_restart.dart) to simulate that boot faithfully — see that
// helper's own doc comment for the pumpWidget-twice trap it guards against.
//
// Scope note (T177 #101(c)): 90-day-cap-expiry lives in its own file,
// web_cap_expiry_test.dart, run via scripts/run-cap-expiry-test.sh — it needs
// a test-script-side DB backdate (John's ruling, 2026-07-17), not something
// this file's pure-Dart harness can do. Reuse-detection-revocation is
// accepted as covered by backend Acceptance scenario 18 plus this file's own
// (b) — see that script's own doc comment for the full equivalence argument.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/auth/identity_auth_service.dart';

import 'support/cold_restart.dart';
import 'support/register_fresh_account.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  testWidgets(
    'T177 #101(a): reload resumes the same session, never a duplicate',
    (tester) async {
      final ref = await coldRestart(tester);
      await registerFreshAccount(tester, ref, testTag: 'sessionpersist');

      final before = await ref.read(identityAuthServiceProvider).listSessions();
      expect(
        before,
        hasLength(1),
        reason: 'exactly one session/device for a fresh sign-in',
      );
      final sessionIdBefore = before.single.id;
      final lastSeenBefore = before.single.lastSeenAt;

      // "Reload" — a genuine cold restart reading the SAME persisted
      // localStorage (see cold_restart.dart's doc comment).
      final ref2 = await coldRestart(tester);

      expect(
        tester.takeException(),
        isNull,
        reason: 'reload must never surface an error screen',
      );
      expect(
        ref2.read(authTokenProvider),
        isNotNull,
        reason: 'reload must silently restore the session, not sign out',
      );

      final after = await ref2.read(identityAuthServiceProvider).listSessions();
      expect(
        after,
        hasLength(1),
        reason:
            'reload must resume the SAME session — a second entry means a '
            'duplicate SessionDevice row was created instead of a restore.',
      );
      expect(
        after.single.id,
        sessionIdBefore,
        reason: 'session identity must be stable across reload',
      );
      expect(
        after.single.lastSeenAt.isAfter(lastSeenBefore),
        isTrue,
        reason:
            'the restore-triggered refresh should bump LastSeenAt — got '
            '${after.single.lastSeenAt} vs prior $lastSeenBefore.',
      );
    },
  );

  testWidgets(
    'T177 #101(b): revoking a session while its context is closed lands the '
    'next launch cleanly signed out',
    (tester) async {
      final ref = await coldRestart(tester);
      await registerFreshAccount(tester, ref, testTag: 'sessionpersist');

      final sessions = await ref
          .read(identityAuthServiceProvider)
          .listSessions();
      expect(sessions, hasLength(1));
      final sessionId = sessions.single.id;

      // Revoke via A's own still-live service, THEN tear A's context down —
      // server-side, revocation is stateless and doesn't care which context
      // issued the call, only that a valid bearer token authorized it. What
      // this scenario is actually testing is the CLIENT's reaction on its
      // next launch, not the mechanics of a second browsing context (unlike
      // #100's mechanism test, no genuine concurrency is exercised here).
      await ref
          .read(identityAuthServiceProvider)
          .revokeSession(sessionId: sessionId);

      // A's "next launch": a genuine cold restart reading A's persisted (now
      // revoked) refresh token.
      final ref2 = await coldRestart(tester);

      expect(
        tester.takeException(),
        isNull,
        reason: 'a revoked session landing must never surface an error screen',
      );
      expect(
        ref2.read(authTokenProvider),
        isNull,
        reason: 'a revoked session must land signed out, not silently resumed',
      );
      // Standing rule (2026-07-17): post-auth landing assertions target
      // UNCONDITIONAL screen chrome, never data-dependent widgets.
      // discoverSearchField (not discoverBrowseList) here specifically:
      // the browse list only renders once the catalog fetch succeeds AND
      // returns non-empty data (DiscoverScreen's _BrowseList.when — error/
      // empty both render text instead), so it depends on seeded catalog
      // fixtures this CI job doesn't provide (caught as a CI-only failure —
      // passed locally against a long-running dev stack with real catalog
      // data, failed on push against CI's zero-seed stack). The search field
      // is part of the screen's fixed chrome, built unconditionally
      // regardless of catalog state — an environment-independent proof we
      // landed on the normal discover shell rather than a stuck/blank/error
      // screen.
      expect(
        find.byKey(const Key('discoverSearchField')),
        findsOneWidget,
        reason:
            'must land on the normal home shell (guest state), never a '
            'stuck/blank/error screen',
      );
    },
  );
}
