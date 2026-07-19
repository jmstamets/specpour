// T063: shared "my library" read providers — the caller's own personal
// recipes and ingredients (GET /recipes?scope=personal, GET
// /ingredients?scope=personal, T058/T059), used by the library home screen
// and the house-made ingredient editor's defining-recipe picker.

import 'package:api_client/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client_provider.dart';

final myPersonalRecipesProvider =
    FutureProvider.autoDispose<List<RecipeSummary>>((ref) async {
      final response = await ref
          .watch(catalogApiProvider)
          .listRecipes(scope: 'personal', limit: 100);
      return response.data!.items.toList();
    });

final myPersonalIngredientsProvider =
    FutureProvider.autoDispose<List<IngredientSummary>>((ref) async {
      final response = await ref
          .watch(ingredientsApiProvider)
          .listIngredients(scope: 'personal', limit: 100);
      return response.data!.items.toList();
    });
