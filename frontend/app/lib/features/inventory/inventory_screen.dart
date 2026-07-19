// T070: the inventory home screen — the caller's own bottles (T066 CRUD)
// and, on a second tab, what they can make from them (T067's makeability
// engine, including near-misses per T148's ratified per-line detail). Not
// yet reachable from any navigation chrome (same flagged gap as
// mfa_settings_screen.dart/T161's session screens) — direct-route only.

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/api_client_provider.dart';
import '../../core/auth/identity_auth_service.dart' show describeIdentityError;
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/widgets/api_error_display.dart';
import 'inventory_providers.dart';

/// A short, human-readable label for a match-quality value — `.name` on the
/// generated enum returns the Dart member name ("classSatisfied"), not
/// display copy.
String describeMatchQuality(AppLocalizations l10n, MatchQuality quality) =>
    switch (quality) {
      MatchQuality.exactProduct => l10n.inventoryMatchQualityExactProduct,
      MatchQuality.classSatisfied => l10n.inventoryMatchQualityClassSatisfied,
      MatchQuality.substitution => l10n.inventoryMatchQualitySubstitution,
      _ => quality.name,
    };

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: const Key('inventoryScreen'),
        appBar: AppBar(
          title: Text(l10n.inventoryTitle),
          bottom: TabBar(
            tabs: [
              Tab(
                key: const Key('inventoryItemsTab'),
                text: l10n.inventoryItemsTabLabel,
              ),
              Tab(
                key: const Key('inventoryMakeableTab'),
                text: l10n.inventoryMakeableTabLabel,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: const Key('inventoryAddFab'),
          tooltip: l10n.inventoryAddButtonTooltip,
          onPressed: () async {
            await context.push('/inventory/add');
            ref.invalidate(myInventoryItemsProvider);
            ref.invalidate(myMakeableResponseProvider);
          },
          child: const Icon(Icons.add),
        ),
        body: const TabBarView(
          children: [_InventoryItemsTab(), _MakeableTab()],
        ),
      ),
    );
  }
}

class _InventoryItemsTab extends ConsumerWidget {
  const _InventoryItemsTab();

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    InventoryItem item,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('inventoryDeleteConfirmDialog'),
        title: Text(l10n.inventoryDeleteConfirmTitle),
        content: Text(l10n.inventoryDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.inventoryCancelButton),
          ),
          TextButton(
            key: const Key('inventoryDeleteConfirmDialogButton'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.inventoryDeleteButton),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }

    await ref.read(inventoryApiProvider).deleteInventoryItem(id: item.id);
    ref.invalidate(myInventoryItemsProvider);
    ref.invalidate(myMakeableResponseProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(myInventoryItemsProvider);

    return items.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(24),
        child: ApiErrorDisplay(message: describeIdentityError(error)),
      ),
      data: (list) => list.isEmpty
          ? Center(
              key: const Key('inventoryEmptyState'),
              child: Text(l10n.inventoryEmptyMessage),
            )
          : ListView(
              children: [
                for (final item in list)
                  ListTile(
                    key: Key('inventoryListItem-${item.id}'),
                    leading: const Icon(Icons.liquor_outlined),
                    title: Text(item.ingredientName ?? item.ingredientId),
                    subtitle: item.quantity == null && item.bottleSize == null
                        ? null
                        : Text(
                            [
                              if (item.quantity != null) '${item.quantity}',
                              if (item.bottleSize != null) item.bottleSize!,
                            ].join(' · '),
                          ),
                    trailing: IconButton(
                      key: Key('inventoryDeleteButton-${item.id}'),
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(context, ref, item),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _MakeableTab extends ConsumerWidget {
  const _MakeableTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final makeable = ref.watch(myMakeableResponseProvider);

    return makeable.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(24),
        child: ApiErrorDisplay(message: describeIdentityError(error)),
      ),
      data: (response) {
        if (response.makeable.isEmpty && response.nearMiss.isEmpty) {
          return Center(
            key: const Key('inventoryMakeableEmptyState'),
            child: Text(l10n.inventoryMakeableEmptyMessage),
          );
        }

        return ListView(
          children: [
            for (final recipe in response.makeable)
              ListTile(
                key: Key('makeableRecipeItem-${recipe.recipeId}'),
                leading: const Icon(Icons.local_bar_outlined),
                title: Text(recipe.recipeName),
                subtitle: Text(describeMatchQuality(l10n, recipe.matchQuality)),
              ),
            for (final recipe in response.nearMiss)
              ListTile(
                key: Key('nearMissRecipeItem-${recipe.recipeId}'),
                leading: const Icon(Icons.local_bar_outlined),
                title: Text(recipe.recipeName),
                subtitle: Text(
                  [
                    l10n.inventoryNearMissLabel,
                    for (final line in recipe.lines)
                      if (line.matchQuality == MatchQuality.missing)
                        l10n.inventoryMissingIngredientLabel(
                          line.requirement.ingredientName ??
                              line.requirement.ingredientId,
                        ),
                  ].join(' — '),
                ),
              ),
          ],
        );
      },
    );
  }
}
