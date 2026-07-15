import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/app.dart';
import 'package:specpour_app/core/routing/app_router.dart';

/// The browser-context auth smoke set (T179 — grown from T169's registration test).
/// Runs the REAL app against the REAL running backend (localhost:5001) in a real
/// headless Chrome via `flutter drive` + chromedriver, exercising the web-only code
/// paths (ADR-0003 cookie-then-PKCE redirect-following; minimal-API empty-body POSTs)
/// that unit/widget tests on the VM can't. This tier is load-bearing — every three
/// "green in suites, dead in browser" bugs so far (registration T169, MFA enroll T175,
/// session persistence T177) lived exactly here.
///
/// Prereqs: docker stack up (docker compose up -d) with current migrations.
/// Run: scripts/run-web-integration-tests.sh integration_test/web_auth_smoke_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Registers a fresh adult account through the real UI and returns once signed in.
  Future<WidgetRef> pumpAndRegister(WidgetTester tester, String tag) async {
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

    final email = '$tag-${DateTime.now().microsecondsSinceEpoch}@example.test';
    await tester.enterText(find.byKey(const Key('registerEmailField')), email);
    await tester.enterText(
      find.byKey(const Key('registerPasswordField')),
      'correct horse battery staple',
    );
    await tester.enterText(
      find.byKey(const Key('registerDisplayNameField')),
      'Smoke User',
    );

    // Adult DOB via the date picker's manual-entry field. The picker opens in an
    // Overlay, so its TextField is LAST — .first would type into the email field
    // behind the dialog (only visible in a real browser run).
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
    return ref;
  }

  testWidgets('T169: registration completes end-to-end and lands signed in', (
    tester,
  ) async {
    final ref = await pumpAndRegister(tester, 'webreg');

    final errorFinder = find.byKey(const Key('registerErrorMessage'));
    final onScreenError = errorFinder.evaluate().isNotEmpty
        ? tester.widget<Text>(errorFinder).data
        : '(no error widget)';

    expect(
      ref.read(authTokenProvider),
      isNotNull,
      reason:
          'registration should end signed in; onScreenError=[$onScreenError]',
    );
    expect(find.byKey(const Key('registerErrorMessage')), findsNothing);
  });

  testWidgets('T175: MFA enrollment shows the secret in a real browser', (
    tester,
  ) async {
    final ref = await pumpAndRegister(tester, 'webmfa');
    expect(
      ref.read(authTokenProvider),
      isNotNull,
      reason: 'must be signed in first',
    );

    ref.read(appRouterProvider).go('/account/mfa');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('mfaSettingsEnrollButton')));
    // Real POST /me/mfa with no body — the exact call that raised the raw
    // minimal-API "Implicit body inferred" error in the browser before F1.
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final errorFinder = find.byKey(const Key('mfaSettingsErrorMessage'));
    final onScreenError = errorFinder.evaluate().isNotEmpty
        ? tester.widget<Text>(errorFinder).data
        : '(no error widget)';

    expect(
      find.byKey(const Key('mfaSettingsSecretText')),
      findsOneWidget,
      reason:
          'enroll should show the TOTP secret; onScreenError=[$onScreenError]',
    );
  });
}
