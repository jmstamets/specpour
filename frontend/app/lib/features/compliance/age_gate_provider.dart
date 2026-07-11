import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client_provider.dart';
import 'age_gate_config.dart';
import 'age_gate_local_store.dart';

/// GET /api/v1/compliance/age-gate for [surface] — never sends a DOB (there is none
/// to send yet at this point in the flow). Falls back to
/// [AgeGateConfig.offlineFallback] on ANY failure (network error, timeout, offline
/// device) rather than surfacing an error state that could be worked around —
/// T144/T145's offline-fails-safe requirement.
final ageGateConfigProvider = FutureProvider.family<AgeGateConfig, String>((
  ref,
  surface,
) async {
  final api = ref.watch(complianceApiProvider);
  try {
    final response = await api.getAgeGate(surface: surface);
    final data = response.data!;
    return AgeGateConfig(
      legalDrinkingAge: data.legalDrinkingAge,
      strictestRuleApplied: data.strictestRuleApplied,
      jurisdictionCode: data.jurisdictionCode,
    );
  } on Object {
    return AgeGateConfig.offlineFallback;
  }
});

final ageGateAffirmedProvider = FutureProvider<bool>(
  (ref) => AgeGateLocalStore().isAffirmed(),
);
