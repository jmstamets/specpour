import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/auth/token_store.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/identity/account_menu_screen.dart';

/// T161: the account/settings navigation shell — verifies each destination
/// actually navigates, since the whole point of this screen is making the
/// four (soon five) previously-unreachable screens reachable.
void main() {
  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/account',
      routes: [
        GoRoute(
          path: '/account',
          builder: (context, state) => const AccountMenuScreen(),
        ),
        GoRoute(
          path: '/account/mfa',
          builder: (context, state) => const _DestinationMarker('mfa'),
        ),
        GoRoute(
          path: '/account/sessions',
          builder: (context, state) => const _DestinationMarker('sessions'),
        ),
        GoRoute(
          path: '/account/channels',
          builder: (context, state) => const _DestinationMarker('channels'),
        ),
        GoRoute(
          path: '/account/data',
          builder: (context, state) => const _DestinationMarker('data'),
        ),
        GoRoute(
          path: '/account/lifecycle',
          builder: (context, state) => const _DestinationMarker('lifecycle'),
        ),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  for (final (buttonKey, destination) in [
    ('accountMenuMfaButton', 'mfa'),
    ('accountMenuSessionsButton', 'sessions'),
    ('accountMenuChannelsButton', 'channels'),
    ('accountMenuDataButton', 'data'),
    ('accountMenuLifecycleButton', 'lifecycle'),
  ]) {
    testWidgets('tapping $buttonKey navigates to /account/$destination', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(buttonKey)));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('destination-$destination')), findsOneWidget);
    });
  }

  // T188: sign out revokes the current session, clears auth state, and lands
  // on Discover signed out.
  testWidgets('tapping Sign out clears auth state and lands on Discover', (
    tester,
  ) async {
    final interceptor = _FakeSignOutInterceptor();
    final tokenStore = _InMemoryTokenStore()..stored = 'persisted-refresh';
    late WidgetRef capturedRef;

    final identityDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(interceptor);

    final router = GoRouter(
      initialLocation: '/account',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: Text('DISCOVER', key: Key('discoverMarker')),
          ),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const AccountMenuScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          identityApiProvider.overrideWithValue(
            IdentityApi(identityDio, standardSerializers),
          ),
          tokenStoreProvider.overrideWithValue(tokenStore),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            capturedRef = ref;
            return MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Seed a signed-in state.
    capturedRef.read(authTokenProvider.notifier).set('access-token');
    capturedRef.read(refreshTokenProvider.notifier).set('persisted-refresh');

    await tester.tap(find.byKey(const Key('accountMenuSignOutButton')));
    await tester.pumpAndSettle();

    // Revoked the current session (session-1), landed on Discover, and every
    // trace of auth is gone (in-memory + persisted).
    expect(interceptor.revokedSessionIds, ['session-1']);
    expect(find.byKey(const Key('discoverMarker')), findsOneWidget);
    expect(capturedRef.read(authTokenProvider), isNull);
    expect(capturedRef.read(refreshTokenProvider), isNull);
    expect(tokenStore.stored, isNull);
  });
}

class _DestinationMarker extends StatelessWidget {
  const _DestinationMarker(this.name);

  final String name;

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Text(name, key: Key('destination-$name')));
}

/// GET /me/sessions returns one current + one other session; DELETE records the
/// revoked id.
class _FakeSignOutInterceptor extends Interceptor {
  final List<String> revokedSessionIds = [];

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
                'id': 'session-1',
                'deviceDescription': 'Chrome on macOS',
                'createdAt': '2026-07-01T00:00:00Z',
                'lastSeenAt': '2026-07-18T00:00:00Z',
                'isCurrent': true,
              },
              {
                'id': 'session-2',
                'deviceDescription': 'Safari on iOS',
                'createdAt': '2026-07-02T00:00:00Z',
                'lastSeenAt': '2026-07-17T00:00:00Z',
                'isCurrent': false,
              },
            ],
          },
        ),
      );
    }
    if (options.path.startsWith('/me/sessions/') &&
        options.method == 'DELETE') {
      revokedSessionIds.add(options.path.split('/').last);
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

class _InMemoryTokenStore implements TokenStore {
  String? stored;

  @override
  Future<String?> readRefreshToken() async => stored;

  @override
  Future<void> writeRefreshToken(String token) async => stored = token;

  @override
  Future<void> clearRefreshToken() async => stored = null;
}
