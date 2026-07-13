// T042: concept page (US1 scenario 3) — each variant lists a differentiator
// and routes to its full recipe.

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import 'concept_detail_providers.dart';

class ConceptDetailScreen extends ConsumerWidget {
  const ConceptDetailScreen({required this.conceptId, super.key});

  final String conceptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final concept = ref.watch(conceptDetailProvider(conceptId));

    return Scaffold(
      key: const Key('conceptDetailScreen'),
      appBar: AppBar(title: Text(concept.value?.name ?? '')),
      body: concept.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(l10n.discoverSearchEmpty)),
        data: (concept) => _ConceptDetailBody(concept: concept, l10n: l10n),
      ),
    );
  }
}

class _ConceptDetailBody extends StatelessWidget {
  const _ConceptDetailBody({required this.concept, required this.l10n});

  final ConceptDetail concept;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(concept.description, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 16),
        Text(
          l10n.conceptDetailVariantsTitle,
          style: theme.textTheme.titleMedium,
        ),
        Column(
          key: const Key('conceptVariantList'),
          children: concept.variants
              .map(
                (variant) => ListTile(
                  key: Key('conceptVariantTile-${variant.recipeId}'),
                  title: Text(variant.recipeName),
                  subtitle: Text(variant.differentiatorText),
                  onTap: () => context.push('/recipes/${variant.recipeId}'),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
