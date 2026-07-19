import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/library/recipe_editor_screen.dart';

void main() {
  testWidgets('creates a personal recipe with one ingredient line', (
    tester,
  ) async {
    // A tall test surface avoids ListView scrolling entirely — the dropdown
    // menu overlay's exit-transition timing otherwise leaves a stale
    // barrier absorbing the tap meant for the (scrolled-into-view) submit
    // button below it.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final catalogInterceptor = _FakeCatalogInterceptor();
    final catalogDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(catalogInterceptor);
    final ingredientsDio = Dio(
      BaseOptions(baseUrl: 'http://test.invalid/api/v1'),
    )..interceptors.add(_FakeIngredientsInterceptor());
    final venuesDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(_FakeEmptyVenuesInterceptor());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogApiProvider.overrideWithValue(
            CatalogApi(catalogDio, standardSerializers),
          ),
          ingredientsApiProvider.overrideWithValue(
            IngredientsApi(ingredientsDio, standardSerializers),
          ),
          venuesApiProvider.overrideWithValue(
            VenuesApi(venuesDio, standardSerializers),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RecipeEditorScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('recipeEditorPrimaryNameField')),
      'My Daiquiri Twist',
    );

    // DropdownButtonFormField's popup route (open → tap an item → close) is
    // unreliable to drive via raw tap offsets in this widget test harness —
    // the framework computes a valid Offset for the target DropdownMenuItem
    // but the actual hit test at that Offset lands on the button's own
    // hidden measurement copy of the same item instead of the live popup
    // one (a known DropdownButtonFormField testing flakiness). Driving
    // onChanged directly exercises the same state-update code path the real
    // selection would, without depending on the popup route's animation.
    final dropdown = tester.widget<DropdownButtonFormField<String>>(
      find.byKey(const Key('recipeEditorIngredientDropdown-0')),
    );
    dropdown.onChanged!('66666666-6666-6666-6666-666666666666');
    await tester.pumpAndSettle();

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

    expect(catalogInterceptor.lastCreatedPrimaryName, 'My Daiquiri Twist');
    expect(catalogInterceptor.lastLibraryScope, 'personal');
    expect(catalogInterceptor.lastIngredientId, isNotNull);
  });

  testWidgets('shows a local validation error with no name and no ingredient', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final catalogDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(_FakeCatalogInterceptor());
    final ingredientsDio = Dio(
      BaseOptions(baseUrl: 'http://test.invalid/api/v1'),
    )..interceptors.add(_FakeIngredientsInterceptor());
    final venuesDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(_FakeEmptyVenuesInterceptor());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogApiProvider.overrideWithValue(
            CatalogApi(catalogDio, standardSerializers),
          ),
          ingredientsApiProvider.overrideWithValue(
            IngredientsApi(ingredientsDio, standardSerializers),
          ),
          venuesApiProvider.overrideWithValue(
            VenuesApi(venuesDio, standardSerializers),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RecipeEditorScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('recipeEditorSubmitButton')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('recipeEditorSubmitButton')));
    await tester.pump();

    expect(find.byKey(const Key('recipeEditorErrorMessage')), findsOneWidget);
  });
}

class _FakeCatalogInterceptor extends Interceptor {
  String? lastCreatedPrimaryName;
  String? lastLibraryScope;
  String? lastIngredientId;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/recipes' && options.method == 'POST') {
      final body = options.data as Map<String, dynamic>;
      lastCreatedPrimaryName = body['primaryName'] as String;
      lastLibraryScope = body['libraryScope'] as String;
      final lines = (body['ingredientLines'] as List)
          .cast<Map<String, dynamic>>();
      lastIngredientId = lines.isEmpty
          ? null
          : lines.first['ingredientId'] as String;

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: {
            'id': '55555555-5555-5555-5555-555555555555',
            'primaryName': lastCreatedPrimaryName,
            'alternateNames': <String>[],
            'libraryScope': lastLibraryScope,
            'venueId': body['venueId'],
            'instructions': <String>[],
            'ingredientLines': <Map<String, dynamic>>[],
            'categoryIds': <String>[],
            'tags': <String>[],
            'visibility': 'private',
            'createdAt': '2026-07-19T00:00:00Z',
            'updatedAt': '2026-07-19T00:00:00Z',
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

class _FakeIngredientsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/ingredients' && options.method == 'GET') {
      final isPersonal = options.queryParameters['scope'] == 'personal';
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'items': isPersonal
                ? <Map<String, dynamic>>[]
                : [
                    {
                      'id': '66666666-6666-6666-6666-666666666666',
                      'name': 'White Rum',
                      'parentId': null,
                      'parentName': null,
                    },
                  ],
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

class _FakeEmptyVenuesInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/venues' && options.method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'items': <Map<String, dynamic>>[], 'nextCursor': null},
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
