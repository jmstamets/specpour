// T156: reusable entity info popover — tap an ingredient line, glassware
// chip, or equipment chip on recipe detail to see its description/usage
// note plus a link to its full entry (IngredientDetailScreen /
// EquipmentDetailScreen). Driven by a `watch` closure (rather than a
// provider reference directly — Riverpod 3.3.2's `ProviderListenable` type
// isn't part of flutter_riverpod's public export surface) so Phase 10's
// T098 (glossary term taps) can reuse the same widget with its own provider:
// `(ref) => ref.watch(glossaryTermInfoProvider(termId))`.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import 'entity_info_data.dart';

typedef EntityInfoWatch = AsyncValue<EntityInfoData> Function(WidgetRef ref);

Future<void> showEntityInfoPopover(BuildContext context, EntityInfoWatch watch) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => EntityInfoPopover(watch: watch),
  );
}

class EntityInfoPopover extends ConsumerWidget {
  const EntityInfoPopover({required this.watch, super.key});

  final EntityInfoWatch watch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final info = watch(ref);

    return SafeArea(
      child: Padding(
        key: const Key('entityInfoPopover'),
        padding: const EdgeInsets.all(16),
        child: info.when(
          loading: () => const SizedBox(
            height: 96,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Text(l10n.discoverSearchEmpty),
          data: (data) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(data.description ?? l10n.entityInfoNoDescription),
              if (data.usageNote != null) ...[
                const SizedBox(height: 8),
                Text('${l10n.entityInfoUsageLabel}: ${data.usageNote}'),
              ],
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  key: const Key('entityInfoPopoverFullEntryButton'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(data.fullEntryRoute);
                  },
                  child: Text(l10n.entityInfoFullEntryButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
