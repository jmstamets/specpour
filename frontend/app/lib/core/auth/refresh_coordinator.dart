// ADR-0005 (T177) cross-tab coordination — the platform-neutral election logic.
//
// This is the single entry point both refresh callers use instead of calling
// silentlyRefreshTokens directly: TokenRefreshInterceptor (mid-session 401
// recovery) and sessionRestoreProvider (app-start restore). It wraps the actual
// refresh in a cross-tab single-refresher election so that, across any number of
// open web tabs, exactly ONE tab ever redeems a given rotating refresh token —
// the others adopt that tab's result rather than presenting an already-redeemed
// token and tripping OpenIddict's reuse detection (which would revoke the whole
// session for a benign race). On native, the election degenerates to a plain
// refresh because the channel primitives are no-ops (single context, nothing to
// race).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client_provider.dart';
import 'cross_tab_channel_stub.dart'
    if (dart.library.js_interop) 'cross_tab_channel_web.dart';

/// Performs a refresh under the cross-tab election. Returns true if the session
/// is now fresh (whether this tab did the refresh or adopted another tab's),
/// false if the session is over (the same clean-signed-out outcome
/// silentlyRefreshTokens produces — callers must never surface it as an error).
Future<bool> coordinatedRefresh(
  Ref ref, {
  required String startingRefreshToken,
}) {
  return withRefreshLock(() async {
    // Did a peer already refresh THIS token while we were queued? The handoff is
    // written to window.localStorage synchronously before a holder releases the
    // lock, so — having just acquired the lock — we read it back synchronously
    // and live (unlike shared_preferences, whose async/per-instance cache never
    // let a different tab see the winner's rotation; T177 #100). Keyed by 'from'
    // == our starting token, so a stale handoff from an unrelated cycle is
    // ignored.
    final adopted = readHandoffFor(startingRefreshToken);
    if (adopted != null) {
      ref.read(authTokenProvider.notifier).set(adopted.accessToken);
      ref.read(refreshTokenProvider.notifier).set(adopted.refreshToken);
      return true;
    }

    // We are the elected refresher (or native single-context).
    final refreshed = await silentlyRefreshTokens(
      ref,
      refreshToken: startingRefreshToken,
    );
    if (refreshed) {
      final access = ref.read(authTokenProvider)!;
      final refresh = ref.read(refreshTokenProvider)!;
      // Record the result for any tab queued behind us to adopt (synchronous,
      // before we release the lock)...
      writeHandoff(startingRefreshToken, access, refresh);
      // ...and proactively wake passive tabs (best-effort optimisation).
      broadcastTokens(access, refresh);
    }
    return refreshed;
  });
}

/// Keeps THIS tab's in-memory auth state in sync with whichever tab last
/// refreshed — watched once at app start (see app.dart). On native
/// [startTokenBroadcastListener] is a no-op, so this harmlessly does nothing.
final crossTabAuthSyncProvider = Provider<void>((ref) {
  startTokenBroadcastListener((accessToken, refreshToken) {
    ref.read(authTokenProvider.notifier).set(accessToken);
    ref.read(refreshTokenProvider.notifier).set(refreshToken);
  });
});
