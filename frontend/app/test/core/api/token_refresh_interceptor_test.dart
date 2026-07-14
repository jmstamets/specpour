import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';

/// T052 follow-on (2026-07-14): the backend's access-token lifetime was
/// shortened to 10 minutes to bound the post-revocation exposure window,
/// which makes TokenRefreshInterceptor's silent 401->refresh->retry path a
/// hot one — verifies it directly rather than relying on it only ever being
/// exercised incidentally through a widget test.
void main() {
  test('a 401 triggers a silent refresh and retries the original request', () async {
    final apiDio = Dio(BaseOptions(baseUrl: 'http://test.invalid'));
    final authDio = Dio(BaseOptions(baseUrl: 'http://test.invalid'));

    var protectedCallCount = 0;
    apiDio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.path != '/protected') {
          return handler.next(options);
        }

        protectedCallCount++;
        if (options.headers['Authorization'] == 'Bearer expired-token') {
          // callFollowingErrorInterceptor: true — matches what Dio's own real
          // dispatch does for a genuine network error (dio_mixin.dart), so
          // this fake mirrors a real 401 reaching TokenRefreshInterceptor.
          return handler.reject(
            DioException(requestOptions: options, response: Response(requestOptions: options, statusCode: 401)),
            true,
          );
        }

        return handler.resolve(Response(requestOptions: options, statusCode: 200, data: {'ok': true}));
      },
    ));

    authDio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.path != '/connect/token') {
          return handler.next(options);
        }

        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 200,
          data: {'access_token': 'fresh-access-token', 'refresh_token': 'fresh-refresh-token'},
        ));
      },
    ));

    final container = ProviderContainer(overrides: [authDioProvider.overrideWithValue(authDio)]);
    addTearDown(container.dispose);
    container.read(refreshTokenProvider.notifier).set('expired-refresh-token');

    apiDio.interceptors.add(
      container.read(Provider<TokenRefreshInterceptor>((ref) => TokenRefreshInterceptor(ref, apiDio))),
    );

    final response = await apiDio.get<Map<String, dynamic>>(
      '/protected',
      options: Options(headers: {'Authorization': 'Bearer expired-token'}),
    );

    expect(response.statusCode, 200);
    expect(protectedCallCount, 2, reason: 'the original 401 call, then one retry with the fresh token');
    expect(container.read(authTokenProvider), 'fresh-access-token');
    expect(container.read(refreshTokenProvider), 'fresh-refresh-token');
  });

  test('a failed refresh clears both tokens and propagates the original 401', () async {
    final apiDio = Dio(BaseOptions(baseUrl: 'http://test.invalid'));
    final authDio = Dio(BaseOptions(baseUrl: 'http://test.invalid'));

    apiDio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) => handler.reject(
        DioException(requestOptions: options, response: Response(requestOptions: options, statusCode: 401)),
        true,
      ),
    ));

    authDio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) => handler.reject(DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 400),
      )),
    ));

    final container = ProviderContainer(overrides: [authDioProvider.overrideWithValue(authDio)]);
    addTearDown(container.dispose);
    container.read(authTokenProvider.notifier).set('expired-token');
    container.read(refreshTokenProvider.notifier).set('revoked-refresh-token');

    apiDio.interceptors.add(
      container.read(Provider<TokenRefreshInterceptor>((ref) => TokenRefreshInterceptor(ref, apiDio))),
    );

    await expectLater(
      apiDio.get<void>('/protected', options: Options(headers: {'Authorization': 'Bearer expired-token'})),
      throwsA(isA<DioException>()),
    );

    expect(container.read(authTokenProvider), isNull);
    expect(container.read(refreshTokenProvider), isNull);
  });
}
