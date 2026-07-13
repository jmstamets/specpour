import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/app.dart';

import '../../support/no_raw_l10n_keys.dart';

/// T031's sandbox-runnable twin of integration_test/us01_discover_test.dart —
/// drives the real DiscoverScreen/RecipeDetailScreen (T041/T042) against a fake
/// Dio interceptor standing in for the backend, since no device/emulator/real
/// server is available in this environment (same limitation noted since Phase
/// 1). Canned responses mirror the real backend's actual response shape,
/// verified by hand against a live server in the T036-T040 sub-checkpoint.
void main() {
  late _FakeCatalogInterceptor interceptor;

  setUp(() {
    interceptor = _FakeCatalogInterceptor();
  });

  ProviderScope buildApp() {
    final dio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(interceptor);

    return ProviderScope(
      overrides: [
        catalogApiProvider.overrideWithValue(
          CatalogApi(dio, standardSerializers),
        ),
        searchApiProvider.overrideWithValue(
          SearchApi(dio, standardSerializers),
        ),
        ingredientsApiProvider.overrideWithValue(
          IngredientsApi(dio, standardSerializers),
        ),
        equipmentApiProvider.overrideWithValue(
          EquipmentApi(dio, standardSerializers),
        ),
      ],
      child: const SpecPourApp(),
    );
  }

  testWidgets(
    '1: a guest can search the curated library by name and open a full recipe',
    (tester) async {
      await tester.pumpWidget(buildApp());
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

      // T158 regression: ice and garnish are separate, correctly-labeled lines
      // (the walkthrough caught the ice spec rendered under the Garnish label).
      expect(find.text('Ice: Crushed'), findsOneWidget);
      expect(find.text('Garnish: Mint sprig'), findsOneWidget);

      // T157: no raw localization keys anywhere on the detail screen.
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets(
    '2: a recipe containing egg white shows a prominent allergen flag',
    (tester) async {
      await tester.pumpWidget(buildApp());
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
      // T157: the chip shows the display name, not the raw key.
      expect(find.text('Egg'), findsOneWidget);
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets('3: an anonymous visitor can browse without an account', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('discoverBrowseList')), findsOneWidget);
    expect(find.byKey(const Key('accountGateSignInPrompt')), findsNothing);

    // T157 regression (walkthrough defect): browse subtitles resolved the
    // family taxonomy keys — "Sour", never "family.sour".
    expect(find.text('Sour'), findsWidgets);
    expect(find.text('family.sour'), findsNothing);
    expectNoRawLocalizationKeys(tester);
  });

  testWidgets(
    '4: search results are typed and grouped by entity kind (amended FR-049)',
    (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('discoverSearchField')),
        'rum',
      );
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // Group headers present for each returned type, absent for types with no
      // results (no Equipment group in the canned 'rum' response).
      expect(
        find.byKey(const Key('discoverSearchGroup-recipes')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('discoverSearchGroup-ingredients')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('discoverSearchGroup-glossary')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('discoverSearchGroup-equipment')),
        findsNothing,
      );

      // The recipe result stays navigable within its group.
      expect(find.byKey(const Key('recipeResultTile-mai-tai')), findsOneWidget);

      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets(
    '5: tapping an ingredient line or a glassware chip opens an entity info '
    'popover with a link to the full entry (T156)',
    (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('discoverSearchField')),
        'Mai Tai',
      );
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('recipeResultTile-mai-tai')));
      await tester.pumpAndSettle();

      // Ingredient line -> popover -> full entry navigates to the ingredient.
      await tester.tap(
        find.byKey(
          const Key(
            'recipeIngredientLine-33333333-3333-3333-3333-333333333333',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('entityInfoPopover')), findsOneWidget);
      expect(find.text('Aged Rum'), findsWidgets);
      expect(find.text('A dark, full-bodied aged rum.'), findsOneWidget);
      expectNoRawLocalizationKeys(tester);

      await tester.tap(
        find.byKey(const Key('entityInfoPopoverFullEntryButton')),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('ingredientDetailScreen')), findsOneWidget);
      expect(
        find.text('A dark, full-bodied aged rum.'),
        findsOneWidget,
        reason: 'full entry shows the same description as the popover',
      );
      expectNoRawLocalizationKeys(tester);

      // Back to the recipe, then the glassware chip -> popover -> full entry
      // navigates to the equipment/glassware screen.
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key(
            'recipeGlasswareChip-66666666-6666-6666-6666-666666666666',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('entityInfoPopover')), findsOneWidget);
      expect(find.text('Old-Fashioned Glass'), findsWidgets);
      expectNoRawLocalizationKeys(tester);

      await tester.tap(
        find.byKey(const Key('entityInfoPopoverFullEntryButton')),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('equipmentDetailScreen')), findsOneWidget);
      expect(find.text('Category: Glassware'), findsOneWidget);
      expectNoRawLocalizationKeys(tester);
    },
  );
}

