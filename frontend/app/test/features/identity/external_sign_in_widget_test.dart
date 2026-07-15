import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/identity/complete_external_registration_screen.dart';
import 'package:specpour_app/features/identity/external_sign_in_callback_screen.dart';
import 'package:specpour_app/features/identity/register_screen.dart';
import 'package:specpour_app/features/identity/sign_in_screen.dart';

import '../../support/no_raw_l10n_keys.dart';

/// T049: social sign-in buttons render on sign-in/register, and the callback
/// route's branching (error / needsDateOfBirth / requiresMfa / success) plus
/// the DOB-completion screen. The actual OAuth redirect (url_launcher
/// navigating the browser away) isn't exercised here — see ExternalAuthEndpoints'
/// own doc comment and the Phase 4 progress memory for why that, and the real
/// provider handshake, can't be tested without real provider credentials.
void main() {
  testWidgets('social sign-in buttons render on the sign-in screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SignInScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('socialSignInGoogleButton')), findsOneWidget);
    expect(find.byKey(const Key('socialSignInAppleButton')), findsOneWidget);
    expect(
      find.byKey(const Key('socialSignInMicrosoftButton')),
      findsOneWidget,
    );
    expectNoRawLocalizationKeys(tester);
  });

  testWidgets('social sign-in buttons render on the register screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RegisterScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('socialSignInGoogleButton')), findsOneWidget);
    expectNoRawLocalizationKeys(tester);
  });

  Widget buildCallbackTestApp({
    required Map<String, String> queryParameters,
    required _FakeIdentityInterceptor identityInterceptor,
    void Function(WidgetRef ref)? onRef,
  }) {
    final identityDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(identityInterceptor);
    final authDio = Dio(BaseOptions(baseUrl: 'http://test.invalid'))
      ..interceptors.add(_FakeAuthInterceptor());

    final router = GoRouter(
      initialLocation: '/auth/external/callback',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: Text('HOME', key: Key('homeMarker'))),
        ),
        GoRoute(
          path: '/sign-in',
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: '/mfa-challenge',
          builder: (context, state) =>
              const Scaffold(body: Text('MFA', key: Key('mfaMarker'))),
        ),
        GoRoute(
          path: '/auth/external/complete-registration',
          builder: (context, state) =>
              const CompleteExternalRegistrationScreen(),
        ),
        GoRoute(
          path: '/auth/external/callback',
          builder: (context, state) =>
              ExternalSignInCallbackScreen(queryParameters: queryParameters),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        identityApiProvider.overrideWithValue(
          IdentityApi(identityDio, standardSerializers),
        ),
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

  testWidgets(
    'callback with an error shows the error and a link back to sign-in',
    (tester) async {
      await tester.pumpWidget(
        buildCallbackTestApp(
          queryParameters: const {'error': 'external_auth_failed'},
          identityInterceptor: _FakeIdentityInterceptor(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('externalCallbackErrorMessage')),
        findsOneWidget,
      );
      expectNoRawLocalizationKeys(tester);
    },
  );

  testWidgets('callback with requiresMfa navigates to the MFA challenge', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildCallbackTestApp(
        queryParameters: const {'requiresMfa': 'true'},
        identityInterceptor: _FakeIdentityInterceptor(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mfaMarker')), findsOneWidget);
  });

  testWidgets(
    'callback with needsDateOfBirth navigates to the DOB-completion screen',
    (tester) async {
      await tester.pumpWidget(
        buildCallbackTestApp(
          queryParameters: const {'needsDateOfBirth': 'true'},
          identityInterceptor: _FakeIdentityInterceptor(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('completeExternalRegistrationScreen')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'a plain successful callback completes the token exchange and goes home',
    (tester) async {
      late WidgetRef capturedRef;

      await tester.pumpWidget(
        buildCallbackTestApp(
          queryParameters: const {},
          identityInterceptor: _FakeIdentityInterceptor(),
          onRef: (ref) => capturedRef = ref,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('homeMarker')), findsOneWidget);
      expect(capturedRef.read(authTokenProvider), 'fake-access-token');
    },
  );

  testWidgets(
    'completing external registration with a DOB signs in and goes home',
    (tester) async {
      final identityInterceptor = _FakeIdentityInterceptor();

      await tester.pumpWidget(
        buildCallbackTestApp(
          queryParameters: const {'needsDateOfBirth': 'true'},
          identityInterceptor: identityInterceptor,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('completeExternalRegistrationScreen')),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const Key('completeExternalRegistrationDisplayNameField')),
        'Social User',
      );
      await tester.tap(
        find.byKey(const Key('completeExternalRegistrationDateOfBirthButton')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '01/01/1990');
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expectNoRawLocalizationKeys(tester);

      await tester.tap(
        find.byKey(const Key('completeExternalRegistrationSubmitButton')),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('homeMarker')), findsOneWidget);
      expect(identityInterceptor.completeRegistrationCount, 1);
    },
  );
}

class _FakeIdentityInterceptor extends Interceptor {
  int completeRegistrationCount = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/auth/external/complete-registration') {
      completeRegistrationCount++;
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: {
            'userId': '11111111-1111-1111-1111-111111111111',
            'email': 'social@example.test',
            'displayName': 'Social User',
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

class _FakeAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/connect/authorize') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 302,
          headers: Headers.fromMap({
            'location': [
              'http://localhost:5173/callback?code=fake-auth-code&state=abc',
            ],
          }),
        ),
      );
    }

    if (options.path == '/connect/token') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'access_token': 'fake-access-token',
            'refresh_token': 'fake-refresh-token',
            'token_type': 'Bearer',
            'expires_in': 3600,
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
