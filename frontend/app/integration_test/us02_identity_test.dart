import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/app.dart';
import 'package:specpour_app/core/routing/app_router.dart';

import 'support/no_raw_l10n_keys.dart';

/// T046: Flutter integration test for US2 (register/sign-in/MFA enrollment/
/// sessions/account lifecycle — login-requires-MFA and social sign-in aren't
/// covered here: the former needs a sign-out affordance that doesn't exist
/// yet, the latter needs real Google/Apple/Microsoft app credentials this
/// environment doesn't have, per ExternalAuthEndpoints' own doc comment; T165
/// tracks the fake-OAuth-handler alternative). Run on a real device/browser
/// against a real backend, same convention as integration_test/us01_discover_test.dart — see
/// test/features/identity/identity_widget_test.dart for the sandbox-runnable
/// twin (no device/emulator available in the dev sandbox). No gated action is
/// wired up on the Discover surface yet (T043's own note), so these navigate to
/// the identity routes directly via the router rather than through a guest-gate
/// prompt.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> enterDateOfBirth(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('registerDateOfBirthButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '01/01/1990');
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  testWidgets(
    '1: a visitor can register with a valid adult date of birth and land signed in',
    (tester) async {
      late WidgetRef capturedRef;
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              capturedRef = ref;
              return const SpecPourApp();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      capturedRef.read(appRouterProvider).go('/register');
      await tester.pumpAndSettle();

      final email = 'integration-${DateTime.now().microsecondsSinceEpoch}@example.test';
      await tester.enterText(find.byKey(const Key('registerEmailField')), email);
      await tester.enterText(
        find.byKey(const Key('registerPasswordField')),
        'correct horse battery staple',
      );
      await tester.enterText(
        find.byKey(const Key('registerDisplayNameField')),
        'Integration Test User',
      );
      await enterDateOfBirth(tester);

      await tester.tap(find.byKey(const Key('registerSubmitButton')));
      await tester.pumpAndSettle();

      expect(capturedRef.read(authTokenProvider), isNotNull);
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets(
    '2: registering with an underage date of birth is rejected and shows an error',
    (tester) async {
      late WidgetRef capturedRef;
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              capturedRef = ref;
              return const SpecPourApp();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      capturedRef.read(appRouterProvider).go('/register');
      await tester.pumpAndSettle();

      final email = 'integration-underage-${DateTime.now().microsecondsSinceEpoch}@example.test';
      await tester.enterText(find.byKey(const Key('registerEmailField')), email);
      await tester.enterText(
        find.byKey(const Key('registerPasswordField')),
        'correct horse battery staple',
      );
      await tester.enterText(
        find.byKey(const Key('registerDisplayNameField')),
        'Too Young',
      );

      await tester.tap(find.byKey(const Key('registerDateOfBirthButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      final tenYearsAgo = DateTime.now().subtract(const Duration(days: 365 * 10));
      await tester.enterText(
        find.byType(TextField).first,
        '${tenYearsAgo.month.toString().padLeft(2, '0')}/${tenYearsAgo.day.toString().padLeft(2, '0')}/${tenYearsAgo.year}',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('registerSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('registerErrorMessage')), findsOneWidget);
      expect(capturedRef.read(authTokenProvider), isNull);
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets(
    '3: a signed-in user can enroll TOTP MFA',
    (tester) async {
      late WidgetRef capturedRef;
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              capturedRef = ref;
              return const SpecPourApp();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      capturedRef.read(appRouterProvider).go('/register');
      await tester.pumpAndSettle();

      final email = 'integration-mfa-${DateTime.now().microsecondsSinceEpoch}@example.test';
      await tester.enterText(find.byKey(const Key('registerEmailField')), email);
      await tester.enterText(
        find.byKey(const Key('registerPasswordField')),
        'correct horse battery staple',
      );
      await tester.enterText(find.byKey(const Key('registerDisplayNameField')), 'MFA Test User');
      await enterDateOfBirth(tester);
      await tester.tap(find.byKey(const Key('registerSubmitButton')));
      await tester.pumpAndSettle();

      expect(capturedRef.read(authTokenProvider), isNotNull);

      capturedRef.read(appRouterProvider).go('/account/mfa');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('mfaSettingsEnrollButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('mfaSettingsSecretText')), findsOneWidget);
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets(
    '4: a signed-in user can view their active sessions',
    (tester) async {
      late WidgetRef capturedRef;
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              capturedRef = ref;
              return const SpecPourApp();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      capturedRef.read(appRouterProvider).go('/register');
      await tester.pumpAndSettle();

      final email = 'integration-sessions-${DateTime.now().microsecondsSinceEpoch}@example.test';
      await tester.enterText(find.byKey(const Key('registerEmailField')), email);
      await tester.enterText(
        find.byKey(const Key('registerPasswordField')),
        'correct horse battery staple',
      );
      await tester.enterText(find.byKey(const Key('registerDisplayNameField')), 'Sessions Test User');
      await enterDateOfBirth(tester);
      await tester.tap(find.byKey(const Key('registerSubmitButton')));
      await tester.pumpAndSettle();

      expect(capturedRef.read(authTokenProvider), isNotNull);

      capturedRef.read(appRouterProvider).go('/account/sessions');
      await tester.pumpAndSettle();

      // Registration's own token exchange already created one real session.
      expect(find.textContaining('Last active'), findsWidgets);
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets(
    '5: a signed-in user can deactivate and reactivate their account',
    (tester) async {
      late WidgetRef capturedRef;
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              capturedRef = ref;
              return const SpecPourApp();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      capturedRef.read(appRouterProvider).go('/register');
      await tester.pumpAndSettle();

      final email = 'integration-lifecycle-${DateTime.now().microsecondsSinceEpoch}@example.test';
      await tester.enterText(find.byKey(const Key('registerEmailField')), email);
      await tester.enterText(
        find.byKey(const Key('registerPasswordField')),
        'correct horse battery staple',
      );
      await tester.enterText(find.byKey(const Key('registerDisplayNameField')), 'Lifecycle Test User');
      await enterDateOfBirth(tester);
      await tester.tap(find.byKey(const Key('registerSubmitButton')));
      await tester.pumpAndSettle();

      expect(capturedRef.read(authTokenProvider), isNotNull);

      capturedRef.read(appRouterProvider).go('/account/lifecycle');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('accountLifecycleDeactivateButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('accountLifecycleConfirmDialogButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('accountLifecycleReactivateButton')), findsOneWidget);

      // Deactivation revoked the session that had been driving this screen's
      // own calls — a real password sign-in stands in for "the user signs
      // back in," same shorthand the backend acceptance suite uses
      // (US02IdentitySteps.WhenTheUserReactivatesTheirAccount).
      capturedRef.read(appRouterProvider).go('/sign-in');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('signInEmailField')), email);
      await tester.enterText(
        find.byKey(const Key('signInPasswordField')),
        'correct horse battery staple',
      );
      await tester.tap(find.byKey(const Key('signInSubmitButton')));
      await tester.pumpAndSettle();

      capturedRef.read(appRouterProvider).go('/account/lifecycle');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('accountLifecycleReactivateButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('accountLifecycleDeactivateButton')), findsOneWidget);
      expectNoRawLocalizationKeys(tester);
    },
  );
}
