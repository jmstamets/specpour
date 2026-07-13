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
/// Populated by the sign-in flow (T055) and the token-refresh logic it wires up;
/// nothing writes to this yet.
class AuthToken extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? token) => state = token;
}

final authTokenProvider = NotifierProvider<AuthToken, String?>(AuthToken.new);

const _bearerSchemeName = 'bearerAuth';

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(basePathOverride: ref.watch(apiBaseUrlProvider));
  _wireCookieSupport(client.dio, ref.watch(cookieJarProvider));

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
