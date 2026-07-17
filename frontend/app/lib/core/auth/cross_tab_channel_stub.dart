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

/// Nothing to hand off — native is single-context.
void writeHandoff(
  String fromRefreshToken,
  String accessToken,
  String newRefreshToken,
) {}

/// Native never adopts a peer's refresh (there is no peer), so there is never a
/// handoff to read — always refresh directly.
({String accessToken, String refreshToken})? readHandoffFor(
  String fromRefreshToken,
) => null;

/// Nothing to clear on native — no handoff was ever written.
Future<void> maybeClearHandoffAfterDrain() async {}

/// Nothing to sweep on native.
void sweepOrphanedHandoff() {}
