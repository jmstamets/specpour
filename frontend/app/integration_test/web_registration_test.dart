import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/app.dart';
import 'package:specpour_app/core/routing/app_router.dart';

/// Walkthrough finding #1 (2026-07-15): registration was green in every suite but
/// dead in a real browser — the post-registration PKCE exchange redirected to a dead
/// port, and no test ran in a browser so nothing caught it. This is that missing
/// test: it drives the REAL app against the REAL running backend (localhost:5001) in
/// a real browser via `flutter drive` + chromedriver, so the whole ADR-0003
/// cookie-then-PKCE flow (including the web-only redirect-following code path that
/// unit/widget tests on the VM never exercise) actually runs. It fails on the
/// pre-fix code (connection error to the stale redirect URI) and passes once the
/// web PKCE flow reads the code off the followed redirect's final URL.
///
/// Prereqs: the docker stack up (docker compose up -d) and migrations current.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('registration completes end-to-end in a browser and lands signed in', (
    tester,
  ) async {
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

    ref.read(appRouterProvider).go('/register');
    await tester.pumpAndSettle();

    final email =
        'webreg-${DateTime.now().microsecondsSinceEpoch}@example.test';
    await tester.enterText(find.byKey(const Key('registerEmailField')), email);
    await tester.enterText(
      find.byKey(const Key('registerPasswordField')),
      'correct horse battery staple',
    );
    await tester.enterText(
      find.byKey(const Key('registerDisplayNameField')),
      'Web Reg User',
    );

    // Adult DOB via the Material date picker's manual-entry field. The picker
    // opens in an Overlay, so its TextField is LAST in tree order — using .first
    // would type into the register email field behind the dialog.
    await tester.tap(find.byKey(const Key('registerDateOfBirthButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '07/14/2000');
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('registerSubmitButton')));
    // Real network: register -> cookie -> /connect/authorize -> follow redirect
    // -> read code -> /connect/token. Give it real wall-clock time.
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Surface any on-screen error text in the assertion reason (flutter drive
    // shows the failure reason; in-browser print() is not surfaced).
    final errorFinder = find.byKey(const Key('registerErrorMessage'));
    final onScreenError = errorFinder.evaluate().isNotEmpty
        ? tester.widget<Text>(errorFinder).data
        : '(no error widget)';

    // The token exchange must have completed — this is exactly what the stale
    // redirect URI broke in a real browser.
    expect(
      ref.read(authTokenProvider),
      isNotNull,
      reason:
          'registration should end signed in; email=$email onScreenError=[$onScreenError]',
    );
    expect(find.byKey(const Key('registerErrorMessage')), findsNothing);
  });
}
