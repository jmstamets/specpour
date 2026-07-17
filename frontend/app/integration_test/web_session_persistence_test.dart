// ADR-0005 (T177 #101) browser-tier session persistence + revocation-linkage
// tests — two real headless-Chrome scenarios that a widget test can't cover
// because they depend on a genuinely persisted (window.localStorage) refresh
// token surviving a fresh app boot, exactly like T099's own browser-tier
// finding did (a later testWidgets case's fresh pumpWidget silently inherited
// an earlier case's persisted session — proof that a fresh pumpWidget reading
// the SAME persisted storage functions as a "reload" from the app's own
// perspective, without needing a literal window.location.reload(), which
// would tear down the flutter_drive debug connection). Each case below reuses
// that same fresh-pumpWidget-same-storage technique deliberately.
//
// Scope note (T177 #101(c), escalated rather than guessed): 90-day-cap-expiry
// and reuse-detection-revocation are NOT covered here. Both already have
// backend Acceptance coverage using TestTimeProvider (scenarios 18/19,
// in-process only), but TestTimeProvider is wired only into the xUnit
// SpecPourWebApplicationFactory test host — it has no bridge to the real
// docker-composed API this browser tier drives, and "production always gets
// real time" is an explicit, deliberate decision (Program.cs). Building a
// live clock-manipulation surface to bridge that gap is a new
// security-boundary-adjacent decision, not an additive test — see the T177
// done-note for the escalation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/app.dart';
import 'package:specpour_app/core/auth/identity_auth_service.dart';
import 'package:specpour_app/core/routing/app_router.dart';

/// Boots (or re-boots) the app, always as a genuinely fresh instance.
///
/// Root-caused (2026-07-17, via reproduction): a naive second call to
/// `pumpWidget(ProviderScope(...))` within the SAME test does NOT simulate a
/// reload — Flutter's element diffing sees the same root widget TYPE and
/// treats it as an UPDATE, not a remount, so ProviderScope's State (and the
/// ProviderContainer it holds, including in-memory authTokenProvider) survives
/// untouched. A test built on that assumption silently reused the FIRST boot's
/// still-signed-in state for every "reload"/"relaunch," passing for the wrong
/// reason (confirmed: LastSeenAt was byte-identical across "reload," and a
/// revoked session's access token was still readable after "relaunch" — no
/// second network round trip ever actually happened). This is unrelated to
/// T099's own precedent (localStorage persisting across SEPARATE testWidgets
/// CASES, which DOES get a real teardown between cases) — that finding does
/// not extend to multiple pumpWidget calls inside ONE case. Pumping an
/// unrelated widget type first forces Flutter to unmount the old element tree
/// for real before the fresh instance is mounted.
Future<WidgetRef> _bootApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();

  late WidgetRef ref;
  await tester.pumpWidget(
    ProviderScope(
      child: Consumer(
        builder: (context, r, _) {
          ref = r;
          return const SpecPourApp();
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
  return ref;
}

Future<void> _registerFreshAccount(WidgetTester tester, WidgetRef ref) async {
  ref.read(appRouterProvider).go('/register');
  await tester.pumpAndSettle();
  final email =
      'sessionpersist-${DateTime.now().microsecondsSinceEpoch}@example.test';
  await tester.enterText(find.byKey(const Key('registerEmailField')), email);
  await tester.enterText(
    find.byKey(const Key('registerPasswordField')),
    'correct horse battery staple',
  );
  await tester.enterText(
    find.byKey(const Key('registerDisplayNameField')),
    'Session Persistence User',
  );
  await tester.tap(find.byKey(const Key('registerDateOfBirthButton')));
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.edit_outlined));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).last, '07/14/2000');
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('registerSubmitButton')));
  await tester.pumpAndSettle(const Duration(seconds: 10));
  expect(
    ref.read(authTokenProvider),
    isNotNull,
    reason: 'registered + signed in',
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  testWidgets(
    'T177 #101(a): reload resumes the same session, never a duplicate',
    (tester) async {
      final ref = await _bootApp(tester);
      await _registerFreshAccount(tester, ref);

      final before = await ref.read(identityAuthServiceProvider).listSessions();
      expect(
        before,
        hasLength(1),
        reason: 'exactly one session/device for a fresh sign-in',
      );
      final sessionIdBefore = before.single.id;
      final lastSeenBefore = before.single.lastSeenAt;

      // "Reload" — a fresh app boot reading the SAME persisted localStorage
      // (see the file-level doc comment for why this is faithful here).
      final ref2 = await _bootApp(tester);

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
      final ref = await _bootApp(tester);
      await _registerFreshAccount(tester, ref);

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

      // A's "next launch": a fresh app boot reading A's persisted (now
      // revoked) refresh token — the same fresh-pumpWidget technique as (a).
      final ref2 = await _bootApp(tester);

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
      // discoverSearchField (not discoverBrowseList) deliberately: the browse
      // list only renders once the catalog fetch succeeds AND returns
      // non-empty data (DiscoverScreen's _BrowseList.when — error/empty both
      // render text instead), so it depends on seeded catalog fixtures this
      // CI job doesn't provide. The search field is part of the screen's
      // fixed chrome, built unconditionally regardless of catalog state —
      // the right, environment-independent proof we landed on the normal
      // discover shell rather than a stuck/blank/error screen.
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
