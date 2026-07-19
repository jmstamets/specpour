// T070: inventory feature's Riverpod providers — the caller's own inventory
// list (GET /inventory/items) and their makeable/near-miss recipes (GET
// /inventory/makeable, T067/T148), plus the curated ingredient list the
// manual-entry picker searches against.

import 'package:api_client/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client_provider.dart';

final myInventoryItemsProvider =
    FutureProvider.autoDispose<List<InventoryItem>>((ref) async {
      final response = await ref
          .watch(inventoryApiProvider)
          .listInventoryItems(limit: 100);
      return response.data!.items.toList();
    });

final myMakeableResponseProvider = FutureProvider.autoDispose<MakeableResponse>(
  (ref) async {
    final response = await ref.watch(inventoryApiProvider).getMakeableRecipes();
    return response.data!;
  },
);

/// The manual-entry ingredient picker searches this list client-side — V1's
/// ingredient count is small (same "tens to low hundreds" scale T155's own
/// in-memory hierarchy walk already relies on), so no server-side text-search
/// endpoint is needed for this picker specifically.
final pickableIngredientsProvider =
    FutureProvider.autoDispose<List<IngredientSummary>>((ref) async {
      final response = await ref
          .watch(ingredientsApiProvider)
          .listIngredients(limit: 200);
      return response.data!.items.toList();
    });
