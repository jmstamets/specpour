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

    // Get the persistent responsible-consumption message for a surface (FR-067)
    //
    // Jurisdiction-configurable, counsel-reviewed message shown persistently on recipe pages, batch outputs, and the footer/about surface (FR-067). The content is returned as an i18n key resolved client-side, never hard-coded copy. Falls back to the default message for the surface when the caller's jurisdiction is unresolved. Guest-accessible.
    //
    //Future<ResponsibleConsumptionMessageResponse> getResponsibleConsumptionMessage(String surface, { String jurisdiction }) async
    test('test getResponsibleConsumptionMessage', () async {
      // TODO
    });

    // Get jurisdiction-aware support resources (FR-069)
    //
    // Localized helpline/organization links, reachable from the responsible-consumption messaging and settings/about (FR-069). Falls back to the default set when the caller's jurisdiction is unresolved. Guest-accessible.
    //
    //Future<SupportResourcesResponse> getSupportResources({ String jurisdiction }) async
    test('test getSupportResources', () async {
      // TODO
    });

  });
}
