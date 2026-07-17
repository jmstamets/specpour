// T177 #101 harness guard: simulates a genuine app cold-restart within a
// single flutter_drive test, reading whatever persisted storage (localStorage
// on web) is already on disk — the technique reload/relaunch/next-launch
// scenarios need.
//
// TRAP THIS GUARDS AGAINST (found 2026-07-17, via reproduction): a naive
// second call to `pumpWidget(ProviderScope(child: ...SpecPourApp...))` within
// ONE testWidgets case does NOT simulate a restart. Flutter's element diffing
// sees the same root widget TYPE on the second call and treats it as an
// UPDATE, not a remount — so ProviderScope's State (and the ProviderContainer
// it holds, including in-memory providers like authTokenProvider) survives
// UNTOUCHED. A test built on that assumption silently reuses the FIRST boot's
// state for every "restart," passing for the wrong reason (confirmed
// symptoms: a timestamp that should have moved stayed byte-identical across
// a "reload"; a revoked session's access token was still readable after a
// "relaunch" — no second network round trip ever actually happened).
//
// This is a DIFFERENT mechanism from the browser tier's other localStorage-
// persistence finding (T099: a later testWidgets CASE's fresh pumpWidget
// inherited an EARLIER CASE's session, because separate test() cases DO get a
// real teardown between them) — that finding does not extend to multiple
// pumpWidget calls inside ONE case, and this helper is what closes that gap:
// pump an unrelated widget type first, forcing Flutter to unmount the old
// element tree for real, before mounting the fresh instance.
//
// Use this any time a scenario needs "boot the app again, reading the same
// persisted state" (reload, relaunch-after-revoke, relaunch-after-cap-expiry,
// etc.) — never call pumpWidget(ProviderScope(...)) a second time directly.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/app.dart';

/// Boots (or cold-restarts) the app as a genuinely fresh instance, returning
/// a [WidgetRef] bound to the new instance's own [ProviderContainer].
Future<WidgetRef> coldRestart(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();

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
  return ref;
}
