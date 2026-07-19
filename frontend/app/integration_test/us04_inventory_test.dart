import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:specpour_app/core/app.dart';
import 'package:specpour_app/core/routing/app_router.dart';

import 'support/no_raw_l10n_keys.dart';
import 'support/register_fresh_account.dart';

/// T065: Flutter integration test for US4 (track inventory and ask "what can
/// I make?" — spec.md scenarios 1 (manual entry; photo/barcode are UI-present
/// but not exercised here, same "untestable without real credentials/a real
/// device camera" posture as T173's social-sign-in buttons) and 2 (a held
/// ingredient satisfies a recipe that specifies it). Run on a real
/// device/browser against a real backend, same convention as
/// integration_test/us03_author_test.dart. No gated action is wired up on
/// Discover for /inventory beyond direct routing, same shorthand
/// us02/us03's own tests already established.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Opens the recipe editor's first ingredient-line picker and selects
  /// whichever option renders first (alphabetically, per
  /// IngredientEndpoints.ListAsync's own OrderBy(i => i.Name)) — same
  /// convention as us03_author_test.dart's own pickFirstIngredient.
  Future<void> pickFirstRecipeIngredient(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('recipeEditorIngredientDropdown-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
  }

  /// Opens the add-inventory screen's ingredient Autocomplete and selects
  /// whichever option renders first — empty text shows every curated
  /// ingredient (AddInventoryScreen's optionsBuilder), same alphabetical
  /// order as the recipe editor's own picker, so a fresh account (no
  /// personal ingredients yet) picks the SAME ingredient both places.
  /// Autocomplete's default options overlay renders as a ListView of
  /// InkWells (Flutter's own `_AutocompleteOptionsList`, not ListTiles) —
  /// scoped to a descendant-of-ListView search since AddInventoryScreen has
  /// no ListView of its own, so this can't collide with its other buttons
  /// (which use InkWell internally too, but aren't ListView descendants).
  Future<void> pickFirstInventoryIngredient(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('addInventoryIngredientField')));
    await tester.pumpAndSettle();
    await tester.tap(
      find
          .descendant(of: find.byType(ListView), matching: find.byType(InkWell))
          .first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    '1: a user adds inventory by manual entry and it appears in their bottles (spec.md scenario 1)',
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
        testTag: 'integration-us04-manual',
      );

      capturedRef.read(appRouterProvider).go('/inventory');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('inventoryEmptyState')), findsOneWidget);

      await tester.tap(find.byKey(const Key('inventoryAddFab')));
      await tester.pumpAndSettle();

      await pickFirstInventoryIngredient(tester);
      await tester.enterText(
        find.byKey(const Key('addInventoryQuantityField')),
        '750',
      );
      await tester.enterText(
        find.byKey(const Key('addInventoryBottleSizeField')),
        '750ml',
      );
      await tester.tap(find.byKey(const Key('addInventorySubmitButton')));
      await tester.pumpAndSettle();

      // The add screen pops back to the inventory list on success.
      expect(find.byKey(const Key('inventoryEmptyState')), findsNothing);
      expect(
        find.textContaining('750'),
        findsWidgets,
        reason: 'the tracked quantity/bottle size display (spec.md scenario 4)',
      );
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets(
    '2: a held ingredient satisfies a recipe that specifies it (spec.md scenario 2, exact-product case)',
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
        testTag: 'integration-us04-makeable',
      );

      // A one-ingredient-line recipe: the same "first" curated ingredient the
      // inventory picker will also select, so the whole recipe becomes fully
      // makeable from a single inventory item (exact-product match).
      capturedRef.read(appRouterProvider).go('/library/recipes/new');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('recipeEditorPrimaryNameField')),
        'Integration Test Makeable Recipe',
      );
      await pickFirstRecipeIngredient(tester);
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

      capturedRef.read(appRouterProvider).go('/inventory');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('inventoryAddFab')));
      await tester.pumpAndSettle();
      await pickFirstInventoryIngredient(tester);
      await tester.tap(find.byKey(const Key('addInventorySubmitButton')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('inventoryMakeableTab')));
      await tester.pumpAndSettle();

      expect(
        find.text('Integration Test Makeable Recipe'),
        findsOneWidget,
        reason: 'the recipe appears on the makeable tab (T067/T148)',
      );
      expectNoRawLocalizationKeys(tester);
    },
  );
}
