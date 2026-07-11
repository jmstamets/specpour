import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for AuthorizationApi
void main() {
  final instance = ApiClient().getAuthorizationApi();

  group(AuthorizationApi, () {
    // Get the caller's entitlement manifest
    //
    // Returns the caller's tier, the capabilities that tier grants, and any active platform-scope role grants (constitution Principle VI's three independent axes: tier, role, scope). Works for both anonymous callers (guest pseudo-tier floor, FR-004b) and authenticated users — there is no unauthorized case for this endpoint. The client uses this manifest to shape UI (e.g. show admin routes only when a role grant is present); enforcement itself always happens server-side.
    //
    //Future<EntitlementManifest> getMyEntitlements() async
    test('test getMyEntitlements', () async {
      // TODO
    });

  });
}
