import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/library/library_screen.dart';

void main() {
  testWidgets('lists personal recipes and house-made ingredients', (
    tester,
  ) async {
    final catalogDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(_FakeRecipesInterceptor());
    final ingredientsDio = Dio(
      BaseOptions(baseUrl: 'http://test.invalid/api/v1'),
    )..interceptors.add(_FakeIngredientsInterceptor());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogApiProvider.overrideWithValue(
            CatalogApi(catalogDio, standardSerializers),
          ),
          ingredientsApiProvider.overrideWithValue(
            IngredientsApi(ingredientsDio, standardSerializers),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LibraryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Daiquiri Twist'), findsOneWidget);
    expect(find.text('House Grenadine'), findsOneWidget);
  });

  testWidgets('shows empty states with no personal content', (tester) async {
    final catalogDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(_FakeRecipesInterceptor(empty: true));
    final ingredientsDio = Dio(
      BaseOptions(baseUrl: 'http://test.invalid/api/v1'),
    )..interceptors.add(_FakeIngredientsInterceptor(empty: true));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogApiProvider.overrideWithValue(
            CatalogApi(catalogDio, standardSerializers),
          ),
          ingredientsApiProvider.overrideWithValue(
            IngredientsApi(ingredientsDio, standardSerializers),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LibraryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('libraryRecipesEmptyState')), findsOneWidget);
    expect(
      find.byKey(const Key('libraryIngredientsEmptyState')),
      findsOneWidget,
    );
  });
}

class _FakeRecipesInterceptor extends Interceptor {
  _FakeRecipesInterceptor({this.empty = false});

  final bool empty;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/recipes' && options.method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'items': empty
                ? <Map<String, dynamic>>[]
                : [
                    {
                      'id': '33333333-3333-3333-3333-333333333333',
                      'primaryName': 'My Daiquiri Twist',
                      'familyKey': null,
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

class _FakeIngredientsInterceptor extends Interceptor {
  _FakeIngredientsInterceptor({this.empty = false});

  final bool empty;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/ingredients' && options.method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'items': empty
                ? <Map<String, dynamic>>[]
                : [
                    {
                      'id': '44444444-4444-4444-4444-444444444444',
                      'name': 'House Grenadine',
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
