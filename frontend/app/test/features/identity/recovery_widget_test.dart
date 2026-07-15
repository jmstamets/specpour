import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/identity/recovery_confirm_screen.dart';
import 'package:specpour_app/features/identity/recovery_request_screen.dart';
import 'package:specpour_app/features/identity/sign_in_screen.dart';

import '../../support/no_raw_l10n_keys.dart';

/// T050: account recovery request/confirm screens.
void main() {
  Widget buildTestApp({
    required _FakeIdentityInterceptor identityInterceptor,
    String initialLocation = '/recovery',
  }) {
    final identityDio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(identityInterceptor);

    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/sign-in',
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: '/recovery',
          builder: (context, state) => const RecoveryRequestScreen(),
        ),
        GoRoute(
          path: '/recovery/confirm',
          builder: (context, state) => const RecoveryConfirmScreen(),
        ),
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

  testWidgets(
    'requesting recovery shows the (no-enumeration) success message',
    (tester) async {
      final identityInterceptor = _FakeIdentityInterceptor();

      await tester.pumpWidget(
        buildTestApp(identityInterceptor: identityInterceptor),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('recoveryRequestEmailField')),
        'someone@example.test',
      );
      await tester.tap(find.byKey(const Key('recoveryRequestSubmitButton')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('recoveryRequestSuccessMessage')),
        findsOneWidget,
      );
      expect(identityInterceptor.recoveryRequestCount, 1);
      expectNoRawLocalizationKeys(tester);

      await tester.tap(find.byKey(const Key('recoveryRequestGoToConfirmLink')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recoveryConfirmScreen')), findsOneWidget);
    },
  );

  testWidgets('confirming recovery with a valid code navigates to sign-in', (
    tester,
  ) async {
    final identityInterceptor = _FakeIdentityInterceptor();

    await tester.pumpWidget(
      buildTestApp(
        identityInterceptor: identityInterceptor,
        initialLocation: '/recovery/confirm',
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('recoveryConfirmEmailField')),
      'someone@example.test',
    );
    await tester.enterText(
      find.byKey(const Key('recoveryConfirmTokenField')),
      'a-real-token',
    );
    await tester.enterText(
      find.byKey(const Key('recoveryConfirmNewPasswordField')),
      'a brand new passphrase',
    );
    expectNoRawLocalizationKeys(tester);

    await tester.tap(find.byKey(const Key('recoveryConfirmSubmitButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('signInScreen')), findsOneWidget);
  });

  testWidgets('confirming recovery with an invalid token shows the error', (
    tester,
  ) async {
    final identityInterceptor = _FakeIdentityInterceptor(rejectConfirm: true);

    await tester.pumpWidget(
      buildTestApp(
        identityInterceptor: identityInterceptor,
        initialLocation: '/recovery/confirm',
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('recoveryConfirmEmailField')),
      'someone@example.test',
    );
    await tester.enterText(
      find.byKey(const Key('recoveryConfirmTokenField')),
      'a-bad-token',
    );
    await tester.enterText(
      find.byKey(const Key('recoveryConfirmNewPasswordField')),
      'a brand new passphrase',
    );

    await tester.tap(find.byKey(const Key('recoveryConfirmSubmitButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('recoveryConfirmScreen')), findsOneWidget);
    expect(
      find.byKey(const Key('recoveryConfirmErrorMessage')),
      findsOneWidget,
    );
    expectNoRawLocalizationKeys(tester);
  });
}

class _FakeIdentityInterceptor extends Interceptor {
  _FakeIdentityInterceptor({this.rejectConfirm = false});

  final bool rejectConfirm;
  int recoveryRequestCount = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/auth/recovery') {
      recoveryRequestCount++;
      return handler.resolve(
        Response(requestOptions: options, statusCode: 202),
      );
    }

    if (options.path == '/auth/recovery/confirm') {
      if (rejectConfirm) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 400,
              data: {'title': 'Recovery failed', 'status': 400},
            ),
          ),
        );
      }

      return handler.resolve(
        Response(requestOptions: options, statusCode: 200),
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
