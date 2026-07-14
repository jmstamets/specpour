// T028's api_client wiring. The generated client (frontend/packages/api_client, T008)
// is the app's only coupling to the backend — every feature calls through this
// provider, never constructs its own Dio/ApiClient.

import 'package:api_client/api_client.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// T047/ADR-0003: wires cookie support onto [dio] for the sign-in flow's
/// register/login → cookie → /connect/authorize handoff, correctly per platform.
/// dio_cookie_manager's CookieManager literally asserts against web use — on
/// Flutter Web, cookies are the BROWSER's job (JS can't read/set the Cookie
/// header at all; it's a forbidden header name), so the fix there is
/// `extra['withCredentials'] = true` (read by dio_web_adapter's
/// BrowserHttpClientAdapter) so the browser includes/accepts cookies on
/// cross-origin requests, given the API's CORS policy allows credentials. On
/// native platforms (no browser in the loop), Dio's IOHttpClientAdapter does
/// NOT handle cookies at all, so CookieManager + a shared CookieJar does the
/// same job manually.
void _wireCookieSupport(Dio dio, CookieJar cookieJar) {
  if (kIsWeb) {
    dio.options.extra['withCredentials'] = true;
  } else {
    dio.interceptors.add(CookieManager(cookieJar));
  }
}

/// The API host, without the /api/v1 suffix — T047/ADR-0003's authorization-code+PKCE
/// exchange talks to /connect/authorize and /connect/token, which live at the host
/// root, not under /api/v1.
final apiHostBaseUrlProvider = Provider<String>((ref) => 'http://localhost:5001');

/// API base URL. A single local-dev default today; per-environment configuration
/// (dev/staging/prod flavors) is not yet a scheduled task — this is the seam for it.
final apiBaseUrlProvider = Provider<String>(
  (ref) => '${ref.watch(apiHostBaseUrlProvider)}/api/v1',
);

/// Shared across apiClientProvider's Dio and authDioProvider's Dio (T047/ADR-0003):
/// registration/login set a cookie under /api/v1/auth/*, and the PKCE exchange
/// against /connect/* (a different path prefix, same host) must present that same
/// cookie — a single CookieJar instance is what makes that work regardless of which
/// Dio object issues which request.
final cookieJarProvider = Provider<CookieJar>((ref) => CookieJar());

/// The signed-in user's bearer access token, or null for a guest/signed-out session.
/// Populated by the sign-in flow (T055) and [TokenRefreshInterceptor] below.
class AuthToken extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? token) => state = token;
}

final authTokenProvider = NotifierProvider<AuthToken, String?>(AuthToken.new);

/// Mirrors [AuthToken] for the refresh token (T047's `offline_access` scope
/// always returns one). [TokenRefreshInterceptor] needs it to silently mint a
/// new access token on a 401 rather than forcing a full re-sign-in. Rotates on
/// every refresh — OpenIddict's default is rolling/rotating refresh tokens —
/// so this always holds the latest valid one.
class RefreshToken extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? token) => state = token;
}

final refreshTokenProvider = NotifierProvider<RefreshToken, String?>(RefreshToken.new);

const _bearerSchemeName = 'bearerAuth';

/// Must match the OpenIddict client registration (OpenIddictClientSeedingHostedService)
/// — same value identity_auth_service.dart's `_clientId` names for the same reason.
const _refreshClientId = 'specpour-app';

