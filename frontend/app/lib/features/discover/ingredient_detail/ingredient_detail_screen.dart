// T156: full ingredient entry screen — reached from the recipe detail
// screen's entity info popover ("Full entry"), and directly linkable
// (/ingredients/:id) the same way recipe/concept detail are.

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/content_key_labels.dart';
import '../../../core/l10n/gen/app_localizations.dart';
import 'ingredient_detail_providers.dart';

class IngredientDetailScreen extends ConsumerWidget {
  const IngredientDetailScreen({required this.ingredientId, super.key});

  final String ingredientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ingredient = ref.watch(ingredientDetailProvider(ingredientId));

    return Scaffold(
      key: const Key('ingredientDetailScreen'),
      appBar: AppBar(title: Text(ingredient.value?.name ?? '')),
      body: ingredient.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(l10n.discoverSearchEmpty)),
        data: (ingredient) =>
            _IngredientDetailBody(ingredient: ingredient, l10n: l10n),
      ),
    );
  }
}

class _IngredientDetailBody extends StatelessWidget {
  const _IngredientDetailBody({required this.ingredient, required this.l10n});

  final IngredientDetail ingredient;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (ingredient.parentName != null)
          InkWell(
            key: const Key('ingredientParentLink'),
            onTap: () => context.push('/ingredients/${ingredient.parentId}'),
            child: Text(
              l10n.ingredientDetailParentLabel(ingredient.parentName!),
              style: theme.textTheme.bodyMedium,
            ),
          ),
        const SizedBox(height: 8),

        if (ingredient.allergens.isNotEmpty) ...[
          Text(
            l10n.ingredientDetailAllergensTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: ingredient.allergens
                .map(
                  (allergen) => Chip(
                    key: Key('ingredientAllergenFlag-$allergen'),
                    label: Text(resolveAllergenDisplayName(l10n, allergen)),
                    backgroundColor: theme.colorScheme.errorContainer,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
        ],

        if (ingredient.abvPercent != null)
          Text('${l10n.ingredientDetailAbvLabel}: ${ingredient.abvPercent}%'),

        const SizedBox(height: 8),
        Text(
          ingredient.description ?? l10n.entityInfoNoDescription,
          key: const Key('ingredientDescription'),
        ),

        if (ingredient.sources.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            l10n.ingredientDetailSourcesTitle,
            style: theme.textTheme.titleMedium,
          ),
          Text(ingredient.sources.join(', ')),
        ],

        if (ingredient.definingRecipeName != null) ...[
          const SizedBox(height: 16),
          InkWell(
            key: const Key('ingredientDefiningRecipeLink'),
            onTap: () =>
                context.push('/recipes/${ingredient.definingRecipeId}'),
            child: Text(
              '${l10n.ingredientDetailDefiningRecipeLabel}: '
              '${ingredient.definingRecipeName}',
            ),
          ),
        ],

        if (ingredient.yieldQuantity != null) ...[
          const SizedBox(height: 8),
          Text(
            '${l10n.ingredientDetailYieldLabel}: '
            '${ingredient.yieldQuantity} ${ingredient.yieldUnit ?? ''}',
          ),
        ],

        if (ingredient.shelfLife != null) ...[
          const SizedBox(height: 8),
          Text(
            '${l10n.ingredientDetailShelfLifeLabel}: ${ingredient.shelfLife}',
          ),
        ],

        if (ingredient.storageInstructions != null) ...[
          const SizedBox(height: 16),
          Text(
            l10n.ingredientDetailStorageTitle,
            style: theme.textTheme.titleMedium,
          ),
          Text(ingredient.storageInstructions!),
        ],
      ],
    );
  }
}
