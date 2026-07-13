import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/identity/register_screen.dart';
import 'package:specpour_app/features/identity/sign_in_screen.dart';

import '../../support/no_raw_l10n_keys.dart';

/// T047/T055: registration/sign-in screens against fake Dio interceptors — one
/// standing in for the api_client Dio (POST /auth/register, /auth/login), one
/// for authDioProvider's root-host Dio (the ADR-0003 PKCE exchange:
/// /connect/authorize, /connect/token). A minimal two-route GoRouter (not the
/// full app) is enough to exercise the post-success navigation.
void main() {
  const dateOfBirthInput = '01/01/1990';

  Widget buildTestApp({
    required _FakeIdentityInterceptor identityInterceptor,
    required _FakeAuthInterceptor authInterceptor,
    String initialLocation = '/register',
    void Function(WidgetRef ref)? onRef,
  }) {
    final identityDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(identityInterceptor);
    final authDio = Dio(BaseOptions(baseUrl: 'http://test.invalid'))
      ..interceptors.add(authInterceptor);

    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Scaffold(body: Text('HOME', key: Key('homeMarker')))),
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
        GoRoute(path: '/sign-in', builder: (context, state) => const SignInScreen()),
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

  Future<void> enterDateOfBirth(WidgetTester tester, Key buttonKey) async {
    await tester.tap(find.byKey(buttonKey));
    await tester.pumpAndSettle();

    // Material's date picker opens in calendar mode; switch to keyboard entry
    // (same technique as the age-gate test) rather than paging a calendar grid.
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, dateOfBirthInput);
    await tester.pumpAndSettle();

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  testWidgets('registering with valid details signs the user in and navigates home', (tester) async {
    final identityInterceptor = _FakeIdentityInterceptor();
    final authInterceptor = _FakeAuthInterceptor();

    late WidgetRef capturedRef;
    await tester.pumpWidget(buildTestApp(
      identityInterceptor: identityInterceptor,
      authInterceptor: authInterceptor,
      onRef: (ref) => capturedRef = ref,
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('registerEmailField')), 'new-user@example.test');
    await tester.enterText(find.byKey(const Key('registerPasswordField')), 'correct horse battery staple');
    await tester.enterText(find.byKey(const Key('registerDisplayNameField')), 'New User');
    await enterDateOfBirth(tester, const Key('registerDateOfBirthButton'));

    expectNoRawLocalizationKeys(tester);

    await tester.tap(find.byKey(const Key('registerSubmitButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('homeMarker')), findsOneWidget);
    expect(capturedRef.read(authTokenProvider), 'fake-access-token');
    expect(identityInterceptor.registerCallCount, 1);
  });

  testWidgets('an underage-rejected registration shows the error and does not navigate', (tester) async {
    final identityInterceptor = _FakeIdentityInterceptor(rejectRegistration: true);
    final authInterceptor = _FakeAuthInterceptor();

    await tester.pumpWidget(buildTestApp(identityInterceptor: identityInterceptor, authInterceptor: authInterceptor));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('registerEmailField')), 'too-young@example.test');
    await tester.enterText(find.byKey(const Key('registerPasswordField')), 'correct horse battery staple');
    await tester.enterText(find.byKey(const Key('registerDisplayNameField')), 'Too Young');
    await enterDateOfBirth(tester, const Key('registerDateOfBirthButton'));

    await tester.tap(find.byKey(const Key('registerSubmitButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('registerScreen')), findsOneWidget);
    expect(find.byKey(const Key('registerErrorMessage')), findsOneWidget);
    expect(find.text('Registration requires meeting the applicable legal drinking age.'), findsOneWidget);
    expectNoRawLocalizationKeys(tester);
  });

  testWidgets('signing in with valid credentials signs the user in and navigates home', (tester) async {
    final identityInterceptor = _FakeIdentityInterceptor();
    final authInterceptor = _FakeAuthInterceptor();

    late WidgetRef capturedRef;
    await tester.pumpWidget(buildTestApp(
      identityInterceptor: identityInterceptor,
      authInterceptor: authInterceptor,
      initialLocation: '/sign-in',
      onRef: (ref) => capturedRef = ref,
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('signInEmailField')), 'existing-user@example.test');
    await tester.enterText(find.byKey(const Key('signInPasswordField')), 'correct horse battery staple');

    expectNoRawLocalizationKeys(tester);

    await tester.tap(find.byKey(const Key('signInSubmitButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('homeMarker')), findsOneWidget);
    expect(capturedRef.read(authTokenProvider), 'fake-access-token');
    expect(identityInterceptor.loginCallCount, 1);
  });

  testWidgets('bad credentials show the error and do not navigate', (tester) async {
    final identityInterceptor = _FakeIdentityInterceptor(rejectLogin: true);
    final authInterceptor = _FakeAuthInterceptor();

    await tester.pumpWidget(buildTestApp(identityInterceptor: identityInterceptor, authInterceptor: authInterceptor));
    await tester.pumpAndSettle();
    // Navigate to sign-in from the register screen's link, exercising that route too.
    await tester.tap(find.byKey(const Key('registerSignInInsteadLink')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('signInScreen')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('signInEmailField')), 'nobody@example.test');
    await tester.enterText(find.byKey(const Key('signInPasswordField')), 'wrong password entirely');
    await tester.tap(find.byKey(const Key('signInSubmitButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('signInScreen')), findsOneWidget);
    expect(find.byKey(const Key('signInErrorMessage')), findsOneWidget);
    expect(find.text('Invalid email or password.'), findsOneWidget);
    expectNoRawLocalizationKeys(tester);
  });
}

class _FakeIdentityInterceptor extends Interceptor {
  _FakeIdentityInterceptor({this.rejectRegistration = false, this.rejectLogin = false});

  final bool rejectRegistration;
  final bool rejectLogin;
  int registerCallCount = 0;
  int loginCallCount = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/auth/register') {
      registerCallCount++;
      if (rejectRegistration) {
        return handler.reject(DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 403,
            data: {
              'title': 'Underage registration',
              'status': 403,
              'detail': 'Registration requires meeting the applicable legal drinking age.',
            },
          ),
        ));
      }

      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 201,
        data: {'userId': '11111111-1111-1111-1111-111111111111', 'email': 'new-user@example.test', 'displayName': 'New User'},
      ));
    }

    if (options.path == '/auth/login') {
      loginCallCount++;
      if (rejectLogin) {
        return handler.reject(DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 401,
            data: {'title': 'Sign-in failed', 'status': 401, 'detail': 'Invalid email or password.'},
          ),
        ));
      }

      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {'userId': '11111111-1111-1111-1111-111111111111', 'email': 'existing-user@example.test', 'displayName': 'Existing User'},
      ));
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
