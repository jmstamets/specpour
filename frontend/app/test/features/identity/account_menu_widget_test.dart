import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/identity/account_menu_screen.dart';

/// T161: the account/settings navigation shell — verifies each destination
/// actually navigates, since the whole point of this screen is making the
/// four (soon five) previously-unreachable screens reachable.
void main() {
  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/account',
      routes: [
        GoRoute(
          path: '/account',
          builder: (context, state) => const AccountMenuScreen(),
        ),
        GoRoute(
          path: '/account/mfa',
          builder: (context, state) => const _DestinationMarker('mfa'),
        ),
        GoRoute(
          path: '/account/sessions',
          builder: (context, state) => const _DestinationMarker('sessions'),
        ),
        GoRoute(
          path: '/account/channels',
          builder: (context, state) => const _DestinationMarker('channels'),
        ),
        GoRoute(
          path: '/account/data',
          builder: (context, state) => const _DestinationMarker('data'),
        ),
        GoRoute(
          path: '/account/lifecycle',
          builder: (context, state) => const _DestinationMarker('lifecycle'),
        ),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  for (final (buttonKey, destination) in [
    ('accountMenuMfaButton', 'mfa'),
    ('accountMenuSessionsButton', 'sessions'),
    ('accountMenuChannelsButton', 'channels'),
    ('accountMenuDataButton', 'data'),
    ('accountMenuLifecycleButton', 'lifecycle'),
  ]) {
    testWidgets('tapping $buttonKey navigates to /account/$destination', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(buttonKey)));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('destination-$destination')), findsOneWidget);
    });
  }
}

class _DestinationMarker extends StatelessWidget {
  const _DestinationMarker(this.name);

  final String name;

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Text(name, key: Key('destination-$name')));
}
