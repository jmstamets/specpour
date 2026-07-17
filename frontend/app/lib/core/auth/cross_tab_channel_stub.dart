// ADR-0005 (T177) cross-tab coordination — non-web stub.
//
// A native app is a single process with a single auth context: there is no
// second tab to race for a refresh, nothing to broadcast to, and nothing to
// hear. So the "lock" is uncontended (just run the body), broadcasting is a
// no-op, and there is never a broadcast to wait for. This file exists only so
// the conditional import in refresh_coordinator.dart compiles off-web; the
// coordinator's election logic degenerates cleanly to a plain refresh on
// native because of these no-ops.

/// Runs [body] immediately — native is single-context, so the exclusive
/// refresh lock is always uncontended.
Future<T> withRefreshLock<T>(Future<T> Function() body) => body();

/// No other contexts to notify on native.
void broadcastTokens(String accessToken, String refreshToken) {}

/// No other contexts to hear from on native.
void startTokenBroadcastListener(
  void Function(String accessToken, String refreshToken) onTokens,
) {}

/// Native never adopts another tab's refresh, so there is nothing to wait for.
Future<bool> waitForNextTokenBroadcast(Duration timeout) async => false;
