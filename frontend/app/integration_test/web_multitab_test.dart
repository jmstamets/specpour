// ADR-0005 (T177 #100) cross-tab election — MECHANISM test (two real contexts).
//
// The single-context flutter-drive harness can't drive two real TABS (a
// window.open probe wedged the run — see ADR-0005). This uses a same-origin
// <iframe> instead: a second real browsing context that shares the origin's
// Web Locks, BroadcastChannel, and localStorage with the driven top document,
// but stays a CHILD of the one driver-controlled document (no second window
// handle to wedge the driver — feasibility confirmed by an earlier gate). One
// bundle, one origin; main() branches on whether it's the top frame (the driven
// orchestrator) or the iframe (a minimal, UI-less second agent — John's ladder
// variant (b): faithful, it runs the unmodified production coordinatedRefresh
// and merely lacks chrome).
//
// The assertion is the MECHANISM, not the outcome (the ADR's leeway rider):
// exactly ONE refresh_token grant crosses the wire when two contexts race,
// measured by a Development-gated server-side refresh-ATTEMPT counter — an
// attempt counter, not a success counter, because a broken election whose two
// requests both land inside OpenIddict's 30s reuse leeway would BOTH succeed,
// false-greening an outcome-only test.
//
// Contention is deterministic (Rider 2): both contexts call the production
// coordinatedRefresh on a shared "go" signal. coordinatedRefresh requests the
// Web Lock BEFORE any network call, so both are queued before either's refresh
// completes — the winner refreshes (~tens of ms round trip), the loser is
// guaranteed to be waiting and adopts. (Invoking coordinatedRefresh directly is
// the same entry the 401 interceptor uses; going through an actual 401 round
// trip first would add variable latency that could let one refresh finish
// before the other even requests the lock — turning genuine contention into a
// sequential non-race and making the "exactly one" assertion flaky. The
// interceptor -> coordinatedRefresh wiring is covered by the single-tab paths;
// this test isolates the election under guaranteed simultaneity.)

import 'dart:async';
import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/app.dart';
import 'package:specpour_app/core/auth/refresh_coordinator.dart';
import 'package:specpour_app/core/auth/token_store.dart';
import 'package:specpour_app/core/routing/app_router.dart';
import 'package:web/web.dart' as web;

/// The test's own handshake channel — carries agent-ready / go / result, never
/// real tokens (those move on the app's own 'specpour.auth' channel).
const _controlChannel = 'specpour.test-control';
const _msgAgentReady = 'agent-ready';
const _msgGo = 'go';
const _msgResultPrefix = 'agent-result:';

/// Runs the production election with whatever refresh token is currently in
/// shared storage — the single entry both the orchestrator and the iframe agent
/// trigger on "go". A provider so coordinatedRefresh gets a real Ref.
final _raceRefreshProvider = FutureProvider<bool>((ref) async {
  final token = await ref.read(tokenStoreProvider).readRefreshToken();
  if (token == null) {
    return false;
  }
  return coordinatedRefresh(ref, startingRefreshToken: token);
});

// Held at module scope in the agent so its container + channel outlive
// _runAgent()'s return and stay alive to react to "go" (the assignment IS the
// keep-alive — these are deliberately write-only).
// ignore: unused_element
ProviderContainer? _agentContainer;
// ignore: unused_element
web.BroadcastChannel? _agentControl;

void main() {
  if (web.window.frameElement != null) {
    _runAgent();
    return;
  }
  _runOrchestrator();
}

void _runAgent() {
  final container = ProviderContainer();
  _agentContainer = container;
  // Start the cross-tab listener so, if this agent is the election LOSER, it
  // receives the winner's broadcast and adopts (coordinatedRefresh's adopt path).
  container.read(crossTabAuthSyncProvider);

  final control = web.BroadcastChannel(_controlChannel);
  _agentControl = control;
  control.onmessage = ((web.MessageEvent event) {
    final data = event.data;
    if (data == null || !data.isA<JSString>()) {
      return;
    }
    if ((data as JSString).toDart != _msgGo) {
      return;
    }
    // Race the orchestrator: run the production election right now.
    container.read(_raceRefreshProvider.future).then((ok) {
      control.postMessage('$_msgResultPrefix$ok'.toJS);
    });
  }).toJS;

  control.postMessage(_msgAgentReady.toJS);
}

