// Shared browser-tier helper: drives the real registration UI to produce a
// fresh, signed-in account. Factored out of web_session_persistence_test.dart
// (T177 #101) so web_cap_expiry_test.dart doesn't duplicate the same
// key-by-key form interaction — any drift between two copies would be a
// silent way for one test's coverage to quietly diverge from the other's.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/routing/app_router.dart';

/// Registers a new account with a unique email (seeded from [testTag] plus
/// the current time) via the real UI flow, asserting the app ends up signed
/// in. [testTag] disambiguates which scenario a given test run's account
/// belongs to when reading server-side logs/data during debugging.
Future<void> registerFreshAccount(
  WidgetTester tester,
  WidgetRef ref, {
  required String testTag,
}) async {
  ref.read(appRouterProvider).go('/register');
  await tester.pumpAndSettle();
  final email =
      '$testTag-${DateTime.now().microsecondsSinceEpoch}@example.test';
  await tester.enterText(find.byKey(const Key('registerEmailField')), email);
  await tester.enterText(
    find.byKey(const Key('registerPasswordField')),
    'correct horse battery staple',
  );
  await tester.enterText(
    find.byKey(const Key('registerDisplayNameField')),
    'Test User',
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
