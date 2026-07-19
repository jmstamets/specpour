// T063: the library home screen — the caller's personal authoring
// workspace. Lists their own recipes and house-made ingredients, and links
// to the editors that create new ones plus the venue manager for a
// professional's bar library. Reached via requireAccount (T043's existing
// gate), same as /account.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/identity_auth_service.dart' show describeIdentityError;
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/widgets/api_error_display.dart';
import 'library_providers.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recipes = ref.watch(myPersonalRecipesProvider);
    final ingredients = ref.watch(myPersonalIngredientsProvider);

    return Scaffold(
      key: const Key('libraryScreen'),
      appBar: AppBar(
        title: Text(l10n.libraryTitle),
        actions: [
          IconButton(
            key: const Key('libraryVenuesButton'),
            icon: const Icon(Icons.storefront_outlined),
            tooltip: l10n.libraryManageVenuesButton,
            onPressed: () => context.push('/library/venues'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.libraryRecipesSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton.icon(
                key: const Key('libraryCreateRecipeButton'),
                onPressed: () async {
                  await context.push('/library/recipes/new');
                  ref.invalidate(myPersonalRecipesProvider);
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.libraryCreateRecipeButton),
              ),
            ],
          ),
          recipes.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, stack) =>
                ApiErrorDisplay(message: describeIdentityError(error)),
            data: (items) => items.isEmpty
                ? Padding(
                    key: const Key('libraryRecipesEmptyState'),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(l10n.libraryEmptyRecipes),
                  )
                : Column(
                    children: [
                      for (final recipe in items)
                        ListTile(
                          key: Key('libraryRecipeListItem-${recipe.id}'),
                          leading: const Icon(Icons.local_bar_outlined),
                          title: Text(recipe.primaryName),
                          onTap: () => context.push('/recipes/${recipe.id}'),
                        ),
                    ],
                  ),
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.libraryIngredientsSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton.icon(
                key: const Key('libraryCreateIngredientButton'),
                onPressed: () async {
                  await context.push('/library/ingredients/new');
                  ref.invalidate(myPersonalIngredientsProvider);
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.libraryCreateIngredientButton),
              ),
            ],
          ),
          ingredients.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, stack) =>
                ApiErrorDisplay(message: describeIdentityError(error)),
            data: (items) => items.isEmpty
                ? Padding(
                    key: const Key('libraryIngredientsEmptyState'),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(l10n.libraryEmptyIngredients),
                  )
                : Column(
                    children: [
                      for (final ingredient in items)
                        ListTile(
                          key: Key(
                            'libraryIngredientListItem-${ingredient.id}',
                          ),
                          leading: const Icon(Icons.eco_outlined),
                          title: Text(ingredient.name),
                          onTap: () =>
                              context.push('/ingredients/${ingredient.id}'),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
