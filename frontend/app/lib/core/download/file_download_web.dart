// T178 (FR-003a): triggers a real browser download of a JSON artifact — the
// data-export deliverable itself, not just an on-screen courtesy view. A
// Blob + object-URL + synthetic-anchor-click is the standard client-side
// download mechanism (no server round trip needed beyond the export fetch
// itself; the JSON already sits in memory).

import 'dart:js_interop';

import 'package:web/web.dart' as web;

void downloadJsonFile({required String filename, required String jsonContent}) {
  final blob = web.Blob(
    [jsonContent.toJS].toJS,
    web.BlobPropertyBag(type: 'application/json'),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = filename
    ..style.display = 'none';
  web.document.body!.appendChild(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
}
