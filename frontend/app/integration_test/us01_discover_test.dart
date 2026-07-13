import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:specpour_app/core/app.dart';

import 'support/no_raw_l10n_keys.dart';

/// T031: Flutter integration test for US1 (guest browse/search/recipe view).
/// Run on a real device/browser (CI: reactivecircus/android-emulator-runner, per
/// .github/workflows/ci.yml's frontend-integration-tests job) against the
/// composed app + a real backend, per the same convention as
/// integration_test/age_gate_test.dart. See
/// test/features/discover/us01_discover_widget_test.dart for the
/// sandbox-runnable twin (no device/emulator available in the dev sandbox —
/// same limitation noted since Phase 1). T157 adds the no-raw-localization-keys
/// rendering assertion after each screen settles.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    '1: a guest can search the curated library by name and open a full recipe',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: SpecPourApp()));
      await tester.pumpAndSettle();

      final searchField = find.byKey(const Key('discoverSearchField'));
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Mai Tai');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      final resultTile = find.byKey(const Key('recipeResultTile-mai-tai'));
      expect(resultTile, findsOneWidget);

      await tester.tap(resultTile);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recipeDetailScreen')), findsOneWidget);
      expect(find.byKey(const Key('recipeIngredientLines')), findsOneWidget);
      expect(
        find.byKey(const Key('recipeAbvAndStandardDrinks')),
        findsOneWidget,
      );
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets(
    '2: a recipe containing egg white shows a prominent allergen flag',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: SpecPourApp()));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('discoverSearchField')),
        'Whiskey Flip',
      );
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('recipeResultTile-whiskey-flip')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recipeAllergenFlag-egg')), findsOneWidget);
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets('3: an anonymous visitor can browse without an account', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SpecPourApp()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('discoverBrowseList')), findsOneWidget);
    expect(find.byKey(const Key('accountGateSignInPrompt')), findsNothing);
    expectNoRawLocalizationKeys(tester);
  });
}
