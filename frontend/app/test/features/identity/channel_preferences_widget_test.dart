import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/identity/channel_preferences_screen.dart';

/// T151/T055: channel-preferences screen against a fake Dio interceptor
/// standing in for notificationsApiProvider's Dio, same convention as
/// account_management_widget_test.dart.
void main() {
  testWidgets('lists both channels and toggles email on', (tester) async {
    final interceptor = _FakeChannelsInterceptor();
    final notificationsDio = Dio(
      BaseOptions(baseUrl: 'http://test.invalid/api/v1'),
    )..interceptors.add(interceptor);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationsApiProvider.overrideWithValue(
            NotificationsApi(notificationsDio, standardSerializers),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChannelPreferencesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('channelPreferenceSwitch-email')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('channelPreferenceSwitch-push')),
      findsOneWidget,
    );

    final emailSwitch = tester.widget<SwitchListTile>(
      find.byKey(const Key('channelPreferenceSwitch-email')),
    );
    expect(emailSwitch.value, isFalse);

    await tester.tap(find.byKey(const Key('channelPreferenceSwitch-email')));
    await tester.pumpAndSettle();

    expect(interceptor.lastUpdate, {'email': true});
    final updatedEmailSwitch = tester.widget<SwitchListTile>(
      find.byKey(const Key('channelPreferenceSwitch-email')),
    );
    expect(updatedEmailSwitch.value, isTrue);
  });
}

class _FakeChannelsInterceptor extends Interceptor {
  bool _emailOptedIn = false;
  Map<String, bool>? lastUpdate;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/me/channels' && options.method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'channels': [
              {
                'channel': 'email',
                'optedIn': _emailOptedIn,
                'updatedAt': '2026-07-14T00:00:00Z',
              },
              {
                'channel': 'push',
                'optedIn': false,
                'updatedAt': '2026-07-14T00:00:00Z',
              },
            ],
          },
        ),
      );
    }

    if (options.path == '/me/channels' && options.method == 'PUT') {
      final channels = (options.data['channels'] as List)
          .cast<Map<String, dynamic>>();
      lastUpdate = {
        for (final c in channels) c['channel'] as String: c['optedIn'] as bool,
      };
      for (final c in channels) {
        if (c['channel'] == 'email') {
          _emailOptedIn = c['optedIn'] as bool;
        }
      }
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'channels': [
              {
                'channel': 'email',
                'optedIn': _emailOptedIn,
                'updatedAt': '2026-07-14T00:00:00Z',
              },
              {
                'channel': 'push',
                'optedIn': false,
                'updatedAt': '2026-07-14T00:00:00Z',
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
