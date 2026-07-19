// T070/T069: on-device barcode scan path (the piece T069's own task text
// explicitly split into this task). No backend barcode/UPC database lookup
// exists (never requested) — this screen's only job is capturing a scanned
// value and popping it back to the caller, which then degrades to manual
// bottle confirmation exactly like an unrecognized photo.

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/l10n/gen/app_localizations.dart';

class BarcodeScanScreen extends StatefulWidget {
  const BarcodeScanScreen({super.key});

  @override
  State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  bool _handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled) {
      return;
    }
    final value = capture.barcodes.firstOrNull?.rawValue;
    if (value == null) {
      return;
    }
    _handled = true;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      key: const Key('barcodeScanScreen'),
      appBar: AppBar(title: Text(l10n.barcodeScanTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.barcodeScanInstructions),
          ),
          Expanded(
            child: MobileScanner(
              key: const Key('barcodeScanCamera'),
              onDetect: _onDetect,
            ),
          ),
        ],
      ),
    );
  }
}
