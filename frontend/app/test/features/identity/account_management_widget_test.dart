import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/identity/account_data_screen.dart';
import 'package:specpour_app/features/identity/account_lifecycle_screen.dart';
import 'package:specpour_app/features/identity/sessions_screen.dart';

import '../../support/no_raw_l10n_keys.dart';

/// T051/T052/T053: sessions, account-lifecycle, and account-data screens
/// against a fake Dio interceptor standing in for the identityApiProvider's
/// Dio, same convention as identity_widget_test.dart. These screens assume an
/// already-authenticated caller, so authTokenProvider is set directly (same
/// shorthand guest_gate_test.dart uses) rather than driving the full PKCE
/// exchange.
void main() {
  Widget buildTestApp(_FakeAccountInterceptor interceptor, Widget screen) {
    final identityDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(interceptor);

    final router = GoRouter(
      initialLocation: '/screen',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: Text('HOME', key: Key('homeMarker'))),
        ),
        GoRoute(path: '/screen', builder: (context, state) => screen),
      ],
    );

    return ProviderScope(
      overrides: [
        identityApiProvider.overrideWithValue(
          IdentityApi(identityDio, standardSerializers),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  group('SessionsScreen', () {
    testWidgets('lists sessions and revokes one', (tester) async {
      final interceptor = _FakeAccountInterceptor();
      await tester.pumpWidget(
        buildTestApp(interceptor, const SessionsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sessionCard-session-1')), findsOneWidget);
      expect(find.byKey(const Key('sessionCard-session-2')), findsOneWidget);

      await tester.tap(find.byKey(const Key('sessionRevokeButton-session-1')));
      await tester.pumpAndSettle();

      expect(interceptor.revokedSessionIds, contains('session-1'));
      expect(find.byKey(const Key('sessionCard-session-1')), findsNothing);
      expect(find.byKey(const Key('sessionCard-session-2')), findsOneWidget);
      expectNoRawLocalizationKeys(tester);
    });
  });

  group('AccountLifecycleScreen', () {
    testWidgets(
      'deactivating requires confirmation, then shows the reactivate button',
      (tester) async {
        final interceptor = _FakeAccountInterceptor();
        await tester.pumpWidget(
          buildTestApp(interceptor, const AccountLifecycleScreen()),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('accountLifecycleDeactivateButton')),
        );
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('accountLifecycleConfirmDialog')),
          findsOneWidget,
        );
        expect(interceptor.deactivateCallCount, 0);

        await tester.tap(
          find.byKey(const Key('accountLifecycleConfirmDialogButton')),
        );
        await tester.pumpAndSettle();

        expect(interceptor.deactivateCallCount, 1);
        expect(
          find.byKey(const Key('accountLifecycleReactivateButton')),
          findsOneWidget,
        );

        await tester.tap(
          find.byKey(const Key('accountLifecycleReactivateButton')),
        );
        await tester.pumpAndSettle();

        expect(interceptor.reactivateCallCount, 1);
        expect(
          find.byKey(const Key('accountLifecycleDeactivateButton')),
          findsOneWidget,
        );
        expectNoRawLocalizationKeys(tester);
      },
    );
  });

  group('AccountDataScreen', () {
    testWidgets('exports data and shows the date of birth', (tester) async {
      final interceptor = _FakeAccountInterceptor();
      await tester.pumpWidget(
        buildTestApp(interceptor, const AccountDataScreen()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('accountDataExportButton')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('accountDataExportDateOfBirth')),
        findsOneWidget,
      );
      expectNoRawLocalizationKeys(tester);
    });

    testWidgets('deleting requires confirmation, then navigates home', (
      tester,
    ) async {
      final interceptor = _FakeAccountInterceptor();
      await tester.pumpWidget(
        buildTestApp(interceptor, const AccountDataScreen()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('accountDataDeleteButton')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('accountDataDeleteConfirmDialog')),
        findsOneWidget,
      );
      expect(interceptor.deleteCallCount, 0);

      await tester.tap(
        find.byKey(const Key('accountDataDeleteConfirmDialogButton')),
      );
      await tester.pumpAndSettle();

      expect(interceptor.deleteCallCount, 1);
      expect(find.byKey(const Key('homeMarker')), findsOneWidget);
      expectNoRawLocalizationKeys(tester);
    });
  });
}

class _FakeAccountInterceptor extends Interceptor {
  final List<String> revokedSessionIds = [];
  int deactivateCallCount = 0;
  int reactivateCallCount = 0;
  int deleteCallCount = 0;
  bool _sessionOneRevoked = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/me/sessions' && options.method == 'GET') {
      final sessions = [
        if (!_sessionOneRevoked)
          {
            'id': 'session-1',
            'deviceDescription': 'Chrome on macOS',
            'createdAt': '2026-07-01T00:00:00Z',
            'lastSeenAt': '2026-07-14T00:00:00Z',
            // Not the current session — this test revokes session-1 as a plain
            // per-session revoke (current-session revoke = sign-out is covered
            // separately by account_menu_widget_test + web_sign_out_test).
            'isCurrent': false,
          },
        {
          'id': 'session-2',
          'deviceDescription': 'Safari on iOS',
          'createdAt': '2026-07-02T00:00:00Z',
          'lastSeenAt': '2026-07-13T00:00:00Z',
          'isCurrent': true,
        },
      ];
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'sessions': sessions},
        ),
      );
    }

    if (options.path.startsWith('/me/sessions/') &&
        options.method == 'DELETE') {
      final id = options.path.split('/').last;
      revokedSessionIds.add(id);
      if (id == 'session-1') {
        _sessionOneRevoked = true;
      }
      return handler.resolve(
        Response(requestOptions: options, statusCode: 204),
      );
    }

    if (options.path == '/me/deactivate') {
      deactivateCallCount++;
      return handler.resolve(
        Response(requestOptions: options, statusCode: 204),
      );
    }

    if (options.path == '/me/reactivate') {
      reactivateCallCount++;
      return handler.resolve(
        Response(requestOptions: options, statusCode: 204),
      );
    }

    if (options.path == '/me/export') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'userId': '11111111-1111-1111-1111-111111111111',
            'email': 'export-user@example.test',
            'displayName': 'Export User',
            'dateOfBirth': '1990-01-01',
            'unitPreference': 'Milliliters',
            'locale': 'en-US',
            'createdAt': '2026-01-01T00:00:00Z',
            'mfaEnabled': false,
            'sessions': <Map<String, dynamic>>[],
            'externalLoginProviders': <String>[],
          },
        ),
      );
    }

    if (options.path == '/me' && options.method == 'DELETE') {
      deleteCallCount++;
      return handler.resolve(
        Response(requestOptions: options, statusCode: 204),
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
