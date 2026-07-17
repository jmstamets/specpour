// ADR-0005 (T177) cross-tab coordination — web implementation.
//
// One-time-use rotating refresh tokens + a web app open in several tabs is a
// classic self-inflicted wound: two tabs whose access tokens expire around the
// same time both try to refresh, the loser presents an already-redeemed token,
// and OpenIddict's reuse detection — correctly — revokes the whole session. The
// 30-second RefreshTokenReuseLeeway is a SAFETY NET that absorbs most
// near-simultaneous races; it is NOT the design. The design is a single-refresher
// election so that, whatever the timing, exactly one tab ever redeems a given
// refresh token.
//
// Three web primitives, all same-origin-shared across every tab of the app:
//   - Web Locks (navigator.locks): the election. Exactly one tab holds the
//     named exclusive lock at a time; the rest queue. The holder does the
//     refresh; a queued tab, on finally acquiring the lock, adopts the holder's
//     result rather than refreshing again.
//   - A synchronous localStorage HANDOFF: how a queued tab learns the holder's
//     rotated {access, refresh} pair. This is written directly to
//     window.localStorage (NOT via shared_preferences), synchronously, before
//     the holder releases the lock — so a queued tab, acquiring the lock next,
//     reads it back synchronously and live. This was the fix for a real bug the
//     mechanism test caught (T177 #100, 2026-07-17): shared_preferences writes
//     are async/fire-and-forget AND cached per-instance, so a DIFFERENT tab's
//     read never saw the winner's rotation → both tabs refreshed → reuse
//     detection risk. localStorage is synchronous and cross-context-live, which
//     makes the adopt deterministic. The handoff is keyed by the token being
//     REPLACED ('from') so a stale handoff from an unrelated cycle is ignored.
//   - BroadcastChannel: a best-effort OPTIMISATION that proactively refreshes
//     PASSIVE tabs' in-memory state (so their next request doesn't even need a
//     401→refresh). Correctness no longer depends on it — a passive tab that
//     misses a broadcast still adopts correctly via the handoff on its next
//     refresh.

import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// A well-known, app-specific name so only SpecPour's own tabs contend on it.
const _lockName = 'specpour.refresh';
const _channelName = 'specpour.auth';
const _handoffKey = 'specpour.auth-handoff';

/// Orphan-cleanup rider (2026-07-17): if a handoff is older than this, no real
/// contention burst could still be relying on it — a same-origin localStorage
/// write/read/lock round trip is milliseconds, not seconds. Generous, not
/// tuned to the happy path.
const _handoffOrphanTtl = Duration(seconds: 30);

web.BroadcastChannel? _channel;
void Function(String accessToken, String refreshToken)? _onTokens;

web.BroadcastChannel _channelInstance() {
  final existing = _channel;
  if (existing != null) {
    return existing;
  }
  final channel = web.BroadcastChannel(_channelName);
  channel.onmessage = ((web.MessageEvent event) {
    final raw = event.data;
    if (raw == null || !raw.isA<JSString>()) {
      return;
    }
    // Payload is a plain JSON string — deliberately avoids js_interop object
    // property plumbing, and a string is trivially structured-cloneable.
    final Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode((raw as JSString).toDart) as Map<String, dynamic>;
    } on Object {
      return;
    }
    final access = decoded['access'];
    final refresh = decoded['refresh'];
    if (access is! String || refresh is! String) {
      return;
    }
    _onTokens?.call(access, refresh);
  }).toJS;
  _channel = channel;
  return channel;
}

/// Runs [body] while holding the app-wide exclusive refresh lock. If another
/// tab holds it, this queues and runs only once that tab has finished and
/// released (Web Locks releases automatically if the holder's tab closes
/// mid-refresh, so a queued tab is never stranded).
Future<T> withRefreshLock<T>(Future<T> Function() body) {
  final completer = Completer<T>();
  final granted = ((web.Lock? lock) {
    // The lock is held for exactly as long as the promise we return here is
    // pending, so returning body()'s future keeps it held for the whole refresh.
    return body()
        .then<JSAny?>((value) {
          if (!completer.isCompleted) {
            completer.complete(value);
          }
          return null;
        })
        .catchError((Object error, StackTrace stack) {
          if (!completer.isCompleted) {
            completer.completeError(error, stack);
          }
          return null;
        })
        .toJS;
  }).toJS;

  web.window.navigator.locks.request(_lockName, granted).toDart.catchError((
    Object error,
    StackTrace stack,
  ) {
    // A rejected request (e.g. the lock was aborted) must surface, not hang.
    if (!completer.isCompleted) {
      completer.completeError(error, stack);
    }
    return null;
  });

  return completer.future;
}

