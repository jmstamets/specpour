// T157: rendering assertion preventing the whole raw-localization-key defect
// class (constitution Principle VIII), not just the family.sour instance John's
// walkthrough caught. Twin copy lives in integration_test/support/ (the two test
// roots can't import from each other, and lib/ can't depend on flutter_test).

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Matches dotted key-shaped strings like "family.sour" or
/// "responsibleUse.message.default". The leading (?!\d) excludes bare decimals
/// ("1.5") so quantity text can never false-positive.
final RegExp keyShapedPattern = RegExp(r'^(?!\d)\w+(\.\w+)+$');

/// Asserts no visible Text widget in the current tree renders a raw
/// localization-key-shaped string.
void expectNoRawLocalizationKeys(WidgetTester tester) {
  final offenders = <String>[
    for (final text in tester.widgetList<Text>(find.byType(Text)))
      if (text.data != null && keyShapedPattern.hasMatch(text.data!.trim()))
        text.data!,
  ];

  expect(
    offenders,
    isEmpty,
    reason:
        'Raw localization-key-shaped strings must never render '
        '(Principle VIII); found: $offenders',
  );
}
