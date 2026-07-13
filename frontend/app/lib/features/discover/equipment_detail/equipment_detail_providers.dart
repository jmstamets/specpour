// T156: full equipment/glassware entry — the "full entry" destination
// linked from EntityInfoPopover. Glassware and bar tools share the Equipment
// module (a recipe's glassware IDs are Equipment IDs — see
// backend/src/Modules/Equipment/Domain/Equipment.cs), so one screen and one
// provider serve both.

import 'package:api_client/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client_provider.dart';

final equipmentDetailProvider = FutureProvider.family<EquipmentDetail, String>((
  ref,
  id,
) async {
  final api = ref.watch(equipmentApiProvider);
  final response = await api.getEquipmentItem(id: id);
  return response.data!;
});
