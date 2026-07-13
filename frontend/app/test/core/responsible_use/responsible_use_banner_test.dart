import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/core/responsible_use/responsible_use_banner.dart';

/// T150: the persistent responsible-consumption message (FR-067) and its
/// support-resources entry point (FR-069) must be present on the surfaces the spec
/// mandates. This asserts the banner renders and, on a messaging fetch failure,
/// still shows the fallback message rather than leaving the surface bare.
void main() {
  Widget host(Dio dio) => ProviderScope(
    overrides: [
      complianceApiProvider.overrideWithValue(
        ComplianceApi(dio, standardSerializers),
      ),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: ResponsibleUseBanner(surface: 'recipe')),
    ),
  );

  testWidgets('renders the resolved responsible-consumption message', (
    tester,
  ) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(_MessageInterceptor());

    await tester.pumpWidget(host(dio));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('responsibleUseBanner')), findsOneWidget);
    expect(
      find.byKey(const Key('responsibleUseSupportResourcesButton')),
      findsOneWidget,
    );
    expect(
      find.text(
        'Please enjoy responsibly. Know your limits, and never drink and drive.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('falls back to a generic message when messaging fails (FR-067)', (
    tester,
  ) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(_FailingInterceptor());

    await tester.pumpWidget(host(dio));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('responsibleUseBanner')), findsOneWidget);
    expect(find.text('Please enjoy responsibly.'), findsOneWidget);
  });
}

class _MessageInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/compliance/messaging') {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'surface': 'recipe',
            'jurisdictionCode': 'default',
            'placement': 'below-content',
            'messageContentKey': 'responsibleUse.message.default',
          },
        ),
      );
      return;
    }
    handler.reject(
      DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 404),
      ),
    );
  }
}

class _FailingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.reject(
      DioException.connectionError(
        requestOptions: options,
        reason: 'simulated offline',
      ),
    );
  }
}
