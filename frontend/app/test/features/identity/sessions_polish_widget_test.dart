import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/identity/sessions_screen.dart';

import '../../support/no_raw_l10n_keys.dart';

/// T189: sessions-list polish — "This device" badge, humanized device
/// descriptions with the raw UA one tap away, and the current session's revoke
/// button reading "Sign out" (since revoking your own session signs you out).
void main() {
  const currentUa =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0';

  Widget buildApp() {
    final dio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(_FakeSessionsInterceptor(currentUa));
    return ProviderScope(
      overrides: [
        identityApiProvider.overrideWithValue(
          IdentityApi(dio, standardSerializers),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SessionsScreen(),
      ),
    );
  }

  testWidgets('marks the current session and humanizes its device', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Current session: "This device" badge + humanized title + Sign out button.
    expect(
      find.byKey(const Key('sessionThisDeviceBadge-current')),
      findsOneWidget,
    );
    expect(find.text('Edge on Windows'), findsOneWidget);
    expect(find.byKey(const Key('sessionThisDeviceBadge-other')), findsNothing);

    // The current session's revoke reads "Sign out"; the other reads "Revoke".
    expect(
      tester
          .widget<Text>(
            find.descendant(
              of: find.byKey(const Key('sessionRevokeButton-current')),
              matching: find.byType(Text),
            ),
          )
          .data,
      'Sign out',
    );
    expect(
      tester
          .widget<Text>(
            find.descendant(
              of: find.byKey(const Key('sessionRevokeButton-other')),
              matching: find.byType(Text),
            ),
          )
          .data,
      'Revoke',
    );
    expectNoRawLocalizationKeys(tester);
  });

  testWidgets('reveals the raw user agent on tapping details', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Raw UA hidden until the details toggle is tapped.
    expect(find.byKey(const Key('sessionRawUserAgent-current')), findsNothing);
    await tester.tap(find.byKey(const Key('sessionDetailsToggle-current')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('sessionRawUserAgent-current')),
      findsOneWidget,
    );
    expect(find.text(currentUa), findsOneWidget);
  });
}

class _FakeSessionsInterceptor extends Interceptor {
  _FakeSessionsInterceptor(this.currentUa);

  final String currentUa;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/me/sessions' && options.method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'sessions': [
              {
                'id': 'current',
                'deviceDescription': currentUa,
                'createdAt': '2026-07-01T00:00:00Z',
                'lastSeenAt': '2026-07-18T00:00:00Z',
                'isCurrent': true,
              },
              {
                'id': 'other',
                'deviceDescription': 'some-native-client/1.0',
                'createdAt': '2026-07-02T00:00:00Z',
                'lastSeenAt': '2026-07-17T00:00:00Z',
                'isCurrent': false,
              },
            ],
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
