import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/guest_gate/guest_gate.dart';
import 'package:specpour_app/core/guest_gate/pending_intent.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';

/// T043: guest gating (US1 scenario 6 — prompt to sign in, then complete the
/// original action after signup with no lost intent).
void main() {
  Widget hostButton(
    WidgetRef Function(WidgetRef) capture,
    VoidCallback action,
  ) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Consumer(
          builder: (context, ref, _) {
            capture(ref);
            return Scaffold(
              body: ElevatedButton(
                key: const Key('gatedAction'),
                onPressed: () => requireAccount(
                  ref: ref,
                  context: context,
                  actionLabel: 'save this recipe',
                  onAuthenticated: action,
                ),
                child: const Text('Save'),
              ),
            );
          },
        ),
      ),
    );
  }

  testWidgets('a guest is prompted to sign in and the action is NOT yet run', (
    tester,
  ) async {
    var ran = false;
    late WidgetRef ref;
    await tester.pumpWidget(hostButton((r) => ref = r, () => ran = true));

    await tester.tap(find.byKey(const Key('gatedAction')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('accountGateSignInPrompt')), findsOneWidget);
    expect(ran, isFalse);
    expect(ref.read(pendingGuestIntentProvider), isNotNull);
    expect(
      ref.read(pendingGuestIntentProvider)!.actionLabel,
      'save this recipe',
    );
  });

  testWidgets('the captured intent completes after the user signs in', (
    tester,
  ) async {
    var ran = false;
    late WidgetRef ref;
    await tester.pumpWidget(hostButton((r) => ref = r, () => ran = true));

    await tester.tap(find.byKey(const Key('gatedAction')));
    await tester.pumpAndSettle();
    expect(ran, isFalse);

    // Simulate the sign-in flow (T055): a token arrives, then the pending intent
    // is replayed.
    ref.read(authTokenProvider.notifier).set('fake-token');
    completePendingIntent(ref);
    await tester.pumpAndSettle();

    expect(ran, isTrue);
    expect(ref.read(pendingGuestIntentProvider), isNull);
  });

  testWidgets('an already-signed-in user runs the action with no prompt', (
    tester,
  ) async {
    var ran = false;
    late WidgetRef ref;
    await tester.pumpWidget(hostButton((r) => ref = r, () => ran = true));

    ref.read(authTokenProvider.notifier).set('fake-token');
    await tester.pump();

    await tester.tap(find.byKey(const Key('gatedAction')));
    await tester.pumpAndSettle();

    expect(ran, isTrue);
    expect(find.byKey(const Key('accountGateSignInPrompt')), findsNothing);
  });
}
