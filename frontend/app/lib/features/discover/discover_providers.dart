// T041: discover feature state — the current search query (null = "browsing,
// not searching") and a family facet filter, plus the two data providers that
// react to them. Kept as plain Riverpod providers (not a single AsyncNotifier)
// so the browse list and search results can be fetched/cached independently —
// switching from a search back to an empty query re-shows the already-cached
// browse list rather than re-fetching.

import 'package:api_client/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client_provider.dart';

class DiscoverQuery extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? query) =>
      state = (query == null || query.trim().isEmpty) ? null : query.trim();
}

final discoverQueryProvider = NotifierProvider<DiscoverQuery, String?>(
  DiscoverQuery.new,
);

/// FR-050's family facet (T041) — the seeded family taxonomy is a small,
/// curator-managed vocabulary (data-model.md's Family section), not something
/// that varies per deployment in V1, so it's listed here rather than fetched
/// from a dedicated taxonomy endpoint (none exists yet; a real gap, not an
/// oversight — flagged for a future task rather than built speculatively now).
/// Keys only (T157): display labels resolve through
/// core/l10n/content_key_labels.dart, never hardcoded copy (Principle VIII).
const discoverFamilyFacetKeys = <String>[
  'family.cocktail',
  'family.spiritForward',
  'family.sour',
  'family.highball',
  'family.cobbler',
  'family.flip',
];

class SelectedFamily extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? family) => state = family;
}

final selectedFamilyProvider = NotifierProvider<SelectedFamily, String?>(
  SelectedFamily.new,
);

final browseRecipesProvider = FutureProvider<RecipePage>((ref) async {
  final api = ref.watch(catalogApiProvider);
  final family = ref.watch(selectedFamilyProvider);
  final response = await api.listRecipes(family: family);
  return response.data!;
});

final searchResultsProvider = FutureProvider<SearchResultPage?>((ref) async {
  final query = ref.watch(discoverQueryProvider);
  if (query == null) {
    return null;
  }

  final api = ref.watch(searchApiProvider);
  final response = await api.search(q: query);
  return response.data!;
});

/// Turns a recipe/result title into the stable, predictable widget key suffix
/// used across the discover feature (e.g. "Mai Tai" -> "mai-tai") — deterministic
/// so both browse and search tiles for the same recipe carry the same key.
String discoverResultKeySlug(String title) => title
    .trim()
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'^-+|-+$'), '');
