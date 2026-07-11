import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

// tests for AgeGateResponse
void main() {
  final instance = AgeGateResponseBuilder();
  // TODO add properties to the builder and call build()

  group(AgeGateResponse, () {
    // String surfaceStrictness
    test('to test the property `surfaceStrictness`', () async {
      // TODO
    });

    // Resolved jurisdiction code, or \"default\" when unresolved.
    // String jurisdictionCode
    test('to test the property `jurisdictionCode`', () async {
      // TODO
    });

    // int legalDrinkingAge
    test('to test the property `legalDrinkingAge`', () async {
      // TODO
    });

    // True when the jurisdiction was unresolved or no jurisdiction-specific rule matched.
    // bool strictestRuleApplied
    test('to test the property `strictestRuleApplied`', () async {
      // TODO
    });

  });
}
