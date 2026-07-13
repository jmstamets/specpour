// T043: post-signup intent capture (US1 scenario 6 — "the original action
// completes after signup, no lost intent"). When a guest attempts a gated action
// we stash what they were trying to do here, show the sign-in prompt, and the
// sign-in flow (T055, not built yet) replays it via completePendingIntent once
// the user authenticates. In-session only (Riverpod state) — which is exactly the
// window that matters, since sign-in is an in-session flow; it deliberately does
// not persist across an app restart.

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A captured guest action awaiting authentication. [resume] is the work to run
/// once the user signs in; [actionLabel] is shown in the sign-in prompt so the
/// user understands what they're signing in to do.
@immutable
class GuestIntent {
  const GuestIntent({required this.actionLabel, required this.resume});

  final String actionLabel;
  final VoidCallback resume;
}

class PendingGuestIntent extends Notifier<GuestIntent?> {
  @override
  GuestIntent? build() => null;

  void capture(GuestIntent intent) => state = intent;

  void clear() => state = null;
}

final pendingGuestIntentProvider =
    NotifierProvider<PendingGuestIntent, GuestIntent?>(PendingGuestIntent.new);
