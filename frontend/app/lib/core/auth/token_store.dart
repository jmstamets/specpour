// ADR-0005 (T177): persists the refresh token across app restarts/reloads —
// platform-appropriate storage, chosen at runtime rather than via a
// web_authorize.dart-style conditional import, since both backing packages
// compile cleanly on every target (neither references browser-only APIs the
// way package:web does).
//
// Native (iOS/Android): flutter_secure_storage (Keychain/Keystore-backed).
// Web: shared_preferences (browser localStorage) — deliberately NOT this
// package's own web fallback, which is an unencrypted localStorage shim under
// a name that would misrepresent its actual security properties. Using
// shared_preferences directly is equally honest about what it is.
//
// The XSS exposure this carries on web is a known, accepted tradeoff — see
// ADR-0005's "Consequences": accepted ONLY alongside a strict CSP (T139
// launch-gate rider) as the compensating control, with one-time-use refresh
// rotation (already on by default in OpenIddict) capping a stolen token's
// value to a single use before the legitimate client's own next refresh trips
// reuse detection.

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Public (not private) so cross_tab_channel_web.dart's live-read (T177
/// frozen-tab hardening) can key off the SAME single source of truth instead
/// of a second, silently-driftable copy of this string.
const refreshTokenKey = 'specpour.refreshToken';

abstract class TokenStore {
  Future<String?> readRefreshToken();
  Future<void> writeRefreshToken(String token);
  Future<void> clearRefreshToken();
}

class NativeSecureTokenStore implements TokenStore {
  const NativeSecureTokenStore();

  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> readRefreshToken() => _storage.read(key: refreshTokenKey);

  @override
  Future<void> writeRefreshToken(String token) =>
      _storage.write(key: refreshTokenKey, value: token);

  @override
  Future<void> clearRefreshToken() => _storage.delete(key: refreshTokenKey);
}

/// MAINTAINER NOTE (T177 frozen-tab hardening): [readRefreshToken] here goes
/// through `package:shared_preferences`, whose web backend caches values
/// per-plugin-instance — a DIFFERENT tab/browsing context's read can be
/// stale, missing another context's more recent write (confirmed empirically
/// during T177 #100: the original cross-tab handoff design broke exactly
/// this way). This class is fine for THIS context reading its OWN
/// most-recent write; it is NOT a source of truth for what another context
/// last wrote. Cross-tab correctness does not depend on this class at all —
/// it lives entirely in refresh_coordinator.dart's Web Locks election plus
/// cross_tab_channel_web.dart's synchronous, direct `window.localStorage`
/// handoff/live-read, which deliberately bypass this cache for exactly that
/// reason. Do not "fix" a cross-tab bug by reaching for this class.
class WebLocalTokenStore implements TokenStore {
  const WebLocalTokenStore();

  @override
  Future<String?> readRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(refreshTokenKey);
  }

  @override
  Future<void> writeRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(refreshTokenKey, token);
  }

  @override
  Future<void> clearRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(refreshTokenKey);
  }
}

final tokenStoreProvider = Provider<TokenStore>(
  (ref) => kIsWeb ? const WebLocalTokenStore() : const NativeSecureTokenStore(),
);
