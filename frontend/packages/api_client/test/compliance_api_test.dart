import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for ComplianceApi
void main() {
  final instance = ApiClient().getComplianceApi();

  group(ComplianceApi, () {
    // Get the per-surface age-gate configuration and jurisdiction rule
    //
    // Returns the requested surface's gate strictness plus the legal drinking age for the caller's coarse (IP-based) jurisdiction (R13, FR-002a). The client renders the DOB-entry gate and validates the entered value itself — DOB is never transmitted or stored (checked-never-stored, Principle XII data minimization); only a client-side \"affirmed\" flag persists locally. When the jurisdiction cannot be resolved (offline lookup failure, unknown IP range) or no jurisdiction-specific rule exists, the strictest known rule applies (`strictestRuleApplied: true`).
    //
    //Future<AgeGateResponse> getAgeGate(String surface) async
    test('test getAgeGate', () async {
      // TODO
    });

  });
}
