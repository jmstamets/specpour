import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/inventory/add_inventory_screen.dart';

import '../../support/no_raw_l10n_keys.dart';

/// T203 (coverage-ratchet fix for T070): widget tests for the add-inventory
/// screen — manual entry (the happy path), local validation, and the
/// photo-recognition branches (degrade-to-manual and prefill-on-recognized),
/// driven through a fake ImagePickerPlatform so no real device camera is
/// needed. The barcode path (mobile_scanner) genuinely requires a camera and
/// is a browser/device concern, exercised by T065's integration test, not here.
void main() {
  const beefeaterId = '33333333-0000-0000-0000-000000000001';

  Widget wrap(_FakeInventoryInterceptor inventory) {
    final inventoryDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(inventory);
    final ingredientsDio = Dio(
      BaseOptions(baseUrl: 'http://test.invalid/api/v1'),
    )..interceptors.add(_FakeIngredientsInterceptor());
    return ProviderScope(
      overrides: [
        inventoryApiProvider.overrideWithValue(
          InventoryApi(inventoryDio, standardSerializers),
        ),
        ingredientsApiProvider.overrideWithValue(
          IngredientsApi(ingredientsDio, standardSerializers),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AddInventoryScreen(),
      ),
    );
  }

  testWidgets(
    'manual entry: pick a bottle, add quantity/size, submit posts source=manual',
    (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final inventory = _FakeInventoryInterceptor();
      await tester.pumpWidget(wrap(inventory));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('addInventoryIngredientField')),
        'Beef',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beefeater').last);
      await tester.pumpAndSettle();

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

      expect(inventory.lastCreatedIngredientId, beefeaterId);
      expect(inventory.lastCreatedSource, 'manual');
      expect(inventory.lastCreatedQuantity, 750);
      expect(inventory.lastCreatedBottleSize, '750ml');
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets(
    'submitting without choosing a bottle shows a local validation error',
    (tester) async {
      final inventory = _FakeInventoryInterceptor();
      await tester.pumpWidget(wrap(inventory));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('addInventorySubmitButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('addInventoryErrorMessage')), findsOneWidget);
      expect(inventory.lastCreatedIngredientId, isNull);
    },
  );

  testWidgets(
    'photo recognition that fails degrades to a manual-entry prompt',
    (tester) async {
      ImagePickerPlatform.instance = _FakeImagePicker('/tmp/fake-bottle.jpg');
      addTearDown(() => ImagePickerPlatform.instance = _FakeImagePicker(null));

      await tester.pumpWidget(
        wrap(
          _FakeInventoryInterceptor(recognize: _RecognizeMode.notRecognized),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('addInventoryPhotoButton')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('addInventoryStatusMessage')),
        findsOneWidget,
      );
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets('photo recognition that succeeds prefills the picker', (
    tester,
  ) async {
    ImagePickerPlatform.instance = _FakeImagePicker('/tmp/fake-bottle.jpg');
    addTearDown(() => ImagePickerPlatform.instance = _FakeImagePicker(null));

    await tester.pumpWidget(
      wrap(_FakeInventoryInterceptor(recognize: _RecognizeMode.recognized)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('addInventoryPhotoButton')));
    await tester.pumpAndSettle();

    // The recognized candidate prefills the picker field and shows a status message.
    expect(find.byKey(const Key('addInventoryStatusMessage')), findsOneWidget);
    expect(find.text('Beefeater'), findsWidgets);
  });

  testWidgets('a cancelled photo pick is a no-op', (tester) async {
    ImagePickerPlatform.instance = _FakeImagePicker(null);
    addTearDown(() => ImagePickerPlatform.instance = _FakeImagePicker(null));

    await tester.pumpWidget(wrap(_FakeInventoryInterceptor()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('addInventoryPhotoButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('addInventoryStatusMessage')), findsNothing);
  });
}

enum _RecognizeMode { notRecognized, recognized }

class _FakeImagePicker extends ImagePickerPlatform
    with MockPlatformInterfaceMixin {
  _FakeImagePicker(this.path);
  final String? path;

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async => path == null ? null : XFile(path!);
}

class _FakeInventoryInterceptor extends Interceptor {
  _FakeInventoryInterceptor({this.recognize = _RecognizeMode.notRecognized});

  final _RecognizeMode recognize;

  static const beefeaterId = '33333333-0000-0000-0000-000000000001';

  String? lastCreatedIngredientId;
  String? lastCreatedSource;
  num? lastCreatedQuantity;
  String? lastCreatedBottleSize;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/inventory/recognize' && options.method == 'POST') {
      final recognized = recognize == _RecognizeMode.recognized;
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'recognized': recognized,
            'candidateIngredientId': recognized ? beefeaterId : null,
            'manualEntryForm': {
              'prefilledIngredientId': recognized ? beefeaterId : null,
              'prefilledIngredientName': recognized ? 'Beefeater' : null,
            },
          },
        ),
      );
    }

    if (options.path == '/inventory/items' && options.method == 'POST') {
      final body = options.data as Map<String, dynamic>;
      lastCreatedIngredientId = body['ingredientId'] as String?;
      lastCreatedSource = body['source'] as String?;
      lastCreatedQuantity = body['quantity'] as num?;
      lastCreatedBottleSize = body['bottleSize'] as String?;
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: {
            'id': '55555555-0000-0000-0000-000000000001',
            'ingredientId': body['ingredientId'],
            'ingredientName': 'Beefeater',
            'quantity': body['quantity'],
            'bottleSize': body['bottleSize'],
            'source': body['source'],
            'addedAt': '2026-07-19T00:00:00Z',
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
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'items': [
              {
                'id': '33333333-0000-0000-0000-000000000001',
                'name': 'Beefeater',
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
