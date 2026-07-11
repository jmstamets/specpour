import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

// tests for RoleGrantSummary
void main() {
  final instance = RoleGrantSummaryBuilder();
  // TODO add properties to the builder and call build()

  group(RoleGrantSummary, () {
    // Stable platform role key (e.g. \"curator\", \"super_admin\").
    // String roleKey
    test('to test the property `roleKey`', () async {
      // TODO
    });

    // String scopeType
    test('to test the property `scopeType`', () async {
      // TODO
    });

    // Null for platform-scope grants (V1 issues platform-scope grants only, FR-063).
    // String scopeId
    test('to test the property `scopeId`', () async {
      // TODO
    });

  });
}
