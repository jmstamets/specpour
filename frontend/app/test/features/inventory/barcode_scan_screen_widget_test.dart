import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/inventory/scan/barcode_scan_screen.dart';

import '../../support/no_raw_l10n_keys.dart';

/// T203 (coverage-ratchet fix for T070): the barcode scan screen's renderable
/// shell — title + instructions + the MobileScanner viewport. The actual
/// barcode-detection callback (`_onDetect` → pop with the scanned value)
/// requires a real device camera and is a device/browser-tier concern, not
/// widget-testable — deliberately left to the manual/on-device path, per the
/// browser-tier-is-not-coverage-bearing convention. Uses pump() (not
/// pumpAndSettle) since MobileScanner's camera controller never "settles" in a
/// headless test.
void main() {
  testWidgets('renders the scan instructions and camera viewport', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BarcodeScanScreen(),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('barcodeScanScreen')), findsOneWidget);
    expect(find.byKey(const Key('barcodeScanCamera')), findsOneWidget);
    expectNoRawLocalizationKeys(tester);
  });
}
