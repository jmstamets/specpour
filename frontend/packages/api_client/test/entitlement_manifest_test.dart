import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

// tests for EntitlementManifest
void main() {
  final instance = EntitlementManifestBuilder();
  // TODO add properties to the builder and call build()

  group(EntitlementManifest, () {
    // Stable tier key (e.g. \"guest\", \"default\") — never a display string.
    // String tier
    test('to test the property `tier`', () async {
      // TODO
    });

    // Capability keys granted to the caller's tier.
    // BuiltList<String> capabilities
    test('to test the property `capabilities`', () async {
      // TODO
    });

    // Active platform-scope role grants held by the caller (empty for guests).
    // BuiltList<RoleGrantSummary> roles
    test('to test the property `roles`', () async {
      // TODO
    });

  });
}
