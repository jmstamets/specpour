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
// Two web primitives, both same-origin-shared across every tab of the app:
//   - Web Locks (navigator.locks): the election. Exactly one tab holds the
//     named exclusive lock at a time; the rest queue. The holder does the
//     refresh; a queued tab, on finally acquiring the lock, sees the rotated
//     token already in storage and ADOPTS rather than refreshing again.
//   - BroadcastChannel: distributes the fresh {access, refresh} pair to the
//     other tabs (the access token is never persisted, so it must travel in the
//     message), waking passive tabs and handing the just-rotated pair to the
//     active loser waiting to retry its request.

import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// A well-known, app-specific name so only SpecPour's own tabs contend on it.
const _lockName = 'specpour.refresh';
const _channelName = 'specpour.auth';

web.BroadcastChannel? _channel;
void Function(String accessToken, String refreshToken)? _onTokens;

/// One-shot waiters for "the next token broadcast arrived" — completed by the
/// channel's message handler. Used by the adopt path (see refresh_coordinator).
final List<Completer<void>> _broadcastWaiters = <Completer<void>>[];

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
    // Release any adopt-path waiters — the fresh pair is now in hand.
    for (final waiter in _broadcastWaiters) {
      if (!waiter.isCompleted) {
        waiter.complete();
      }
    }
    _broadcastWaiters.clear();
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

/// Completes true when the next token broadcast arrives within [timeout], false
/// on timeout. The adopt path uses this to wait for the winner's fresh pair
/// before giving up and falling back to its own refresh.
Future<bool> waitForNextTokenBroadcast(Duration timeout) {
  final completer = Completer<void>();
  _broadcastWaiters.add(completer);
  return completer.future
      .then((_) => true)
      .timeout(
        timeout,
        onTimeout: () {
          _broadcastWaiters.remove(completer);
          return false;
        },
      );
}
