// T189: best-effort "Browser on OS" from a raw User-Agent string, for the
// sessions list. Deliberately a small heuristic, not a full UA-parsing library:
// the raw string stays available on expand (see sessions_screen.dart), so a
// miss degrades to "the raw UA is one tap away", never to wrong-and-hidden.
// Pure + dependency-free so it's unit-testable off-device.

/// Returns a friendly "{Browser} on {OS}" label, or the best partial ("Chrome",
/// "Windows"), or null when nothing recognizable is present (the caller then
/// shows the raw string).
String? humanizeUserAgent(String userAgent) {
  final browser = _browser(userAgent);
  final os = _os(userAgent);

  if (browser != null && os != null) {
    return '$browser on $os';
  }
  return browser ?? os;
}

String? _browser(String ua) {
  // Order matters: Edge and Opera UAs also contain "Chrome"; Chrome's contains
  // "Safari" — so match the most specific brands first.
  if (ua.contains('Edg/') || ua.contains('Edge/')) {
    return 'Edge';
  }
  if (ua.contains('OPR/') || ua.contains('Opera')) {
    return 'Opera';
  }
  if (ua.contains('Firefox/')) {
    return 'Firefox';
  }
  if (ua.contains('Chrome/')) {
    return 'Chrome';
  }
  if (ua.contains('Safari/') && ua.contains('Version/')) {
    return 'Safari';
  }
  return null;
}

String? _os(String ua) {
  // Android must precede Linux (Android UAs contain "Linux"); iOS devices
  // precede the generic Mac check only in that they're distinct strings.
  if (ua.contains('Android')) {
    return 'Android';
  }
  if (ua.contains('iPhone') || ua.contains('iPad') || ua.contains('iPod')) {
    return 'iOS';
  }
  if (ua.contains('Windows NT')) {
    return 'Windows';
  }
  if (ua.contains('Mac OS X') || ua.contains('Macintosh')) {
    return 'macOS';
  }
  if (ua.contains('CrOS')) {
    return 'ChromeOS';
  }
  if (ua.contains('Linux')) {
    return 'Linux';
  }
  return null;
}
