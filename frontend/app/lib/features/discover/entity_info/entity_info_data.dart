// T156: entity info popover data + providers. Shared shape used for both
// ingredient and equipment/glassware taps on recipe detail; deliberately
// generic (title/description/usageNote/fullEntryRoute) so Phase 10's T098
// (glossary term popovers) can reuse EntityInfoPopover with its own provider
// rather than a bespoke widget.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client_provider.dart';

class EntityInfoData {
  const EntityInfoData({
    required this.title,
    required this.fullEntryRoute,
    this.description,
    this.usageNote,
  });

  final String title;
  final String? description;
  final String? usageNote;
  final String fullEntryRoute;
}

final ingredientInfoProvider = FutureProvider.family<EntityInfoData, String>((
  ref,
  id,
) async {
  final api = ref.watch(ingredientsApiProvider);
  final response = await api.getIngredient(id: id);
  final detail = response.data!;
  return EntityInfoData(
    title: detail.name,
    description: detail.description,
    fullEntryRoute: '/ingredients/$id',
  );
});

final equipmentInfoProvider = FutureProvider.family<EntityInfoData, String>((
  ref,
  id,
) async {
  final api = ref.watch(equipmentApiProvider);
  final response = await api.getEquipmentItem(id: id);
  final detail = response.data!;
  return EntityInfoData(
    title: detail.name,
    description: detail.description,
    usageNote: detail.usageGuidance,
    fullEntryRoute: '/equipment/$id',
  );
});