/// Sends the freshly-rotated pair to every other SpecPour tab.
void broadcastTokens(String accessToken, String refreshToken) {
  final payload = jsonEncode({'access': accessToken, 'refresh': refreshToken});
  _channelInstance().postMessage(payload.toJS);
}

/// Wires the persistent listener that keeps THIS tab's in-memory auth state in
/// sync with whichever tab last refreshed. Call once on web app start.
void startTokenBroadcastListener(
  void Function(String accessToken, String refreshToken) onTokens,
) {
  _onTokens = onTokens;
  _channelInstance();
}

/// Synchronously records the just-rotated pair for a queued tab to adopt,
/// keyed by the refresh token it REPLACED. Written to window.localStorage
/// directly (not shared_preferences) so it is synchronous and cross-context
/// live, and called before the lock is released so the next tab to acquire the
/// lock reads it back deterministically.
void writeHandoff(
  String fromRefreshToken,
  String accessToken,
  String newRefreshToken,
) {
  web.window.localStorage.setItem(
    _handoffKey,
    jsonEncode({
      'from': fromRefreshToken,
      'access': accessToken,
      'refresh': newRefreshToken,
      'ts': DateTime.now().millisecondsSinceEpoch,
    }),
  );
}

/// Returns the pair a peer produced by refreshing [fromRefreshToken], or null if
/// no such handoff exists. The 'from' match is what makes this stale-safe: a
/// leftover handoff from an unrelated refresh cycle has a different 'from' and
/// is ignored, so only a peer that refreshed exactly the token we were about to
/// use is adopted.
///
/// Deliberately does NOT delete the entry itself (hygiene rider, 2026-07-17):
/// with 3+ tabs racing, more than one queued tab can legitimately need to read
/// the SAME handoff in turn as each acquires the lock — the first adopter
/// deleting it would strand a third tab with nothing to adopt, forcing it to
/// retry the already-redeemed original token and trip real reuse detection.
/// Cleanup is handled separately by [maybeClearHandoffAfterDrain], called once
/// the lock's queue is observed empty — see that function's doc comment.
({String accessToken, String refreshToken})? readHandoffFor(
  String fromRefreshToken,
) {
  final raw = web.window.localStorage.getItem(_handoffKey);
  if (raw == null) {
    return null;
  }
  try {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    if (decoded['from'] != fromRefreshToken) {
      return null;
    }
    final access = decoded['access'];
    final refresh = decoded['refresh'];
    if (access is String && refresh is String) {
      return (accessToken: access, refreshToken: refresh);
    }
  } on Object {
    return null;
  }
  return null;
}

/// Hygiene rider (2026-07-17): called by whoever currently holds the refresh
/// lock, right before releasing it, having just written or adopted a handoff.
/// Clears the handoff ONLY if no other context is still queued on the lock —
/// `navigator.locks.query()`'s `pending` list, read WHILE we still hold the
/// lock, is exactly "who is waiting for me to release," so an empty list here
/// means we are provably the last reader this contention burst will have. This
/// is what makes "no handoff entries remain after the race completes" true
/// immediately, without weakening the multi-tab correctness the un-conditional
/// read in [readHandoffFor] depends on.
Future<void> maybeClearHandoffAfterDrain() async {
  final snapshot = await web.window.navigator.locks.query().toDart;
  final stillPending = snapshot.pending.toDart.any(
    (info) => info.name == _lockName,
  );
  if (!stillPending) {
    web.window.localStorage.removeItem(_handoffKey);
  }
}

/// Orphan-cleanup rider (2026-07-17), the backstop for [maybeClearHandoffAfterDrain]:
/// a handoff can only ever be left behind if its writer's tab crashed/closed
/// before its own drain check ran, or query() itself errored — call once at app
/// start. Age is judged from the handoff's own 'ts', not wall-clock arithmetic
/// on anything else, so this is safe to call even with nothing to clean up.
void sweepOrphanedHandoff() {
  final raw = web.window.localStorage.getItem(_handoffKey);
  if (raw == null) {
    return;
  }
  try {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final ts = decoded['ts'];
    if (ts is int) {
      final age = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(ts),
      );
      if (age <= _handoffOrphanTtl) {
        return;
      }
    }
  } on Object {
    // Unparseable entry is itself orphaned/corrupt — fall through and clear it.
  }
  web.window.localStorage.removeItem(_handoffKey);
}
