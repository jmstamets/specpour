// T150: responsible-consumption package (FR-067/FR-069). Fetches the persistent
// message for a surface and the jurisdiction-aware support resources from the
// compliance module. No per-request jurisdiction is wired yet (that arrives with
// geo-IP resolution used by the age gate) — the backend falls back to the default
// jurisdiction, which is the correct guest behavior.

import 'package:api_client/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client_provider.dart';

final responsibleUseMessageProvider =
    FutureProvider.family<ResponsibleConsumptionMessageResponse, String>((
      ref,
      surface,
    ) async {
      final api = ref.watch(complianceApiProvider);
      final response = await api.getResponsibleConsumptionMessage(
        surface: surface,
      );
      return response.data!;
    });

final supportResourcesProvider = FutureProvider<SupportResourcesResponse>((
  ref,
) async {
  final api = ref.watch(complianceApiProvider);
  final response = await api.getSupportResources();
  return response.data!;
});
