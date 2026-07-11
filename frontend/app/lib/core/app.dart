import 'package:flutter/material.dart';

import 'l10n/gen/app_localizations.dart';
import '../features/home/home_page.dart';

/// Root widget. Routing (go_router), DI (Riverpod), and full theming
/// (WCAG AA + bar-mode tokens) land in the Foundational phase (plan.md T028) —
/// this is the Phase 1 scaffold wiring the app shell and i18n only.
class SpecPourApp extends StatelessWidget {
  const SpecPourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}
