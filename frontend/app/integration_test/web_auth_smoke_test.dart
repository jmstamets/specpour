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

  testWidgets('T176: guest-gated sign-in fail-then-succeed lands on the intent', (
    tester,
  ) async {
    // Register a fresh account (capturing creds), then simulate a signed-out UI and
    // drive the REAL guest-gate flow: tap the account icon (as a guest) -> prompt ->
    // sign in. That flow captures a pending intent (open /account), which is exactly
    // what surfaced F2 — a successful sign-in resumed the intent AND popped the
    // screen it pushed, stranding the user back on sign-in.
    final email =
        'websignin-${DateTime.now().microsecondsSinceEpoch}@example.test';
    const password = 'correct horse battery staple';
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
    await tester.enterText(find.byKey(const Key('registerEmailField')), email);
    await tester.enterText(
      find.byKey(const Key('registerPasswordField')),
      password,
    );
    await tester.enterText(
      find.byKey(const Key('registerDisplayNameField')),
      'Sign In User',
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

    // Simulate signed-out, land on Discover, and enter the guest-gate flow.
    ref.read(authTokenProvider.notifier).set(null);
    ref.read(refreshTokenProvider.notifier).set(null);
    ref.read(appRouterProvider).go('/');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('accountNavButton')));
    await tester.pumpAndSettle();
    // Guest -> prompt; tapping "sign in" captures the intent (open /account).
    expect(find.byKey(const Key('accountGateSignInPrompt')), findsOneWidget);
    await tester.tap(find.byKey(const Key('accountGateSignInButton')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('signInScreen')), findsOneWidget);

    // Attempt 1: wrong password -> error, submit must remain ENABLED.
    await tester.enterText(find.byKey(const Key('signInEmailField')), email);
    await tester.enterText(
      find.byKey(const Key('signInPasswordField')),
      'wrong password entirely',
    );
    await tester.tap(find.byKey(const Key('signInSubmitButton')));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(
      find.byKey(const Key('signInErrorMessage')),
      findsOneWidget,
      reason: 'wrong password should show an error',
    );
    expect(
      tester
          .widget<ElevatedButton>(find.byKey(const Key('signInSubmitButton')))
          .onPressed,
      isNotNull,
      reason: 'submit must be re-enabled after a failed sign-in (F2)',
    );

    // Attempt 2: set the CORRECT password. Set the controller directly rather than
    // via enterText — a second enterText on the same focused field doesn't reliably
    // replace on Flutter web (a test-input quirk, not the app), and F2 is about the
    // post-login state machine, not typing.
    tester
            .widget<TextField>(find.byKey(const Key('signInPasswordField')))
            .controller!
            .text =
        password;
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('signInSubmitButton')));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    final err2Finder = find.byKey(const Key('signInErrorMessage'));
    final err2 = err2Finder.evaluate().isNotEmpty
        ? tester.widget<Text>(err2Finder).data
        : '(no error widget)';
    expect(
      ref.read(authTokenProvider),
      isNotNull,
      reason: 'correct password should sign in; onScreenError=[$err2]',
    );
    // Must land on the intent target (/account), NOT be stranded on sign-in.
    expect(
      find.byKey(const Key('signInScreen')),
      findsNothing,
      reason: 'a successful sign-in must leave the sign-in screen (F2)',
    );
    expect(
      find.byKey(const Key('accountMenuScreen')),
      findsOneWidget,
      reason: 'the captured intent (open /account) must complete (F2)',
    );
  });

  testWidgets('T176 follow-up: guest-gated REGISTER also lands on the intent', (
    tester,
  ) async {
    // completePendingIntent has two real consumers: sign_in_screen (T176
    // above) and register_screen. F2's fix touched the shared function, so
    // the register path needs its own verification — a guest gated by the
    // same account-nav intent, but who completes it via Register instead of
    // Sign In. This is "the other consumer" John flagged as the most likely
    // silent casualty of the F2 fix.
    final email =
        'webregister-${DateTime.now().microsecondsSinceEpoch}@example.test';
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

    // Guest lands on Discover, taps the gated account icon.
    await tester.tap(find.byKey(const Key('accountNavButton')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('accountGateSignInPrompt')), findsOneWidget);

    // Complete the captured intent via Register instead of Sign In.
    await tester.tap(find.byKey(const Key('accountGateRegisterButton')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('registerScreen')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('registerEmailField')), email);
    await tester.enterText(
      find.byKey(const Key('registerPasswordField')),
      'correct horse battery staple',
    );
    await tester.enterText(
      find.byKey(const Key('registerDisplayNameField')),
      'Register Intent User',
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

    final errorFinder = find.byKey(const Key('registerErrorMessage'));
    final onScreenError = errorFinder.evaluate().isNotEmpty
        ? tester.widget<Text>(errorFinder).data
        : '(no error widget)';
    expect(
      ref.read(authTokenProvider),
      isNotNull,
      reason: 'registration should sign in; onScreenError=[$onScreenError]',
    );
    // Must land on the intent target (/account), NOT be stranded on register.
    expect(
      find.byKey(const Key('registerScreen')),
      findsNothing,
      reason: 'a successful registration must leave the register screen (F2)',
    );
    expect(
      find.byKey(const Key('accountMenuScreen')),
      findsOneWidget,
      reason:
          'the captured intent (open /account) must complete on the '
          'register path too (F2)',
    );
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
