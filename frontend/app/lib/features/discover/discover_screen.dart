// T041: guest-accessible browse/search home screen (US1 scenarios 1, 5, 6).
// No account/entitlement gate wraps this screen at all — reading the curated
// library is unrestricted for anonymous visitors (FR-004b); interactive/
// personalized actions get their own gate later (T043), not here.

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/content_key_labels.dart';
import '../../core/l10n/gen/app_localizations.dart';
import 'discover_providers.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(discoverQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.discoverTitle),
        actions: [
          IconButton(
            key: const Key('aboutNavButton'),
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.aboutTitle,
            onPressed: () => context.push('/about'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const Key('discoverSearchField'),
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.discoverSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query == null
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(discoverQueryProvider.notifier).set(null);
                        },
                      ),
              ),
              onSubmitted: (value) =>
                  ref.read(discoverQueryProvider.notifier).set(value),
            ),
            if (query == null) ...[
              const SizedBox(height: 12),
              const _FamilyFacetRow(),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: query == null ? const _BrowseList() : const _SearchList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _FamilyFacetRow extends ConsumerWidget {
  const _FamilyFacetRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(selectedFamilyProvider);

    return Wrap(
      spacing: 8,
      children: discoverFamilyFacetKeys.map((familyKey) {
        return FilterChip(
          key: Key('discoverFamilyFacet-$familyKey'),
          label: Text(resolveFamilyDisplayName(l10n, familyKey)),
          selected: selected == familyKey,
          onSelected: (isSelected) => ref
              .read(selectedFamilyProvider.notifier)
              .set(isSelected ? familyKey : null),
        );
      }).toList(),
    );
  }
}

class _BrowseList extends ConsumerWidget {
  const _BrowseList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final page = ref.watch(browseRecipesProvider);

    return page.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(l10n.discoverBrowseEmpty)),
      data: (page) {
        if (page.items.isEmpty) {
          return Center(child: Text(l10n.discoverBrowseEmpty));
        }

        return ListView.builder(
          key: const Key('discoverBrowseList'),
          itemCount: page.items.length,
          itemBuilder: (context, index) {
            final recipe = page.items[index];
            final familyKey = recipe.familyKey;
            return _RecipeResultTile(
              id: recipe.id,
              title: recipe.primaryName,
              // T157: familyKey is a taxonomy i18n key ("family.sour"), never
              // shown raw — resolve to the localized display name.
              subtitle: familyKey == null
                  ? null
                  : resolveFamilyDisplayName(l10n, familyKey),
            );
          },
        );
      },
    );
  }
}

class _SearchList extends ConsumerWidget {
  const _SearchList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final results = ref.watch(searchResultsProvider);

    return results.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(l10n.discoverSearchEmpty)),
      data: (page) {
        final items = page?.items.toList() ?? const <SearchResult>[];
        if (items.isEmpty) {
          return Center(child: Text(l10n.discoverSearchEmpty));
        }

        // FR-049 (amended 2026-07-12): results are typed and GROUPED in
        // presentation — recipes / ingredients / equipment / glossary — so the
        // user always knows what kind of entity each result is. Within a group,
        // backend relevance order is preserved; glossaryTerm + article both
        // present under "Glossary" (one knowledge-base group, per §13's wording).
        final groups = _groupResults(items, l10n);

        return ListView(
          key: const Key('discoverSearchResultsList'),
          children: [
            for (final group in groups) ...[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(
                  group.header,
                  key: Key('discoverSearchGroup-${group.keySuffix}'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              for (final result in group.results)
                if (result.entityType == SearchResultEntityTypeEnum.recipe)
                  _RecipeResultTile(id: result.entityId, title: result.title)
                else
                  // Non-recipe results are shown but not yet navigable — their
                  // detail screens land with their own stories (T155/T156 add
                  // ingredient/equipment surfaces; Phase 10 adds glossary).
                  ListTile(title: Text(result.title)),
            ],
          ],
        );
      },
    );
  }

  List<_SearchGroup> _groupResults(
    List<SearchResult> items,
    AppLocalizations l10n,
  ) {
    _SearchGroup make(
      String header,
      String keySuffix,
      bool Function(SearchResult) match,
    ) => _SearchGroup(header, keySuffix, items.where(match).toList());

    final groups = [
      make(
        l10n.discoverGroupRecipes,
        'recipes',
        (r) => r.entityType == SearchResultEntityTypeEnum.recipe,
      ),
      make(
        l10n.discoverGroupIngredients,
        'ingredients',
        (r) => r.entityType == SearchResultEntityTypeEnum.ingredient,
      ),
      make(
        l10n.discoverGroupEquipment,
        'equipment',
        (r) => r.entityType == SearchResultEntityTypeEnum.equipment,
      ),
      make(
        l10n.discoverGroupGlossary,
        'glossary',
        (r) =>
            r.entityType == SearchResultEntityTypeEnum.glossaryTerm ||
            r.entityType == SearchResultEntityTypeEnum.article,
      ),
    ];

    return [
      for (final group in groups)
        if (group.results.isNotEmpty) group,
    ];
  }
}

class _SearchGroup {
  const _SearchGroup(this.header, this.keySuffix, this.results);

  final String header;
  final String keySuffix;
  final List<SearchResult> results;
}

class _RecipeResultTile extends StatelessWidget {
  const _RecipeResultTile({
    required this.id,
    required this.title,
    this.subtitle,
  });

  final String id;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('recipeResultTile-${discoverResultKeySlug(title)}'),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      onTap: () => context.push('/recipes/$id'),
    );
  }
}
