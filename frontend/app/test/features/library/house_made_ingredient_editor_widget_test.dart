import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/library/house_made_ingredient_editor_screen.dart';

void main() {
  testWidgets('creates a house-made ingredient with an existing component '
      'recipe', (tester) async {
    // A tall test surface avoids ListView scrolling entirely — see the
    // matching comment in recipe_editor_widget_test.dart.
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final ingredientsInterceptor = _FakeIngredientsInterceptor();
    final ingredientsDio = Dio(
      BaseOptions(baseUrl: 'http://test.invalid/api/v1'),
    )..interceptors.add(ingredientsInterceptor);
    final catalogDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(_FakeCatalogInterceptor());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ingredientsApiProvider.overrideWithValue(
            IngredientsApi(ingredientsDio, standardSerializers),
          ),
          catalogApiProvider.overrideWithValue(
            CatalogApi(catalogDio, standardSerializers),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HouseMadeIngredientEditorScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('houseMadeEditorNameField')),
      'House Grenadine',
    );

    await tester.tap(
      find.byKey(const Key('houseMadeEditorDefiningRecipeDropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Grenadine (component recipe)').last);
    await tester.pumpAndSettle();

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

    expect(ingredientsInterceptor.lastCreatedName, 'House Grenadine');
    expect(ingredientsInterceptor.lastShelfLifeDays, 30);
    expect(ingredientsInterceptor.lastDefiningRecipeId, isNotNull);
  });

  testWidgets('prompts to create a component recipe when none exist yet', (
    tester,
  ) async {
    final ingredientsDio = Dio(
      BaseOptions(baseUrl: 'http://test.invalid/api/v1'),
    )..interceptors.add(_FakeIngredientsInterceptor());
    final catalogDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(_FakeCatalogInterceptor(hasRecipes: false));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ingredientsApiProvider.overrideWithValue(
            IngredientsApi(ingredientsDio, standardSerializers),
          ),
          catalogApiProvider.overrideWithValue(
            CatalogApi(catalogDio, standardSerializers),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HouseMadeIngredientEditorScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('houseMadeEditorCreateComponentRecipeButton')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('houseMadeEditorDefiningRecipeDropdown')),
      findsNothing,
    );
  });
}

class _FakeIngredientsInterceptor extends Interceptor {
  String? lastCreatedName;
  int? lastShelfLifeDays;
  String? lastDefiningRecipeId;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/ingredients' && options.method == 'POST') {
      final body = options.data as Map<String, dynamic>;
      lastCreatedName = body['name'] as String;
      final houseMade = body['houseMade'] as Map<String, dynamic>;
      lastShelfLifeDays = houseMade['shelfLifeDays'] as int;
      lastDefiningRecipeId = houseMade['definingRecipeId'] as String;

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: {
            'id': '77777777-7777-7777-7777-777777777777',
            'name': lastCreatedName,
            'libraryScope': 'personal',
            'venueId': null,
            'categoryId': '00000000-0000-0000-0000-000000000207',
            'parentId': null,
            'abvPercent': null,
            'sources': <String>[],
            'description': null,
            'visibility': 'private',
            'houseMade': {
              'definingRecipeId': lastDefiningRecipeId,
              'definingRecipeName': 'Grenadine (component recipe)',
              'yieldQuantity': houseMade['yieldQuantity'],
              'yieldUnit': houseMade['yieldUnit'],
              'shelfLifeDays': lastShelfLifeDays,
              'storageInstructions': houseMade['storageInstructions'],
            },
          },
        ),
      );
    }

    handler.reject(
      DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 404),
      ),
    );
  }
}

class _FakeCatalogInterceptor extends Interceptor {
  _FakeCatalogInterceptor({this.hasRecipes = true});

  final bool hasRecipes;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/recipes' && options.method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'items': hasRecipes
                ? [
                    {
                      'id': '88888888-8888-8888-8888-888888888888',
                      'primaryName': 'Grenadine (component recipe)',
                      'familyKey': null,
                    },
                  ]
                : <Map<String, dynamic>>[],
            'nextCursor': null,
          },
        ),
      );
    }

    handler.reject(
      DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 404),
      ),
    );
  }
}
