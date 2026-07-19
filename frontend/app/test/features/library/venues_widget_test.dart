import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/library/venues_screen.dart';

/// T061/T063: venues screen against a fake Dio interceptor, same convention
/// as channel_preferences_widget_test.dart.
void main() {
  testWidgets('lists venues and creates a new one', (tester) async {
    final interceptor = _FakeVenuesInterceptor();
    final venuesDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(interceptor);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          venuesApiProvider.overrideWithValue(
            VenuesApi(venuesDio, standardSerializers),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: VenuesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('The Alchemist'), findsOneWidget);

    await tester.tap(find.byKey(const Key('venueCreateFab')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('venueNameField')),
      'Second Bar',
    );
    await tester.tap(find.byKey(const Key('venueSubmitButton')));
    await tester.pumpAndSettle();

    expect(interceptor.lastCreatedName, 'Second Bar');
    expect(find.text('Second Bar'), findsOneWidget);
  });
}

class _FakeVenuesInterceptor extends Interceptor {
  final List<Map<String, dynamic>> _venues = [
    {
      'id': '11111111-1111-1111-1111-111111111111',
      'name': 'The Alchemist',
      'address': null,
      'latitude': null,
      'longitude': null,
      'externalReferences': <String>[],
      'createdAt': '2026-07-19T00:00:00Z',
    },
  ];
  String? lastCreatedName;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/venues' && options.method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'items': _venues, 'nextCursor': null},
        ),
      );
    }

    if (options.path == '/venues' && options.method == 'POST') {
      final body = options.data as Map<String, dynamic>;
      lastCreatedName = body['name'] as String;
      final created = {
        'id': '22222222-2222-2222-2222-222222222222',
        'name': body['name'],
        'address': body['address'],
        'latitude': body['latitude'],
        'longitude': body['longitude'],
        'externalReferences': <String>[],
        'createdAt': '2026-07-19T00:00:01Z',
      };
      _venues.add(created);
      return handler.resolve(
        Response(requestOptions: options, statusCode: 201, data: created),
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