/// T052 follow-on (2026-07-14): the backend's access-token lifetime was
/// shortened to 10 minutes to bound the post-revocation exposure window (see
/// IdentityModule.cs's SetAccessTokenLifetime comment), which makes refresh a
/// hot path. Catches a 401, silently exchanges the stored refresh_token for a
/// new access/refresh token pair via /connect/token, and retries the original
/// request — the caller never sees the 401. Extends QueuedInterceptor so
/// concurrent requests that all 401 at once share a single in-flight refresh
/// instead of racing to refresh independently. Refresh failure (revoked or
/// expired refresh token) clears both tokens, which the app's routing treats
/// as a hard sign-out (guest gate) — the same outcome a fully expired session
/// already produces today, just reached less often.
class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor(this._ref, this._apiDio);

  final Ref _ref;
  final Dio _apiDio;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final alreadyRetried = err.requestOptions.extra['tokenRefreshRetried'] == true;
    final refreshToken = _ref.read(refreshTokenProvider);
    if (err.response?.statusCode != 401 || alreadyRetried || refreshToken == null) {
      handler.next(err);
      return;
    }

    try {
      final authDio = _ref.read(authDioProvider);
      final response = await authDio.post<Map<String, dynamic>>(
        '/connect/token',
        data: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': _refreshClientId,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final newAccessToken = response.data!['access_token'] as String;
      final newRefreshToken = response.data!['refresh_token'] as String?;
      _ref.read(authTokenProvider.notifier).set(newAccessToken);
      _ref.read(refreshTokenProvider.notifier).set(newRefreshToken ?? refreshToken);

      final retryOptions = err.requestOptions;
      retryOptions.extra['tokenRefreshRetried'] = true;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryResponse = await _apiDio.fetch<dynamic>(retryOptions);
      handler.resolve(retryResponse);
    } on Object {
      _ref.read(authTokenProvider.notifier).set(null);
      _ref.read(refreshTokenProvider.notifier).set(null);
      handler.next(err);
    }
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(basePathOverride: ref.watch(apiBaseUrlProvider));
  _wireCookieSupport(client.dio, ref.watch(cookieJarProvider));
  client.dio.interceptors.add(TokenRefreshInterceptor(ref, client.dio));

  void syncToken(String? token) {
    final bearerInterceptor = client.dio.interceptors
        .whereType<BearerAuthInterceptor>()
        .firstOrNull;
    if (token == null) {
      bearerInterceptor?.tokens.remove(_bearerSchemeName);
    } else {
      bearerInterceptor?.tokens[_bearerSchemeName] = token;
    }
  }

  syncToken(ref.read(authTokenProvider));
  ref.listen<String?>(authTokenProvider, (_, next) => syncToken(next));

  return client;
});

final authorizationApiProvider = Provider<AuthorizationApi>(
  (ref) => AuthorizationApi(
    ref.watch(apiClientProvider).dio,
    ref.watch(apiClientProvider).serializers,
  ),
);

final complianceApiProvider = Provider<ComplianceApi>(
  (ref) => ComplianceApi(
    ref.watch(apiClientProvider).dio,
    ref.watch(apiClientProvider).serializers,
  ),
);

final notificationsApiProvider = Provider<NotificationsApi>(
  (ref) => NotificationsApi(
    ref.watch(apiClientProvider).dio,
    ref.watch(apiClientProvider).serializers,
  ),
);

final catalogApiProvider = Provider<CatalogApi>(
  (ref) => CatalogApi(
    ref.watch(apiClientProvider).dio,
    ref.watch(apiClientProvider).serializers,
  ),
);

final searchApiProvider = Provider<SearchApi>(
  (ref) => SearchApi(
    ref.watch(apiClientProvider).dio,
    ref.watch(apiClientProvider).serializers,
  ),
);

final ingredientsApiProvider = Provider<IngredientsApi>(
  (ref) => IngredientsApi(
    ref.watch(apiClientProvider).dio,
    ref.watch(apiClientProvider).serializers,
  ),
);

final equipmentApiProvider = Provider<EquipmentApi>(
  (ref) => EquipmentApi(
    ref.watch(apiClientProvider).dio,
    ref.watch(apiClientProvider).serializers,
  ),
);

final identityApiProvider = Provider<IdentityApi>(
  (ref) => IdentityApi(
    ref.watch(apiClientProvider).dio,
    ref.watch(apiClientProvider).serializers,
  ),
);

/// T047/ADR-0003: a second Dio pointed at the host root (not /api/v1), sharing
/// [cookieJarProvider], for the raw OAuth endpoints (/connect/authorize,
/// /connect/token) that aren't part of the generated OpenAPI client — they're
/// standard OAuth2/OIDC surface, not this project's own REST contract.
final authDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: ref.watch(apiHostBaseUrlProvider)));
  _wireCookieSupport(dio, ref.watch(cookieJarProvider));
  return dio;
});
