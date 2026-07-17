// T178 (FR-003a): data export must produce a downloadable JSON artifact, not
// just an on-screen rendering. This Dart test drives the browser side only
// (register, navigate, tap export, confirm the on-screen courtesy view
// rendered — proving the fetch itself succeeded); it cannot verify the
// actual downloaded file exists, because dart:io isn't available when this
// test compiles for the web target it runs against. The wrapping script
// (scripts/run-export-download-test.sh) does that half: it checks the host's
// Downloads directory for the artifact after this test completes and
// validates its contents, the same host/browser split T177 #101(c)'s
// cap-expiry test uses for the same reason.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specpour_app/core/app.dart';
import 'package:specpour_app/core/routing/app_router.dart';

import 'support/register_fresh_account.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  testWidgets('T178: exporting account data downloads a JSON artifact', (
    tester,
  ) async {
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

    await registerFreshAccount(tester, ref, testTag: 'exportdownload');

    ref.read(appRouterProvider).go('/account/data');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('accountDataExportButton')));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // On-screen courtesy view proves the underlying fetch succeeded; the
    // wrapping script separately verifies the download itself.
    expect(
      find.byKey(const Key('accountDataExportDateOfBirth')),
      findsOneWidget,
      reason: 'the on-screen courtesy view should still render',
    );
  });
}
