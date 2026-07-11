// T028: the entitlement-manifest gate (constitution Principle VI — the client shapes
// UI from the server's entitlement manifest; every actual capability/role check is
// re-enforced server-side, this is never the source of truth). Re-fetches whenever
// authTokenProvider changes (sign-in/sign-out), since the manifest differs for guest
// vs. authenticated callers.

import 'package:api_client/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client_provider.dart';

final entitlementManifestProvider = FutureProvider<EntitlementManifest>((
  ref,
) async {
  ref.watch<String?>(authTokenProvider); // re-fetch on sign-in/sign-out
  final api = ref.watch(authorizationApiProvider);
  final response = await api.getMyEntitlements();
  return response.data!;
});
