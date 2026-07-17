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

/// Frozen-tab hardening (T177, John's PR #2 merge review): picks which
/// refresh token [coordinatedRefresh] should actually use — the live-read
/// value from persisted storage when it's available and differs from what
/// this context started with (it's more current, e.g. because this context
/// was suspended and missed a peer's rotation), otherwise the starting
/// token unchanged. A pure function (no platform I/O) deliberately extracted
/// out of [coordinatedRefresh] so this selection decision is unit-testable
/// directly — [liveReadPersistedRefreshToken]'s real (web-only)
/// implementation can't run under a plain VM test target.
String selectEffectiveRefreshToken({
  required String startingRefreshToken,
  required String? liveToken,
}) {
  if (liveToken != null && liveToken != startingRefreshToken) {
    return liveToken;
  }
  return startingRefreshToken;
}

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
      // Hygiene rider: clear the handoff once we're provably the last reader
      // this contention burst will have (nobody else still queued) — see
      // maybeClearHandoffAfterDrain's own doc comment for why this is safe
      // even with 3+ tabs racing.
      await maybeClearHandoffAfterDrain();
      return true;
    }

    // Frozen-tab hardening (John's PR #2 merge review): the lookup above
    // missed — either genuinely nothing was ever handed off, OR this context
    // was suspended in the background (missed the BroadcastChannel wake) and
    // by the time it resumed and acquired the lock, the contention burst that
    // rotated the session had already fully drained (handoff cleared by
    // design). In the second case, startingRefreshToken is now STALE —
    // already redeemed by another tab, long outside the reuse leeway — and
    // presenting it would trip reuse detection and revoke the whole session.
    // Live-read what's ACTUALLY persisted right now (never through
    // shared_preferences — see WebLocalTokenStore's maintainer note) and, if
    // it differs, retry the handoff lookup with it first (a handoff for the
    // live token can still exist if we're not the only one who missed it),
    // then use it as the effective token for the real refresh attempt below.
    //
    // Deliberately ordered AFTER the primary lookup above, not before it
    // (unlike a naive always-live-read-first draft): refreshTokenPersistenceProvider
    // persists reactively via `unawaited(...)` (api_client_provider.dart) —
    // a winner's own critical section can complete before that persist
    // lands, so an unconditional live-read at the very top could
    // occasionally observe a peer's IN-FLIGHT rotation and mis-key the FIRST
    // handoff lookup with an already-rotated token that doesn't match the
    // handoff's 'from', turning a genuine adopt into a spurious extra
    // refresh — undermining the multitab mechanism test's "exactly one
    // attempt" invariant on pure timing. Consulting the live value only as a
    // fallback, after the primary token-matched lookup has already had its
    // chance, makes this new code path provably unreachable in that
    // mechanism test's own scenario (the primary lookup there always
    // resolves the race correctly on its own) — additive, not a change to
    // the election/handoff/broadcast mechanics themselves.
    final liveToken = liveReadPersistedRefreshToken();
    final effectiveStartingToken = selectEffectiveRefreshToken(
      startingRefreshToken: startingRefreshToken,
      liveToken: liveToken,
    );
    if (effectiveStartingToken != startingRefreshToken) {
      final adoptedViaLiveToken = readHandoffFor(effectiveStartingToken);
      if (adoptedViaLiveToken != null) {
        ref
            .read(authTokenProvider.notifier)
            .set(adoptedViaLiveToken.accessToken);
        ref
            .read(refreshTokenProvider.notifier)
            .set(adoptedViaLiveToken.refreshToken);
        await maybeClearHandoffAfterDrain();
        return true;
      }
    }

    // We are the elected refresher (or native single-context).
    final refreshed = await silentlyRefreshTokens(
      ref,
      refreshToken: effectiveStartingToken,
    );
    if (refreshed) {
      final access = ref.read(authTokenProvider)!;
      final refresh = ref.read(refreshTokenProvider)!;
      // Record the result for any tab queued behind us to adopt (synchronous,
      // before we release the lock)...
      writeHandoff(effectiveStartingToken, access, refresh);
      // ...and proactively wake passive tabs (best-effort optimisation).
      broadcastTokens(access, refresh);
      // Same drain check: if nobody was ever queued behind us (a lone refresh,
      // not a race), this clears immediately rather than waiting for the TTL.
      await maybeClearHandoffAfterDrain();
    }
    return refreshed;
  });
}

/// Keeps THIS tab's in-memory auth state in sync with whichever tab last
/// refreshed — watched once at app start (see app.dart). On native
/// [startTokenBroadcastListener] is a no-op, so this harmlessly does nothing.
/// Also sweeps any orphaned handoff left over from a tab that closed before
/// its own drain-triggered cleanup could run (hygiene rider) — a no-op on
/// native, and a no-op on web if nothing is orphaned.
final crossTabAuthSyncProvider = Provider<void>((ref) {
  startTokenBroadcastListener((accessToken, refreshToken) {
    ref.read(authTokenProvider.notifier).set(accessToken);
    ref.read(refreshTokenProvider.notifier).set(refreshToken);
  });
  sweepOrphanedHandoff();
});
