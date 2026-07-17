import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/widgets/api_error_display.dart';

/// T172 (Phase 4 walkthrough finding #4): error text rendered by a plain Text
/// widget is uncopyable on Flutter web. Verifies the two mechanisms this
/// component adds: SelectionArea (drag-to-select) and an explicit copy
/// button — the latter tested directly since drag-selection isn't easily
/// simulated in a widget test, and it's the more reliable/discoverable path
/// anyway.
void main() {
  // Clipboard.getData never resolves when awaited directly in a testWidgets
  // body (a real async platform-channel round trip inside the fake-async test
  // zone hangs indefinitely, confirmed by direct reproduction — a genuine
  // Flutter test-framework gotcha, not specific to this widget). The
  // established fix: mock SystemChannels.platform directly so
  // setData/getData resolve synchronously within the test zone.
  String? clipboardText;
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, (methodCall) async {
        if (methodCall.method == 'Clipboard.setData') {
          clipboardText = (methodCall.arguments as Map)['text'] as String?;
          return null;
        }
        if (methodCall.method == 'Clipboard.getData') {
          return {'text': clipboardText};
        }
        return null;
      });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders the message text with the given key', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ApiErrorDisplay(
          message: 'Something went wrong on our end. (Reference: corr-123)',
          messageKey: Key('testErrorMessage'),
        ),
      ),
    );

    expect(find.byKey(const Key('testErrorMessage')), findsOneWidget);
    expect(
      find.text('Something went wrong on our end. (Reference: corr-123)'),
      findsOneWidget,
    );
  });

  testWidgets('is wrapped in a SelectionArea', (tester) async {
    await tester.pumpWidget(
      wrap(const ApiErrorDisplay(message: 'Some failure.')),
    );

    expect(find.byType(SelectionArea), findsOneWidget);
  });

  testWidgets('the copy button copies the full message to the clipboard', (
    tester,
  ) async {
    const message = 'Something went wrong. (Reference: corr-abc-999)';
    await tester.pumpWidget(wrap(const ApiErrorDisplay(message: message)));

    await tester.tap(find.byKey(const Key('apiErrorCopyButton')));
    await tester.pump();

    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    expect(clipboardData?.text, message);
  });
}
