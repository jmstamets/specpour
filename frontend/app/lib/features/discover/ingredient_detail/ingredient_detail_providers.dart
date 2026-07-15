// T156: full ingredient entry — the "full entry" destination linked from
// EntityInfoPopover.

import 'package:api_client/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client_provider.dart';

final ingredientDetailProvider =
    FutureProvider.family<IngredientDetail, String>((ref, id) async {
      final api = ref.watch(ingredientsApiProvider);
      final response = await api.getIngredient(id: id);
      return response.data!;
    });
