// T150: the footer/about surface (FR-067's "footer/about" placement + FR-069's
// "reachable from settings/about"). Reachable from the discover screen's app bar.
// Reuses the same ResponsibleUseBanner as recipe pages, with the footer_about
// surface class.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/gen/app_localizations.dart';
import '../../core/responsible_use/responsible_use_banner.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      key: const Key('aboutScreen'),
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.appTitle, style: Theme.of(context).textTheme.headlineSmall),
          const ResponsibleUseBanner(surface: 'footer_about'),
        ],
      ),
    );
  }
}
