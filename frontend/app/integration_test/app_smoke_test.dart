import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:specpour_app/core/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app launches to the home shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SpecPourApp()));
    await tester.pumpAndSettle();

    expect(find.text('SpecPour'), findsWidgets);
  });
}
