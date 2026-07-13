// T150: the persistent responsible-consumption banner (FR-067) plus the
// support-resources entry point (FR-069). Reusable across every surface FR-067
// mandates — recipe pages, batch outputs (US5), and footer/about. The message
// copy is resolved from the backend-supplied i18n content key, never hard-coded
// (FR-067); an unrecognized key falls back to a generic message rather than
// leaving the surface bare.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/gen/app_localizations.dart';
import 'responsible_use_providers.dart';

/// Maps a backend responsible-consumption content key to its localized string.
/// ARB keys can't contain dots, so the dotted content keys are mapped explicitly;
/// an unknown key falls back to a generic responsible-use message (FR-067: the
/// surface must never be left without a message).
String resolveResponsibleUseMessage(AppLocalizations l10n, String contentKey) {
  return switch (contentKey) {
    'responsibleUse.message.default' => l10n.responsibleUseMessageDefault,
    _ => l10n.responsibleUseMessageFallback,
  };
}

class ResponsibleUseBanner extends ConsumerWidget {
  const ResponsibleUseBanner({required this.surface, super.key});

  /// One of the backend surface classes: "recipe", "batch_output", "footer_about".
  final String surface;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final message = ref.watch(responsibleUseMessageProvider(surface));

    // Never block or hide the surface on a messaging fetch failure — fall back to
    // the generic message so FR-067's "persistent, always present" guarantee holds
    // even offline.
    final text = message.maybeWhen(
      data: (m) => resolveResponsibleUseMessage(l10n, m.messageContentKey),
      orElse: () => l10n.responsibleUseMessageFallback,
    );

    return Container(
      key: const Key('responsibleUseBanner'),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          TextButton(
            key: const Key('responsibleUseSupportResourcesButton'),
            onPressed: () => _showSupportResources(context, ref),
            child: Text(l10n.responsibleUseSupportResourcesButton),
          ),
        ],
      ),
    );
  }

  Future<void> _showSupportResources(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        final resources = ref.watch(supportResourcesProvider);
        return Padding(
          key: const Key('supportResourcesSheet'),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.responsibleUseSupportResourcesTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              resources.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => const SizedBox.shrink(),
                data: (data) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final resource in data.items)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(resource.name),
                        subtitle: Text(resource.link),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
