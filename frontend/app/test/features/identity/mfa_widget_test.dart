import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/identity/mfa_challenge_screen.dart';
import 'package:specpour_app/features/identity/mfa_settings_screen.dart';
import 'package:specpour_app/features/identity/sign_in_screen.dart';

import '../../support/no_raw_l10n_keys.dart';

/// T050: MFA login-challenge and settings screens, against a fake identity
/// Dio (POST /auth/login, /auth/login/mfa, GET/POST/DELETE /me/mfa) and a
/// fake auth-host Dio (/connect/authorize, /connect/token) — same fixture
/// shape as identity_widget_test.dart.
void main() {
  Widget buildTestApp({
    required _FakeIdentityInterceptor identityInterceptor,
    String initialLocation = '/sign-in',
    void Function(WidgetRef ref)? onRef,
  }) {
    final identityDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(identityInterceptor);
    final authDio = Dio(BaseOptions(baseUrl: 'http://test.invalid'))..interceptors.add(_FakeAuthInterceptor());

    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Scaffold(body: Text('HOME', key: Key('homeMarker')))),
        GoRoute(path: '/sign-in', builder: (context, state) => const SignInScreen()),
        GoRoute(path: '/mfa-challenge', builder: (context, state) => const MfaChallengeScreen()),
        GoRoute(path: '/account/mfa', builder: (context, state) => const MfaSettingsScreen()),
      ],
    );

    return ProviderScope(
      overrides: [
        identityApiProvider.overrideWithValue(IdentityApi(identityDio, standardSerializers)),
        authDioProvider.overrideWithValue(authDio),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          onRef?.call(ref);
          return MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }

  testWidgets('signing in with MFA enabled shows the challenge screen, then a valid code signs in', (tester) async {
    final identityInterceptor = _FakeIdentityInterceptor(mfaEnabled: true);

    late WidgetRef capturedRef;
    await tester.pumpWidget(buildTestApp(identityInterceptor: identityInterceptor, onRef: (ref) => capturedRef = ref));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('signInEmailField')), 'mfa-user@example.test');
    await tester.enterText(find.byKey(const Key('signInPasswordField')), 'correct horse battery staple');
    await tester.tap(find.byKey(const Key('signInSubmitButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mfaChallengeScreen')), findsOneWidget);
    expect(capturedRef.read(authTokenProvider), isNull);
    expectNoRawLocalizationKeys(tester);

    await tester.enterText(find.byKey(const Key('mfaChallengeCodeField')), '123456');
    await tester.tap(find.byKey(const Key('mfaChallengeSubmitButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('homeMarker')), findsOneWidget);
    expect(capturedRef.read(authTokenProvider), 'fake-access-token');
  });

  testWidgets('an invalid MFA code shows the error and does not navigate', (tester) async {
    final identityInterceptor = _FakeIdentityInterceptor(mfaEnabled: true, rejectMfaCode: true);

    await tester.pumpWidget(buildTestApp(identityInterceptor: identityInterceptor));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('signInEmailField')), 'mfa-user@example.test');
    await tester.enterText(find.byKey(const Key('signInPasswordField')), 'correct horse battery staple');
    await tester.tap(find.byKey(const Key('signInSubmitButton')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('mfaChallengeCodeField')), '000000');
    await tester.tap(find.byKey(const Key('mfaChallengeSubmitButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mfaChallengeScreen')), findsOneWidget);
    expect(find.byKey(const Key('mfaChallengeErrorMessage')), findsOneWidget);
    expectNoRawLocalizationKeys(tester);
  });

  testWidgets('MFA settings: enrolling shows the secret, then confirming enables it', (tester) async {
    final identityInterceptor = _FakeIdentityInterceptor();

    await tester.pumpWidget(buildTestApp(identityInterceptor: identityInterceptor, initialLocation: '/account/mfa'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mfaSettingsStatusText')), findsOneWidget);
    expect(find.byKey(const Key('mfaSettingsEnrollButton')), findsOneWidget);

    await tester.tap(find.byKey(const Key('mfaSettingsEnrollButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mfaSettingsSecretText')), findsOneWidget);
    expect(find.text('JBSWY3DPEHPK3PXP'), findsOneWidget);
    expectNoRawLocalizationKeys(tester);

    await tester.enterText(find.byKey(const Key('mfaSettingsCodeField')), '123456');
    await tester.tap(find.byKey(const Key('mfaSettingsConfirmButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mfaSettingsInfoMessage')), findsOneWidget);
    expect(identityInterceptor.enabled, isTrue);
  });

  testWidgets('MFA settings: disabling an enabled enrollment updates the status', (tester) async {
    final identityInterceptor = _FakeIdentityInterceptor(mfaEnabled: true);

    await tester.pumpWidget(buildTestApp(identityInterceptor: identityInterceptor, initialLocation: '/account/mfa'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mfaSettingsDisableButton')), findsOneWidget);

    await tester.tap(find.byKey(const Key('mfaSettingsDisableButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mfaSettingsInfoMessage')), findsOneWidget);
    expect(identityInterceptor.enabled, isFalse);
    expectNoRawLocalizationKeys(tester);
  });
}

class _FakeIdentityInterceptor extends Interceptor {
  _FakeIdentityInterceptor({bool mfaEnabled = false, this.rejectMfaCode = false}) : enabled = mfaEnabled;

  bool enabled;
  final bool rejectMfaCode;
  String? _pendingSecret;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/auth/login') {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'requiresMfa': enabled,
          'userId': enabled ? null : '11111111-1111-1111-1111-111111111111',
          'email': enabled ? null : 'mfa-user@example.test',
          'displayName': enabled ? null : 'Mfa User',
        },
      ));
    }

    if (options.path == '/auth/login/mfa') {
      if (rejectMfaCode) {
        return handler.reject(DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 401,
            data: {'title': 'Sign-in failed', 'status': 401, 'detail': 'Invalid MFA code.'},
          ),
        ));
      }

      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {'userId': '11111111-1111-1111-1111-111111111111', 'email': 'mfa-user@example.test', 'displayName': 'Mfa User'},
      ));
    }

    if (options.path == '/me/mfa' && options.method == 'GET') {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {'enabled': enabled, 'method': enabled ? 'totp' : null},
      ));
    }

    if (options.path == '/me/mfa' && options.method == 'POST') {
      final body = options.data as Map<String, dynamic>?;
      final code = body?['code'] as String?;
      if (code == null) {
        _pendingSecret = 'JBSWY3DPEHPK3PXP';
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 200,
          data: {'enabled': false, 'secret': _pendingSecret, 'otpAuthUri': 'otpauth://totp/SpecPour:test?secret=$_pendingSecret'},
        ));
      }

      enabled = true;
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {'enabled': true, 'secret': null, 'otpAuthUri': null},
      ));
    }

    if (options.path == '/me/mfa' && options.method == 'DELETE') {
      enabled = false;
      return handler.resolve(Response(requestOptions: options, statusCode: 204));
    }

    handler.reject(DioException(requestOptions: options, response: Response(requestOptions: options, statusCode: 404)));
  }
}

class _FakeAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/connect/authorize') {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 302,
        headers: Headers.fromMap({
          'location': ['http://localhost:5173/callback?code=fake-auth-code&state=abc'],
        }),
      ));
    }

    if (options.path == '/connect/token') {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'access_token': 'fake-access-token',
          'refresh_token': 'fake-refresh-token',
          'token_type': 'Bearer',
          'expires_in': 3600,
        },
      ));
    }

    handler.reject(DioException(requestOptions: options, response: Response(requestOptions: options, statusCode: 404)));
  }
}