void _runOrchestrator() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  testWidgets(
    'T177 #100: two racing contexts → exactly one refresh crosses the wire, both signed in, zero revocations',
    (tester) async {
      late WidgetRef ref;
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, r, _) {
              ref = r;
              return const SpecPourApp();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // A fresh adult account → this run's own session and (fresh) user, so the
      // server-side attempt counter is isolated to this test.
      ref.read(appRouterProvider).go('/register');
      await tester.pumpAndSettle();
      final email =
          'multitab-${DateTime.now().microsecondsSinceEpoch}@example.test';
      await tester.enterText(
        find.byKey(const Key('registerEmailField')),
        email,
      );
      await tester.enterText(
        find.byKey(const Key('registerPasswordField')),
        'correct horse battery staple',
      );
      await tester.enterText(
        find.byKey(const Key('registerDisplayNameField')),
        'Multitab User',
      );
      await tester.tap(find.byKey(const Key('registerDateOfBirthButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, '07/14/2000');
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('registerSubmitButton')));
      await tester.pumpAndSettle(const Duration(seconds: 10));
      expect(
        ref.read(authTokenProvider),
        isNotNull,
        reason: 'registered + signed in',
      );

      // Control-channel handshake with the iframe agent.
      final control = web.BroadcastChannel(_controlChannel);
      var agentReady = false;
      bool? agentResult;
      control.onmessage = ((web.MessageEvent event) {
        final data = event.data;
        if (data == null || !data.isA<JSString>()) {
          return;
        }
        final text = (data as JSString).toDart;
        if (text == _msgAgentReady) {
          agentReady = true;
        } else if (text.startsWith(_msgResultPrefix)) {
          agentResult = text.substring(_msgResultPrefix.length) == 'true';
        }
      }).toJS;

      // Boot the second real context: a same-origin iframe running the same
      // bundle → its main() takes the agent branch.
      final iframe = web.HTMLIFrameElement();
      iframe.src = web.window.location.href;
      iframe.style.width = '0';
      iframe.style.height = '0';
      web.document.body!.appendChild(iframe);

      for (var i = 0; i < 40 && !agentReady; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }
      expect(
        agentReady,
        isTrue,
        reason: 'the iframe agent never signalled ready',
      );

      // DETERMINISTIC CONTENTION BARRIER (Rider 2). Localhost refreshes are so
      // fast (~ms) that a plain "both go" lets the winner finish and rotate the
      // token before the loser even requests the lock — a sequential non-race
      // (both then legitimately refresh → 2 attempts), NOT an election failure.
      // To force a genuine race: pre-acquire the production lock here and HOLD
      // it, so both contexts' coordinatedRefresh requests QUEUE behind us before
      // either can proceed; only then release. Both are guaranteed to contend.
      final release = Completer<void>();
      final held = Completer<void>();
      final grantedCallback = ((web.Lock? lock) {
        held.complete();
        return release.future.then<JSAny?>((_) => null).toJS;
      }).toJS;
      web.window.navigator.locks.request('specpour.refresh', grantedCallback);
      await held.future;

      Future<int> pendingRefreshLocks() async {
        final snapshot = await web.window.navigator.locks.query().toDart;
        var count = 0;
        for (final info in snapshot.pending.toDart) {
          if (info.name == 'specpour.refresh') {
            count++;
          }
        }
        return count;
      }

      // GO — both contexts call the production election; both queue behind the
      // barrier. Kick off the orchestrator's own refresh WITHOUT awaiting it yet
      // (it can't complete until we release), so we can poll + release.
      control.postMessage(_msgGo.toJS);
      final orchestratorRefresh = ref.read(_raceRefreshProvider.future);

      var queued = 0;
      for (var i = 0; i < 40 && queued < 2; i++) {
        await tester.pump(const Duration(milliseconds: 250));
        await Future<void>.delayed(const Duration(milliseconds: 250));
        queued = await pendingRefreshLocks();
      }
      expect(
        queued,
        greaterThanOrEqualTo(2),
        reason:
            'both contexts must queue on the refresh lock before the race is '
            'released; only $queued pending — the contention barrier never '
            'engaged, so this run would not have been a genuine race.',
      );

      // Release the barrier — the queued requests now drain under real
      // contention: winner refreshes, loser adopts.
      release.complete();
      final orchestratorOk = await orchestratorRefresh;

      for (var i = 0; i < 40 && agentResult == null; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }

      // Both agents ended signed in (both coordinatedRefresh calls returned true).
      // If the election were broken and both refreshes landed outside the leeway,
      // reuse detection would revoke the session and the loser would come back
      // false — so "both true" already rules revocation out.
      expect(
        orchestratorOk,
        isTrue,
        reason: 'orchestrator context should be signed in',
      );
      expect(
        agentResult,
        isTrue,
        reason: 'iframe agent context should be signed in',
      );

      // THE mechanism assertion: exactly one refresh_token grant reached the
      // server for this user. A broken election that both-succeed inside the
      // leeway would read 2 here — which "both signed in" alone cannot catch.
      final token = ref.read(authTokenProvider)!;
      final response = await ref
          .read(authDioProvider)
          .get<Map<String, dynamic>>(
            '/dev/refresh-attempts',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );
      final attempts = response.data!['attempts'] as int;
      expect(
        attempts,
        1,
        reason:
            'exactly ONE refresh must cross the wire under a two-context race; '
            'got $attempts (2 ⇒ the single-refresher election is broken and the '
            'reuse leeway is silently covering for it).',
      );
    },
  );
}
