import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/gen/app_localizations.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';

/// Root widget (T028): go_router navigation, WCAG AA light/dark theming. Riverpod DI
/// wraps this in main.dart (ProviderScope); bar mode's theme is opted into per-screen
/// by T126, not applied app-wide here.
class SpecPourApp extends ConsumerWidget {
  const SpecPourApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: SpecPourTheme.light(),
      darkTheme: SpecPourTheme.dark(),
      routerConfig: router,
    );
  }
}
