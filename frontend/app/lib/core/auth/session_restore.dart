// ADR-0005 (T177): the app-start silent-restore flow. Runs once per app
// lifetime (a FutureProvider only re-executes if invalidated), gating the
// first frame the router-based app renders — see app.dart. Reads the
// persisted refresh token (if any) and attempts a silent refresh_token grant
// against the SAME authorization the token belongs to (never a fresh
// authorization_code grant — that's what would spawn a duplicate
// SessionDevice row and defeat the whole point of persisting in the first
// place). Success restores the session with a stable session id; failure
// (expired, consumed, revoked, past the 90-day absolute cap, or a detected
// reuse — all indistinguishable plain refresh_token-grant failures to the
// client) lands cleanly signed out, never a surfaced error.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client_provider.dart';
import 'token_store.dart';

/// A platform storage read genuinely never taking this long in practice — this
/// bounds the worst case rather than describing an expected duration. Restore
/// must never block app launch indefinitely (e.g. a headless/misconfigured
/// environment with no secret-service backend for flutter_secure_storage to
/// talk to, which hangs on the platform channel rather than failing fast —
/// confirmed by direct reproduction: this exact hang broke every existing
/// widget test that pumps SpecPourApp until this timeout was added).
const _storageReadTimeout = Duration(seconds: 3);

final sessionRestoreProvider = FutureProvider<void>((ref) async {
  // Wire the persistence listener before this provider's own silentlyRefreshTokens
  // call might change refreshTokenProvider — see refreshTokenPersistenceProvider's
  // own doc comment for why ordering matters here.
  ref.watch(refreshTokenPersistenceProvider);

  final tokenStore = ref.read(tokenStoreProvider);
  final String? persisted;
  try {
    persisted = await tokenStore.readRefreshToken().timeout(
      _storageReadTimeout,
    );
  } on Object {
    // A storage-layer failure or timeout must never block app start — treat
    // it the same as "nothing was persisted."
    return;
  }

  if (persisted == null) {
    return;
  }

  await silentlyRefreshTokens(ref, refreshToken: persisted);
});
