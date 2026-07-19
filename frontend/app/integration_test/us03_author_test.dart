import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:specpour_app/core/app.dart';
import 'package:specpour_app/core/routing/app_router.dart';

import 'support/no_raw_l10n_keys.dart';
import 'support/register_fresh_account.dart';

/// T057: Flutter integration test for US3 (author a personal library —
/// spec.md scenarios 1-3; scenario 4's cross-user search privacy is already
/// covered by the backend acceptance suite, US03_AuthorLibrary.feature,
/// which is the right layer for a no-UI-involved privacy assertion). Run on
/// a real device/browser against a real backend, same convention as
/// integration_test/us02_identity_test.dart — see
/// test/features/library/*_widget_test.dart for the sandbox-runnable twins
/// (no device/emulator available in the dev sandbox, so this file is
/// unrunnable here, same standing caveat as us02_identity_test.dart's own
/// MFA/sessions scenarios). No gated action is wired up on the Discover
/// surface for /library beyond requireAccount's own sign-in prompt, so these
/// navigate to the library routes directly via the router after registering,
/// same shorthand us02_identity_test.dart already established.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Opens the ingredient picker on the recipe editor's first ingredient
  /// line and selects whichever option renders first — curated seed content
  /// (T181) is real but its exact set isn't a stable contract for this test
  /// to hardcode a name/id against; any real ingredient exercises the same
  /// code path.
  Future<void> pickFirstIngredient(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('recipeEditorIngredientDropdown-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
  }

  testWidgets(
    '1: a signed-in user creates a private recipe with full detail (spec.md scenario 1)',
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

      await registerFreshAccount(
        tester,
        capturedRef,
        testTag: 'integration-us03-recipe',
      );

      capturedRef.read(appRouterProvider).go('/library/recipes/new');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('recipeEditorPrimaryNameField')),
        'Integration Test Daiquiri',
      );
      await tester.enterText(
        find.byKey(const Key('recipeEditorAlternateNamesField')),
        'Test Daiquiri Variant',
      );
      await pickFirstIngredient(tester);
      await tester.enterText(
        find.byKey(const Key('recipeEditorQuantityField-0')),
        '2',
      );
      await tester.enterText(
        find.byKey(const Key('recipeEditorUnitField-0')),
        'oz',
      );

      await tester.scrollUntilVisible(
        find.byKey(const Key('recipeEditorSubmitButton')),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byKey(const Key('recipeEditorSubmitButton')));
      await tester.pumpAndSettle();

      // The editor pops back to the library screen on success — the new
      // recipe appears in the personal-library list (FR-008b: never in the
      // anonymous public catalog, which US03_AuthorLibrary.feature's own
      // backend scenario 1 already covers).
      expect(
        find.text('Integration Test Daiquiri'),
        findsOneWidget,
        reason: 'created recipe appears in the personal library list',
      );
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets(
    '2: a house-made ingredient behaves as an ingredient everywhere it is used (spec.md scenario 2)',
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

      await registerFreshAccount(
        tester,
        capturedRef,
        testTag: 'integration-us03-housemade',
      );

      capturedRef.read(appRouterProvider).go('/library/ingredients/new');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('houseMadeEditorNameField')),
        'Integration Test Grenadine',
      );

      // A brand-new account has no personal recipes yet — the editor's own
      // "create a component recipe first" affordance (FR-017: the defining
      // recipe must be a real Recipe row) is itself part of what this
      // scenario exercises.
      expect(
        find.byKey(const Key('houseMadeEditorCreateComponentRecipeButton')),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const Key('houseMadeEditorCreateComponentRecipeButton')),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('recipeEditorPrimaryNameField')),
        'Grenadine (component recipe)',
      );
      await pickFirstIngredient(tester);
      await tester.enterText(
        find.byKey(const Key('recipeEditorQuantityField-0')),
        '1',
      );
      await tester.enterText(
        find.byKey(const Key('recipeEditorUnitField-0')),
        'part',
      );
      await tester.scrollUntilVisible(
        find.byKey(const Key('recipeEditorSubmitButton')),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byKey(const Key('recipeEditorSubmitButton')));
      await tester.pumpAndSettle();

      // Popping the recipe editor returns to the house-made ingredient
      // editor with the just-created recipe pre-selected as the defining
      // recipe (HouseMadeIngredientEditorScreen._createComponentRecipe).
      expect(
        find.byKey(const Key('houseMadeEditorDefiningRecipeDropdown')),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const Key('houseMadeEditorYieldQuantityField')),
        '750',
      );
      await tester.enterText(
        find.byKey(const Key('houseMadeEditorYieldUnitField')),
        'ml',
      );
      await tester.enterText(
        find.byKey(const Key('houseMadeEditorShelfLifeDaysField')),
        '30',
      );
      await tester.enterText(
        find.byKey(const Key('houseMadeEditorStorageInstructionsField')),
        'Refrigerate in a sealed bottle.',
      );

      await tester.scrollUntilVisible(
        find.byKey(const Key('houseMadeEditorSubmitButton')),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byKey(const Key('houseMadeEditorSubmitButton')));
      await tester.pumpAndSettle();

      expect(
        find.text('Integration Test Grenadine'),
        findsOneWidget,
        reason: 'house-made ingredient appears in the personal library list',
      );
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets(
    '3: a professional user maintains a bar library scoped to a venue (spec.md scenario 3)',
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

      await registerFreshAccount(
        tester,
        capturedRef,
        testTag: 'integration-us03-venue',
      );

      capturedRef.read(appRouterProvider).go('/library/venues');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('venueCreateFab')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('venueNameField')),
        'Integration Test Bar',
      );
      await tester.enterText(
        find.byKey(const Key('venueAddressField')),
        '123 Test Street',
      );
      await tester.tap(find.byKey(const Key('venueSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.text('Integration Test Bar'), findsOneWidget);

      capturedRef.read(appRouterProvider).go('/library/recipes/new');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('recipeEditorPrimaryNameField')),
        'Integration Test Bar Recipe',
      );

      // Tap the "Bar" segment specifically (not just anywhere on the
      // SegmentedButton) via its own label text.
      await tester.tap(find.text('Bar'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('recipeEditorVenueDropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownMenuItem<String>).first);
      await tester.pumpAndSettle();

      await pickFirstIngredient(tester);
      await tester.enterText(
        find.byKey(const Key('recipeEditorQuantityField-0')),
        '2',
      );
      await tester.enterText(
        find.byKey(const Key('recipeEditorUnitField-0')),
        'oz',
      );

      await tester.scrollUntilVisible(
        find.byKey(const Key('recipeEditorSubmitButton')),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byKey(const Key('recipeEditorSubmitButton')));
      await tester.pumpAndSettle();

      expect(
        find.text('Integration Test Bar Recipe'),
        findsOneWidget,
        reason: 'bar-scoped recipe appears in the personal library list',
      );
      expectNoRawLocalizationKeys(tester);
    },
  );
}
