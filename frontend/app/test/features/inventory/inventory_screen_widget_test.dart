import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/inventory/inventory_screen.dart';

import '../../support/no_raw_l10n_keys.dart';

/// T203 (coverage-ratchet fix for T070): widget tests for the inventory home
/// screen — the bottles list + delete flow, and the "What Can I Make?" tab
/// rendering makeable/near-miss recipes against fixture lines[] data, one
/// fixture per statement-§2 ladder grade (exact-product, class-satisfied,
/// substitution-named in makeable; missing in near-miss). Same fake-Dio-
/// interceptor convention as venues_widget_test.dart / library_widget_test.dart.
void main() {
  Widget wrap(Interceptor interceptor) {
    final dio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(interceptor);
    return ProviderScope(
      overrides: [
        inventoryApiProvider.overrideWithValue(
          InventoryApi(dio, standardSerializers),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: InventoryScreen(),
      ),
    );
  }

  testWidgets(
    'bottles tab lists items with quantity/bottle size and empty state is scoped to no items',
    (tester) async {
      final interceptor = _FakeInventoryInterceptor();
      await tester.pumpWidget(wrap(interceptor));
      await tester.pumpAndSettle();

      // Default tab is the bottles list.
      expect(
        find.byKey(
          const Key(
            'inventoryListItem-${_FakeInventoryInterceptor.beefeaterItemId}',
          ),
        ),
        findsOneWidget,
      );
      expect(find.text('Beefeater'), findsOneWidget);
      // Quantity + bottle size render together (spec.md scenario 4).
      expect(find.textContaining('750'), findsWidgets);
      expect(find.textContaining('750ml'), findsWidgets);
      // The second item has neither quantity nor bottle size → no subtitle.
      expect(find.text('Orange Curaçao'), findsOneWidget);
      expect(find.byKey(const Key('inventoryEmptyState')), findsNothing);
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets('bottles tab shows the empty state when there are no items', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(_FakeInventoryInterceptor(empty: true)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inventoryEmptyState')), findsOneWidget);
  });

  testWidgets(
    'deleting a bottle confirms, calls DELETE, and removes it from the list',
    (tester) async {
      final interceptor = _FakeInventoryInterceptor();
      await tester.pumpWidget(wrap(interceptor));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key(
            'inventoryDeleteButton-${_FakeInventoryInterceptor.beefeaterItemId}',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Confirmation dialog first — nothing deleted until confirmed.
      expect(
        find.byKey(const Key('inventoryDeleteConfirmDialog')),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const Key('inventoryDeleteConfirmDialogButton')),
      );
      await tester.pumpAndSettle();

      expect(
        interceptor.deletedIds,
        contains(_FakeInventoryInterceptor.beefeaterItemId),
      );
      expect(find.text('Beefeater'), findsNothing);
    },
  );

  testWidgets('deleting a bottle can be cancelled — nothing is deleted', (
    tester,
  ) async {
    final interceptor = _FakeInventoryInterceptor();
    await tester.pumpWidget(wrap(interceptor));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const Key(
          'inventoryDeleteButton-${_FakeInventoryInterceptor.beefeaterItemId}',
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Tap the non-keyed Cancel button in the dialog.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(interceptor.deletedIds, isEmpty);
    expect(find.text('Beefeater'), findsOneWidget);
  });

  testWidgets(
    'makeable tab renders each ladder grade and names a near-miss missing line',
    (tester) async {
      await tester.pumpWidget(wrap(_FakeInventoryInterceptor()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('inventoryMakeableTab')));
      await tester.pumpAndSettle();

      // One makeable recipe per ladder grade (exact-product, class-satisfied, substitution).
      expect(
        find.byKey(
          const Key(
            'makeableRecipeItem-${_FakeInventoryInterceptor.exactRecipeId}',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const Key(
            'makeableRecipeItem-${_FakeInventoryInterceptor.classRecipeId}',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const Key(
            'makeableRecipeItem-${_FakeInventoryInterceptor.substitutionRecipeId}',
          ),
        ),
        findsOneWidget,
      );
      // The near-miss recipe appears in its own section, naming the missing ingredient.
      expect(
        find.byKey(
          const Key(
            'nearMissRecipeItem-${_FakeInventoryInterceptor.nearMissRecipeId}',
          ),
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Orgeat'), findsWidgets);
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets(
    'makeable tab shows its own empty state when nothing is makeable',
    (tester) async {
      await tester.pumpWidget(
        wrap(_FakeInventoryInterceptor(emptyMakeable: true)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('inventoryMakeableTab')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('inventoryMakeableEmptyState')),
        findsOneWidget,
      );
    },
  );

  testWidgets('surfaces an API error on the bottles tab', (tester) async {
    await tester.pumpWidget(wrap(_FakeInventoryInterceptor(failList: true)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('apiErrorCopyButton')), findsOneWidget);
  });
}

class _FakeInventoryInterceptor extends Interceptor {
  _FakeInventoryInterceptor({
    this.empty = false,
    this.emptyMakeable = false,
    this.failList = false,
  });

  final bool empty;
  final bool emptyMakeable;
  final bool failList;

  static const beefeaterItemId = '11111111-0000-0000-0000-000000000001';
  static const curacaoItemId = '11111111-0000-0000-0000-000000000002';
  static const exactRecipeId = '22222222-0000-0000-0000-000000000001';
  static const classRecipeId = '22222222-0000-0000-0000-000000000002';
  static const substitutionRecipeId = '22222222-0000-0000-0000-000000000003';
  static const nearMissRecipeId = '22222222-0000-0000-0000-000000000004';

  final List<String> deletedIds = [];

  Map<String, dynamic> _item(
    String id,
    String name, {
    num? quantity,
    String? bottleSize,
  }) => {
    'id': id,
    'ingredientId': '33333333-0000-0000-0000-${id.substring(24)}',
    'ingredientName': name,
    'quantity': quantity,
    'bottleSize': bottleSize,
    'source': 'manual',
    'addedAt': '2026-07-19T00:00:00Z',
  };

  Map<String, dynamic> _requirement(String name) => {
    'ingredientId': '44444444-0000-0000-0000-000000000001',
    'ingredientName': name,
    'quantity': 2,
    'unit': 'oz',
  };

  Map<String, dynamic> _satisfiedBy(String name) => {
    'inventoryItemId': beefeaterItemId,
    'ingredientId': '33333333-0000-0000-0000-000000000001',
    'ingredientName': name,
  };

  Map<String, dynamic> _makeable(String id, String name, String quality) => {
    'recipeId': id,
    'recipeName': name,
    'matchQuality': quality,
    'lines': [
      {
        'requirement': _requirement('London Dry Gin'),
        'matchQuality': quality,
        'satisfiedBy': _satisfiedBy('Beefeater'),
      },
    ],
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/inventory/items' && options.method == 'GET') {
      if (failList) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 500),
          ),
        );
      }
      final items = empty
          ? <Map<String, dynamic>>[]
          : [
              _item(
                beefeaterItemId,
                'Beefeater',
                quantity: 750,
                bottleSize: '750ml',
              ),
              _item(curacaoItemId, 'Orange Curaçao'),
            ].where((i) => !deletedIds.contains(i['id'])).toList();
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'items': items, 'nextCursor': null},
        ),
      );
    }

    if (options.path.startsWith('/inventory/items/') &&
        options.method == 'DELETE') {
      deletedIds.add(options.path.split('/').last);
      return handler.resolve(
        Response(requestOptions: options, statusCode: 204),
      );
    }

    if (options.path == '/inventory/makeable' && options.method == 'GET') {
      final makeable = emptyMakeable
          ? <Map<String, dynamic>>[]
          : [
              _makeable(exactRecipeId, 'Gin & Tonic', 'exact-product'),
              _makeable(classRecipeId, 'Martini', 'class-satisfied'),
              _makeable(substitutionRecipeId, 'Negroni', 'substitution'),
            ];
      final nearMiss = emptyMakeable
          ? <Map<String, dynamic>>[]
          : [
              {
                'recipeId': nearMissRecipeId,
                'recipeName': 'Mai Tai',
                'lines': [
                  {
                    'requirement': _requirement('London Dry Gin'),
                    'matchQuality': 'class-satisfied',
                    'satisfiedBy': _satisfiedBy('Beefeater'),
                  },
                  {
                    'requirement': _requirement('Orgeat'),
                    'matchQuality': 'missing',
                    'satisfiedBy': null,
                  },
                ],
              },
            ];
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'makeable': makeable, 'nearMiss': nearMiss},
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
