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

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client_provider.dart';
import 'cross_tab_channel_stub.dart'
    if (dart.library.js_interop) 'cross_tab_channel_web.dart';
import 'token_store.dart';

/// How long an adopting tab waits for the winner's broadcast to land before
/// falling back to its own refresh. Generous relative to a same-origin
/// BroadcastChannel hop (sub-millisecond) — this only ever elapses in the
/// pathological "broadcast never arrives" case the fallback exists for.
const _adoptBroadcastTimeout = Duration(seconds: 2);

/// Performs a refresh under the cross-tab election. Returns true if the session
/// is now fresh (whether this tab did the refresh or adopted another tab's),
/// false if the session is over (the same clean-signed-out outcome
/// silentlyRefreshTokens produces — callers must never surface it as an error).
Future<bool> coordinatedRefresh(
  Ref ref, {
  required String startingRefreshToken,
}) {
  return withRefreshLock(() async {
    final tokenStore = ref.read(tokenStoreProvider);
    // Re-read storage UNDER THE LOCK: another tab may have rotated the token
    // while we were queued, so the token we arrived with may already be
    // redeemed. Storage holds the freshest known refresh token.
    final stored = await tokenStore.readRefreshToken();

    if (kIsWeb && stored != null && stored != startingRefreshToken) {
      // Another tab already refreshed (storage holds a token we didn't start
      // with). Refreshing again would be the SECOND wire request the whole
      // election exists to prevent — adopt the winner's result instead.
      return _adopt(ref, freshRefreshToken: stored);
    }

    // We are the elected refresher (or native single-context). Use the freshest
    // token available; on success, hand the fresh pair to the other tabs (the
    // access token is never persisted, so it must travel in the broadcast).
    final refreshed = await silentlyRefreshTokens(
      ref,
      refreshToken: stored ?? startingRefreshToken,
    );
    if (refreshed) {
      broadcastTokens(
        ref.read(authTokenProvider)!,
        ref.read(refreshTokenProvider)!,
      );
    }
    return refreshed;
  });
}

/// Adopt a peer tab's just-completed refresh instead of doing our own. The
/// winner broadcasts the fresh {access, refresh} pair; the persistent listener
/// ([crossTabAuthSyncProvider]) applies it to our providers. If it has already
/// landed we're done; otherwise wait briefly for it.
Future<bool> _adopt(Ref ref, {required String freshRefreshToken}) async {
  if (_broadcastApplied(ref, freshRefreshToken)) {
    return true;
  }
  final arrived = await waitForNextTokenBroadcast(_adoptBroadcastTimeout);
  if (arrived && _broadcastApplied(ref, freshRefreshToken)) {
    return true;
  }
  // Fallback (rare, documented): the broadcast never arrived (channel closed,
  // pathological timing). The token now in storage is FRESH and unredeemed, so
  // refreshing with it is safe — no reuse, no revocation — it just costs one
  // extra wire request in this edge case only, which beats leaving a live
  // session stuck without an access token.
  return silentlyRefreshTokens(ref, refreshToken: freshRefreshToken);
}

/// The winner's broadcast is applied once the persistent listener has set our
/// refresh token to the fresh value (before that, this tab still holds its old,
/// pre-refresh token — so a match is a reliable "the broadcast landed" signal)
/// AND we hold an access token to retry with.
bool _broadcastApplied(Ref ref, String freshRefreshToken) =>
    ref.read(refreshTokenProvider) == freshRefreshToken &&
    ref.read(authTokenProvider) != null;

/// Keeps THIS tab's in-memory auth state in sync with whichever tab last
/// refreshed — watched once at app start (see app.dart). On native
/// [startTokenBroadcastListener] is a no-op, so this harmlessly does nothing.
final crossTabAuthSyncProvider = Provider<void>((ref) {
  startTokenBroadcastListener((accessToken, refreshToken) {
    ref.read(authTokenProvider.notifier).set(accessToken);
    ref.read(refreshTokenProvider.notifier).set(refreshToken);
  });
});
