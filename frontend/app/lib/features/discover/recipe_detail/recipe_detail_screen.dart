// T042: full recipe detail (US1 scenarios 1, 2, 4) — every content field FR-020
// requires, plus derived ABV/standard drinks (FR-022) and prominently-displayed
// rolled-up allergens (FR-055). FR-022's per-serving cost display is staged —
// it lights up at the US5 checkpoint once T075/T076 provide pricing data
// (mirrors the T148/T149 facet-staging pattern already used server-side).

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/content_key_labels.dart';
import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/responsible_use/responsible_use_banner.dart';
import '../entity_info/entity_info_data.dart';
import '../entity_info/entity_info_popover.dart';
import 'recipe_detail_providers.dart';

class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({required this.recipeId, super.key});

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recipe = ref.watch(recipeDetailProvider(recipeId));

    return Scaffold(
      key: const Key('recipeDetailScreen'),
      appBar: AppBar(title: Text(recipe.value?.primaryName ?? '')),
      body: recipe.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(l10n.discoverSearchEmpty)),
        data: (recipe) => _RecipeDetailBody(recipe: recipe, l10n: l10n),
      ),
    );
  }
}

class _RecipeDetailBody extends StatelessWidget {
  const _RecipeDetailBody({required this.recipe, required this.l10n});

  final RecipeDetail recipe;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (recipe.alternateNames.isNotEmpty)
          Text(
            recipe.alternateNames.join(' · '),
            style: theme.textTheme.bodyMedium,
          ),
        const SizedBox(height: 8),

        // Allergens are shown prominently, near the top of the page, per
        // FR-055 — not buried below instructions.
        if (recipe.allergens.isNotEmpty) ...[
          Text(
            l10n.recipeDetailAllergensTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: recipe.allergens
                .map(
                  // T157 (same defect class as the family keys): allergen values
                  // are keys ("treeNut"), resolved to display names — the widget
                  // Key keeps the raw key so tests stay stable across locales.
                  (allergen) => Chip(
                    key: Key('recipeAllergenFlag-$allergen'),
                    label: Text(resolveAllergenDisplayName(l10n, allergen)),
                    backgroundColor: theme.colorScheme.errorContainer,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
        ],

        Container(
          key: const Key('recipeAbvAndStandardDrinks'),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            l10n.recipeDetailAbvStandardDrinks(
              recipe.abvPercent.toStringAsFixed(1),
              recipe.standardDrinks.toStringAsFixed(2),
            ),
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 16),

        Text(
          l10n.recipeDetailIngredientsTitle,
          style: theme.textTheme.titleMedium,
        ),
        Column(
          key: const Key('recipeIngredientLines'),
          children: recipe.ingredientLines
              .map(
                // T156: tapping an ingredient line opens its entity info
                // popover (description + link to the full ingredient entry).
                (line) => ListTile(
                  key: Key('recipeIngredientLine-${line.ingredientId}'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(line.ingredientName ?? line.ingredientId),
                  trailing: Text('${line.quantity} ${line.unit}'),
                  subtitle: line.purpose == null ? null : Text(line.purpose!),
                  onTap: () => showEntityInfoPopover(
                    context,
                    (ref) => ref.watch(
                      ingredientInfoProvider(line.ingredientId),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),

        Text(
          l10n.recipeDetailInstructionsTitle,
          style: theme.textTheme.titleMedium,
        ),
        ...recipe.instructions.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text('${entry.key + 1}. ${entry.value}'),
          ),
        ),
        const SizedBox(height: 16),

        // T158 (renderer bug found in John's walkthrough): the ice spec was
        // rendered under the "Garnish:" label, producing contradictions like
        // "Garnish: None (served up)" directly above "Lime wheel". Ice and
        // garnish are separate FR-020 fields — labeled separately.
        Text(
          '${l10n.recipeDetailIceTitle}: ${recipe.iceSpec}',
          key: const Key('recipeIceSpec'),
        ),
        if (recipe.garnishes != null && recipe.garnishes!.isNotEmpty)
          Text(
            '${l10n.recipeDetailGarnishTitle}: ${recipe.garnishes!.join(', ')}',
            key: const Key('recipeGarnishes'),
          ),

        // T156: glassware/equipment are also tappable — same entity info
        // popover pattern as ingredient lines, since glassware IDs resolve
        // through the same Equipment module (see equipment_detail_providers.dart).
        if (recipe.glassware.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            l10n.recipeDetailGlasswareTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: recipe.glassware
                .map(
                  (g) => ActionChip(
                    key: Key('recipeGlasswareChip-${g.id}'),
                    label: Text(g.name ?? g.id),
                    onPressed: () => showEntityInfoPopover(
                      context,
                      (ref) => ref.watch(equipmentInfoProvider(g.id)),
                    ),
                  ),
                )
                .toList(),
          ),
        ],

        if (recipe.equipment.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            l10n.recipeDetailEquipmentTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: recipe.equipment
                .map(
                  (e) => ActionChip(
                    key: Key('recipeEquipmentChip-${e.id}'),
                    label: Text(e.name ?? e.id),
                    onPressed: () => showEntityInfoPopover(
                      context,
                      (ref) => ref.watch(equipmentInfoProvider(e.id)),
                    ),
                  ),
                )
                .toList(),
          ),
        ],

        if (recipe.creatorAttribution != null) ...[
          const SizedBox(height: 16),
          Text(l10n.recipeDetailCreatorLabel(recipe.creatorAttribution!)),
        ],

        if (recipe.history != null) ...[
          const SizedBox(height: 16),
          Text(
            l10n.recipeDetailHistoryTitle,
            style: theme.textTheme.titleMedium,
          ),
          Text(recipe.history!),
        ],

        // FR-067: persistent responsible-consumption message on recipe pages,
        // with the FR-069 support-resources entry point.
        const ResponsibleUseBanner(surface: 'recipe'),
      ],
    );
  }
}
