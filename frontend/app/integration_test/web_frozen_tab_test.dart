// ADR-0005 (T177) frozen-tab refresh hardening — John's PR #2 merge review
// finding. Simulates the exact shape that finding described: a tab Chrome
// suspended in the background misses the BroadcastChannel wake for a peer's
// rotation; if that peer's own contention burst has since fully drained (a
// lone, uncontended refresh drains immediately — maybeClearHandoffAfterDrain),
// the handoff is already gone by the time the frozen tab resumes and tries
// its own refresh with its now-stale in-memory token. Without the fix, that
// presents an already-redeemed token far outside the 30s reuse leeway,
// tripping reuse detection and revoking the WHOLE session — every tab
// logged out, the exact benign-race logout the election exists to prevent.
//
// Unlike web_multitab_test.dart (genuine SIMULTANEOUS contention via a
// deterministic barrier), this is deliberately SEQUENTIAL: the orchestrator
// completes its own lone refresh (and drain) BEFORE the frozen agent ever
// attempts its own — there is no race here to force, only a stale value to
// simulate holding onto.

import 'dart:async';
import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/auth/refresh_coordinator.dart';
import 'package:specpour_app/core/auth/token_store.dart';
import 'package:web/web.dart' as web;

import 'support/cold_restart.dart';
import 'support/register_fresh_account.dart';

const _controlChannel = 'specpour.frozen-tab-test-control';
const _msgAgentReadyPrefix = 'agent-ready:'; // + the agent's captured token
const _msgGoFrozen = 'go-frozen';
const _msgResultPrefix = 'agent-result:';

final _raceRefreshProvider = FutureProvider.family<bool, String>((
  ref,
  startingRefreshToken,
) {
  return coordinatedRefresh(ref, startingRefreshToken: startingRefreshToken);
});

// Held at module scope in the agent so its container + channel outlive
// _runAgent()'s return and stay alive to react to "go-frozen" — the
// assignment IS the keep-alive, deliberately write-only.
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

  final control = web.BroadcastChannel(_controlChannel);
  _agentControl = control;

  // Capture whatever this context currently has persisted — simulating "the
  // token I read before I froze" — BEFORE the orchestrator does its own lone
  // refresh and rotates it out from under this (still-fresh) read. This is
  // deliberately the agent's OWN persisted-storage read at boot, not a value
  // handed to it, so the capture timing is realistic: a real frozen tab
  // would have loaded its session normally before being suspended.
  unawaited(
    container.read(tokenStoreProvider).readRefreshToken().then((
      staleToken,
    ) async {
      if (staleToken == null) {
        return;
      }
      control.onmessage = ((web.MessageEvent event) {
        final data = event.data;
        if (data == null || !data.isA<JSString>()) {
          return;
        }
        if ((data as JSString).toDart != _msgGoFrozen) {
          return;
        }
        // The frozen tab's next 401: present the STALE captured token, not
        // whatever is now actually persisted — that's the whole scenario.
        container.read(_raceRefreshProvider(staleToken).future).then((ok) {
          control.postMessage('$_msgResultPrefix$ok'.toJS);
        });
      }).toJS;

      control.postMessage('$_msgAgentReadyPrefix$staleToken'.toJS);
    }),
  );
}

void _runOrchestrator() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  testWidgets(
    'T177 frozen-tab hardening: a resumed tab with a stale in-memory token '
    'refreshes successfully using the live-persisted token instead, session '
    'survives, no wasted/extra wire attempts',
    (tester) async {
      final ref = await coldRestart(tester);
      await registerFreshAccount(tester, ref, testTag: 'frozentab');

      final control = web.BroadcastChannel(_controlChannel);
      String? staleAgentToken;
      bool? agentResult;
      control.onmessage = ((web.MessageEvent event) {
        final data = event.data;
        if (data == null || !data.isA<JSString>()) {
          return;
        }
        final text = (data as JSString).toDart;
        if (text.startsWith(_msgAgentReadyPrefix)) {
          staleAgentToken = text.substring(_msgAgentReadyPrefix.length);
        } else if (text.startsWith(_msgResultPrefix)) {
          agentResult = text.substring(_msgResultPrefix.length) == 'true';
        }
      }).toJS;

      final iframe = web.HTMLIFrameElement();
      iframe.src = web.window.location.href;
      iframe.style.width = '0';
      iframe.style.height = '0';
      web.document.body!.appendChild(iframe);

      for (var i = 0; i < 40 && staleAgentToken == null; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }
      expect(
        staleAgentToken,
        isNotNull,
        reason: 'the iframe agent never captured its starting token',
      );

      // The orchestrator's OWN lone refresh — uncontended, so it drains
      // immediately (maybeClearHandoffAfterDrain sees nobody queued). This is
      // what makes staleAgentToken stale by the time the agent uses it below.
      final ownStartingToken = await ref
          .read(tokenStoreProvider)
          .readRefreshToken();
      expect(ownStartingToken, staleAgentToken, reason: 'sanity: same token');
      final ownRefreshOk = await ref.read(
        _raceRefreshProvider(ownStartingToken!).future,
      );
      expect(ownRefreshOk, isTrue, reason: 'orchestrator lone refresh');

      final rotatedToken = await ref
          .read(tokenStoreProvider)
          .readRefreshToken();
      expect(
        rotatedToken,
        isNot(staleAgentToken),
        reason:
            'the rotation must have actually happened — otherwise this test '
            'never exercises the stale-token scenario at all',
      );

      // Now let the "frozen" agent wake up and try ITS OWN (stale) token.
      control.postMessage(_msgGoFrozen.toJS);

      for (var i = 0; i < 40 && agentResult == null; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }

      expect(
        agentResult,
        isTrue,
        reason:
            'a frozen tab presenting a stale token must still land signed '
            'in via the live-read fallback, not revoke the session',
      );

      // Zero revocation events: if reuse detection had tripped, the
      // orchestrator's own session would also be dead by now.
      final token = ref.read(authTokenProvider)!;
      final sessionsResponse = await ref
          .read(authDioProvider)
          .get<Map<String, dynamic>>(
            '/api/v1/me/sessions',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );
      final sessions = sessionsResponse.data!['sessions'] as List<dynamic>;
      expect(
        sessions,
        hasLength(1),
        reason:
            'the session must still be live — a revocation would have '
            'filtered it out of this list entirely',
      );

      // Total wire attempts: exactly 2 — the orchestrator's own lone
      // rotation, plus the agent's ONE corrected attempt (never a wasted
      // attempt on the stale token first — the fix substitutes the live
      // token BEFORE any network call, by construction).
      final attemptsResponse = await ref
          .read(authDioProvider)
          .get<Map<String, dynamic>>(
            '/dev/refresh-attempts',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );
      expect(
        attemptsResponse.data!['attempts'],
        2,
        reason:
            'expected exactly 2 wire attempts (orchestrator rotation + the '
            'agent\'s one corrected attempt); anything else means either a '
            'wasted attempt on the stale token or a missed one',
      );
    },
  );
}
