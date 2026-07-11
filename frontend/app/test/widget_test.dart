import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:specpour_app/core/app.dart';

void main() {
  testWidgets('SpecPourApp renders the home shell with a localized title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SpecPourApp()));
    await tester.pumpAndSettle();

    expect(find.text('SpecPour'), findsWidgets);
  });
}
