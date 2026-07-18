// T188 sign-out (current session) — browser tier, against the real backend.
//
// Two things unit/widget tests can't prove and that the walkthrough cares about:
//   1. Sign out then RELOAD stays signed out — the persisted refresh token is
//      really gone, so app-start session restore finds nothing (a memory-only
//      clear would silently come back on reload).
//   2. A SECOND open tab also lands signed out — the cross-tab BroadcastChannel
//      signed-out message reaches a real second browsing context, which drops
//      its own auth state. Same same-origin <iframe> harness as
//      web_frozen_tab_test.dart (a real second context sharing localStorage +
//      BroadcastChannel, but a child of the driver-controlled document).

import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/auth/identity_auth_service.dart';
import 'package:specpour_app/core/auth/refresh_coordinator.dart';
import 'package:specpour_app/core/routing/app_router.dart';
import 'package:web/web.dart' as web;

import 'support/cold_restart.dart';
import 'support/register_fresh_account.dart';

const _controlChannel = 'specpour.sign-out-test-control';
const _msgAgentReady = 'agent-ready';
const _msgAgentSignedOut = 'agent-signed-out';

// Held at module scope in the agent so its container + channels outlive
// _runAgent()'s return and stay alive to react to the sign-out broadcast — the
// assignment IS the keep-alive.
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

/// The second "tab": a real second browsing context. It wires the production
/// cross-tab auth sync (which registers the signed-out listener), seeds a
/// signed-in state, then reports when that state is cleared by the
/// orchestrator's sign-out broadcast.
void _runAgent() {
  final container = ProviderContainer();
  _agentContainer = container;

  final control = web.BroadcastChannel(_controlChannel);
  _agentControl = control;

  // Wire the real listener (startTokenBroadcastListener with onSignedOut).
  container.read(crossTabAuthSyncProvider);

  // Report the moment this tab's auth state is dropped to signed-out.
  container.listen<String?>(authTokenProvider, (previous, next) {
    if (next == null && previous != null) {
      control.postMessage(_msgAgentSignedOut.toJS);
    }
  });

  // Seed a signed-in state (this tab believes it's logged in).
  container.read(authTokenProvider.notifier).set('agent-access-token');
  container.read(refreshTokenProvider.notifier).set('agent-refresh-token');

  control.postMessage(_msgAgentReady.toJS);
}

void _runOrchestrator() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  testWidgets('T188: sign out, then reload, stays signed out', (tester) async {
    final ref = await coldRestart(tester);
    await registerFreshAccount(tester, ref, testTag: 'signout');
    expect(
      ref.read(authTokenProvider),
      isNotNull,
      reason: 'registration should land signed in',
    );

    // Drive the real UI: Account menu -> Sign out.
    ref.read(appRouterProvider).go('/account');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('accountMenuSignOutButton')));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(
      ref.read(authTokenProvider),
      isNull,
      reason: 'sign out clears in-memory auth state',
    );
    expect(
      find.byKey(const Key('discoverSearchField')),
      findsOneWidget,
      reason: 'sign out lands on Discover',
    );

    // Reload (cold restart): app-start restore must find no persisted token.
    final reloadedRef = await coldRestart(tester);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(
      reloadedRef.read(authTokenProvider),
      isNull,
      reason:
          'after reload the session must NOT come back — persist was cleared',
    );
  });

  testWidgets('T188: signing out one tab signs out a second open tab', (
    tester,
  ) async {
    final ref = await coldRestart(tester);
    await registerFreshAccount(tester, ref, testTag: 'signout2tab');

    final control = web.BroadcastChannel(_controlChannel);
    var agentReady = false;
    var agentSignedOut = false;
    control.onmessage = ((web.MessageEvent event) {
      final data = event.data;
      if (data == null || !data.isA<JSString>()) {
        return;
      }
      switch ((data as JSString).toDart) {
        case _msgAgentReady:
          agentReady = true;
        case _msgAgentSignedOut:
          agentSignedOut = true;
      }
    }).toJS;

    // Spawn the second context (the iframe agent).
    final iframe = web.HTMLIFrameElement();
    iframe.src = web.window.location.href;
    iframe.style.width = '0';
    iframe.style.height = '0';
    web.document.body!.appendChild(iframe);

    for (var i = 0; i < 40 && !agentReady; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    expect(agentReady, isTrue, reason: 'the second-tab agent never came up');

    // Sign out in THIS tab — broadcasts signed-out to every other tab.
    await ref.read(identityAuthServiceProvider).signOutCurrentSession();

    for (var i = 0; i < 40 && !agentSignedOut; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    expect(
      agentSignedOut,
      isTrue,
      reason:
          'the second tab must drop its auth state when another tab signs out',
    );
  });
}
