import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/features/identity/user_agent_humanizer.dart';

/// T189: the best-effort "Browser on OS" heuristic for the sessions list.
void main() {
  // Real-world UA strings (trimmed) for the browser/OS combos SpecPour's web
  // client actually runs on.
  const cases = <String, String>{
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0':
        'Edge on Windows',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36':
        'Chrome on Windows',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15':
        'Safari on macOS',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:121.0) Gecko/20100101 Firefox/121.0':
        'Firefox on macOS',
    'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36':
        'Chrome on Android',
    'Mozilla/5.0 (iPhone; CPU iPhone OS 17_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Mobile/15E148 Safari/604.1':
        'Safari on iOS',
  };

  cases.forEach((ua, expected) {
    test('humanizes "$expected"', () {
      expect(humanizeUserAgent(ua), expected);
    });
  });

  test('Android is not mistaken for Linux', () {
    expect(
      humanizeUserAgent(
        'Mozilla/5.0 (Linux; Android 14) Chrome/120.0.0.0 Mobile Safari/537.36',
      ),
      'Chrome on Android',
    );
  });

  test('returns null for an unrecognizable string so the raw UA is shown', () {
    expect(humanizeUserAgent('some-custom-native-client/1.0'), isNull);
  });
}
