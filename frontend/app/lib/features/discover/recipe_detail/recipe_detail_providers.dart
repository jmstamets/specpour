import 'package:api_client/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client_provider.dart';

final recipeDetailProvider = FutureProvider.family<RecipeDetail, String>((
  ref,
  id,
) async {
  final api = ref.watch(catalogApiProvider);
  final response = await api.getRecipe(id: id);
  return response.data!;
});
