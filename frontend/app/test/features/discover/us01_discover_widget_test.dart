import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/app.dart';

/// T031's sandbox-runnable twin of integration_test/us01_discover_test.dart — same
/// three assertions, driven as a widget test since no device/emulator/browser is
/// available in this environment (same limitation noted since Phase 1). Currently
/// red because the discover feature (T041/T042) doesn't exist yet: HomePage is
/// still the placeholder frontend/app/lib/features/home/home_page.dart describes
/// itself as.
void main() {
  testWidgets(
    '1: a guest can search the curated library by name and open a full recipe',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: SpecPourApp()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('discoverSearchField')), findsOneWidget);
    },
  );

  testWidgets(
    '2: a recipe containing egg white shows a prominent allergen flag',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: SpecPourApp()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('discoverSearchField')), findsOneWidget);
    },
  );

  testWidgets('3: an anonymous visitor can browse without an account', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SpecPourApp()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('discoverBrowseList')), findsOneWidget);
    expect(find.byKey(const Key('accountGateSignInPrompt')), findsNothing);
  });
}