class _FakeCatalogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;

    if (path == '/recipes' && options.queryParameters['family'] == null) {
      return handler.resolve(
        _jsonResponse(options, {
          'items': [
            {
              'id': '11111111-1111-1111-1111-111111111111',
              'primaryName': 'Mai Tai',
              'familyKey': 'family.sour',
            },
            {
              'id': '22222222-2222-2222-2222-222222222222',
              'primaryName': 'Whiskey Flip',
              'familyKey': 'family.flip',
            },
          ],
          'nextCursor': null,
        }),
      );
    }

    if (path == '/search') {
      final query = options.queryParameters['q'] as String?;
      final items = switch (query) {
        'Mai Tai' => [
          {
            'entityType': 'recipe',
            'entityId': '11111111-1111-1111-1111-111111111111',
            'title': 'Mai Tai',
            'snippet': null,
            'score': 1.0,
          },
        ],
        'Whiskey Flip' => [
          {
            'entityType': 'recipe',
            'entityId': '22222222-2222-2222-2222-222222222222',
            'title': 'Whiskey Flip',
            'snippet': null,
            'score': 1.0,
          },
        ],
        // Mixed-type results for the FR-049 typed/grouped presentation test.
        'rum' => [
          {
            'entityType': 'recipe',
            'entityId': '11111111-1111-1111-1111-111111111111',
            'title': 'Mai Tai',
            'snippet': null,
            'score': 0.9,
          },
          {
            'entityType': 'ingredient',
            'entityId': '33333333-3333-3333-3333-333333333333',
            'title': 'Aged Rum',
            'snippet': null,
            'score': 0.8,
          },
          {
            'entityType': 'glossaryTerm',
            'entityId': '55555555-5555-5555-5555-555555555555',
            'title': 'Rhum Agricole',
            'snippet': null,
            'score': 0.7,
          },
        ],
        _ => <Map<String, Object?>>[],
      };

      return handler.resolve(
        _jsonResponse(options, {'items': items, 'nextCursor': null}),
      );
    }

    if (path == '/recipes/11111111-1111-1111-1111-111111111111') {
      return handler.resolve(_jsonResponse(options, _maiTaiDetail));
    }

    if (path == '/recipes/22222222-2222-2222-2222-222222222222') {
      return handler.resolve(_jsonResponse(options, _whiskeyFlipDetail));
    }

    // T156: entity info popover full-entry fetches.
    if (path == '/ingredients/33333333-3333-3333-3333-333333333333') {
      return handler.resolve(
        _jsonResponse(options, {
          'id': '33333333-3333-3333-3333-333333333333',
          'name': 'Aged Rum',
          'parentId': null,
          'parentName': null,
          'sources': ['Appleton Estate', 'Mount Gay'],
          'description': 'A dark, full-bodied aged rum.',
          'abvPercent': 40.0,
          'allergens': <String>[],
          'definingRecipeId': null,
          'definingRecipeName': null,
          'yieldQuantity': null,
          'yieldUnit': null,
          'shelfLife': null,
          'storageInstructions': null,
        }),
      );
    }

    if (path == '/equipment/66666666-6666-6666-6666-666666666666') {
      return handler.resolve(
        _jsonResponse(options, {
          'id': '66666666-6666-6666-6666-666666666666',
          'name': 'Old-Fashioned Glass',
          'category': 'Glassware',
          'cost': null,
          'description': 'A short, heavy-based tumbler.',
          'usageGuidance': null,
          'typicalApplications': <String>[],
        }),
      );
    }

    handler.reject(
      DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 404),
      ),
    );
  }

  Response<Object?> _jsonResponse(RequestOptions options, Object? data) =>
      Response(requestOptions: options, statusCode: 200, data: data);

  static const _maiTaiDetail = {
    'id': '11111111-1111-1111-1111-111111111111',
    'primaryName': 'Mai Tai',
    'alternateNames': ["Trader Vic's Mai Tai"],
    'familyKey': 'family.sour',
    'categoryKeys': <String>[],
    'flavorProfileKeys': <String>[],
    'tags': <String>[],
    'ingredientLines': [
      {
        'position': 1,
        'ingredientId': '33333333-3333-3333-3333-333333333333',
        'ingredientName': 'Aged Rum',
        'quantity': 1.5,
        'unit': 'oz',
        'purpose': null,
        'scalingRule': 'Linear',
      },
    ],
    'instructions': ['Shake with crushed ice.'],
    'garnishes': ['Mint sprig'],
    'iceSpec': 'Crushed',
    'glassware': [
      {
        'id': '66666666-6666-6666-6666-666666666666',
        'name': 'Old-Fashioned Glass',
      },
    ],
    'equipment': <Map<String, Object?>>[],
    'creatorAttribution': 'Trader Vic',
    'history': 'Created in 1944.',
    'notes': null,
    'abvPercent': 16.81,
    'standardDrinks': 1.25,
    'allergens': <String>[],
  };

  static const _whiskeyFlipDetail = {
    'id': '22222222-2222-2222-2222-222222222222',
    'primaryName': 'Whiskey Flip',
    'alternateNames': <String>[],
    'familyKey': 'family.flip',
    'categoryKeys': <String>[],
    'flavorProfileKeys': <String>[],
    'tags': <String>[],
    'ingredientLines': [
      {
        'position': 1,
        'ingredientId': '44444444-4444-4444-4444-444444444444',
        'ingredientName': 'Whole Egg',
        'quantity': 1.0,
        'unit': 'whole',
        'purpose': 'Texture',
        'scalingRule': 'Linear',
      },
    ],
    'instructions': ['Dry shake.', 'Shake with ice.'],
    'garnishes': ['Grated nutmeg'],
    'iceSpec': 'None (served up)',
    'glassware': <Map<String, Object?>>[],
    'equipment': <Map<String, Object?>>[],
    'creatorAttribution': null,
    'history': null,
    'notes': null,
    'abvPercent': 12.4,
    'standardDrinks': 1.1,
    'allergens': ['egg'],
  };
}
