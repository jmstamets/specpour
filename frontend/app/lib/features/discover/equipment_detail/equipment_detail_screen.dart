// T156: full equipment/glassware entry screen — reached from the recipe
// detail screen's entity info popover ("Full entry").

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import 'equipment_detail_providers.dart';

class EquipmentDetailScreen extends ConsumerWidget {
  const EquipmentDetailScreen({required this.equipmentId, super.key});

  final String equipmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final equipment = ref.watch(equipmentDetailProvider(equipmentId));

    return Scaffold(
      key: const Key('equipmentDetailScreen'),
      appBar: AppBar(title: Text(equipment.value?.name ?? '')),
      body: equipment.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(l10n.discoverSearchEmpty)),
        data: (equipment) =>
            _EquipmentDetailBody(equipment: equipment, l10n: l10n),
      ),
    );
  }
}

class _EquipmentDetailBody extends StatelessWidget {
  const _EquipmentDetailBody({required this.equipment, required this.l10n});

  final EquipmentDetail equipment;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '${l10n.equipmentDetailCategoryLabel}: ${equipment.category}',
          key: const Key('equipmentCategory'),
        ),
        const SizedBox(height: 8),
        Text(
          equipment.description ?? l10n.entityInfoNoDescription,
          key: const Key('equipmentDescription'),
        ),

        if (equipment.usageGuidance != null) ...[
          const SizedBox(height: 16),
          Text(
            l10n.equipmentDetailUsageTitle,
            style: theme.textTheme.titleMedium,
          ),
          Text(equipment.usageGuidance!),
        ],

        if (equipment.typicalApplications.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            l10n.equipmentDetailApplicationsTitle,
            style: theme.textTheme.titleMedium,
          ),
          Text(equipment.typicalApplications.join(', ')),
        ],
      ],
    );
  }
}
