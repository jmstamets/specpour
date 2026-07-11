import 'package:flutter/material.dart';

import '../../core/l10n/gen/app_localizations.dart';

/// Placeholder landing screen. Replaced by the discover feature (plan.md T041)
/// once the Foundational phase's routing/DI shell (T028) is in place.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).appTitle)),
      body: const Center(child: Text('SpecPour')),
    );
  }
}
