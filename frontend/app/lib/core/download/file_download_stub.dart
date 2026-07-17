// Non-web stub for file_download_web.dart. T178 (FR-003a) scopes the
// downloadable-artifact deliverable to web for V1 — a native file-save
// dialog / share sheet is future work, not silently unsupported, so this
// throws loudly rather than doing nothing if ever reached on native.

void downloadJsonFile({required String filename, required String jsonContent}) {
  throw UnsupportedError(
    'downloadJsonFile is web-only in V1; native export-download is future work.',
  );
}
