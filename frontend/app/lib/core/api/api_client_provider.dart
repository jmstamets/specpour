// T028's api_client wiring. The generated client (frontend/packages/api_client, T008)
// is the app's only coupling to the backend — every feature calls through this
// provider, never constructs its own Dio/ApiClient.

import 'package:api_client/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API base URL. A single local-dev default today; per-environment configuration
/// (dev/staging/prod flavors) is not yet a scheduled task — this is the seam for it.
final apiBaseUrlProvider = Provider<String>(
  (ref) => 'http://localhost:5001/api/v1',
);

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
