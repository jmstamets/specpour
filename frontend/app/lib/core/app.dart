import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth/refresh_coordinator.dart';
import 'auth/session_restore.dart';
import 'l10n/gen/app_localizations.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';

/// Root widget (T028): go_router navigation, WCAG AA light/dark theming. Riverpod DI
/// wraps this in main.dart (ProviderScope); bar mode's theme is opted into per-screen
/// by T126, not applied app-wide here.
///
/// ADR-0005 (T177): [sessionRestoreProvider] is watched here to kick off the
/// silent-session-restore attempt on every app build, but the router renders
/// immediately regardless — restore is NOT gated on. A successful restore
/// updates authTokenProvider/refreshTokenProvider reactively once it
/// completes, the same as any other async state change the app already
/// reacts to; failure is silent by construction (silentlyRefreshTokens never
/// throws). A blocking splash was tried and reverted: `pumpAndSettle` (used
/// throughout this codebase's widget/browser tests) settles based on frame
/// scheduling, not arbitrary pending Futures — a static splash with nothing
/// actively animating gets judged "settled" almost immediately, so tests
/// would observe the splash forever regardless of how fast the underlying
/// restore actually completes (confirmed by direct reproduction: every
/// existing test that pumps SpecPourApp broke against the blocking version).
class SpecPourApp extends ConsumerWidget {
  const SpecPourApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(sessionRestoreProvider);
    // ADR-0005 (T177): start listening for sibling tabs' refreshes so this tab
    // adopts their rotated tokens instead of racing. No-op on native.
    ref.watch(crossTabAuthSyncProvider);

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
