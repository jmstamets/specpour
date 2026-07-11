// UI-shaping helpers over the entitlement manifest (T028). No capability keys exist
// yet (T018's CapabilityGrant table is intentionally unseeded until a feature
// declares one — see AuthorizationDbContext's own comment), so these are exercised
// structurally by whichever screen adopts them first, not functionally proven yet.

import 'package:api_client/api_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'entitlement_manifest_provider.dart';

/// Renders [child] only once the manifest confirms [capability] is granted;
/// otherwise renders [fallback] (default: nothing). Fails closed while the manifest
/// is still loading or failed to load — an unconfirmed capability never renders.
class EntitlementGate extends ConsumerWidget {
  const EntitlementGate({
    required this.capability,
    required this.child,
    this.fallback,
    super.key,
  });

  final String capability;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manifest = ref.watch(entitlementManifestProvider);

    final hasCapability = manifest.maybeWhen(
      data: (m) => m.capabilities.contains(capability),
      orElse: () => false,
    );

    return hasCapability ? child : (fallback ?? const SizedBox.shrink());
  }
}

/// True once the manifest confirms an active platform-role grant matching [roleKey]
/// exists (e.g. "curator", "super_admin") — the seam T086's web-only admin route
/// guard will use.
bool hasPlatformRole(WidgetRef ref, String roleKey) {
  final manifest = ref.watch(entitlementManifestProvider);
  return manifest.maybeWhen(
    data: (m) => m.roles.any(
      (r) =>
          r.roleKey == roleKey &&
          r.scopeType == RoleGrantSummaryScopeTypeEnum.platform,
    ),
    orElse: () => false,
  );
}
