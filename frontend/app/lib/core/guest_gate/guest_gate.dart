// T043: guest gating (US1 scenario 6). Reading the curated library is
// unrestricted; personalized/interactive actions (save, rate, add-to-library —
// none built yet, they arrive with their own stories) route through
// requireAccount, which either runs the action (if signed in) or captures the
// intent and prompts for sign-in (if a guest). The captured intent is replayed
// by completePendingIntent once the sign-in flow (T055) authenticates the user.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client_provider.dart';
import '../l10n/gen/app_localizations.dart';
import 'pending_intent.dart';

/// Runs [onAuthenticated] if the user is signed in; otherwise captures it as a
/// pending intent and shows the sign-in prompt. [actionLabel] describes the
/// attempted action for the prompt copy (e.g. "save this recipe").
Future<void> requireAccount({
  required WidgetRef ref,
  required BuildContext context,
  required String actionLabel,
  required VoidCallback onAuthenticated,
}) async {
  final isSignedIn = ref.read(authTokenProvider) != null;
  if (isSignedIn) {
    onAuthenticated();
    return;
  }

  ref
      .read(pendingGuestIntentProvider.notifier)
      .capture(GuestIntent(actionLabel: actionLabel, resume: onAuthenticated));

  await showModalBottomSheet<void>(
    context: context,
    builder: (context) => GuestGatePrompt(actionLabel: actionLabel),
  );
}

/// Called by the sign-in flow (T055) after a successful authentication: replays
/// the captured guest intent, if any, then clears it. Safe to call when there is
/// no pending intent (no-op).
void completePendingIntent(WidgetRef ref) {
  final intent = ref.read(pendingGuestIntentProvider);
  if (intent == null) {
    return;
  }

  ref.read(pendingGuestIntentProvider.notifier).clear();
  intent.resume();
}

/// The sign-in prompt shown to a gated guest. The sign-in / register buttons
/// navigate to the identity screens once T055 builds them; until then they
/// dismiss the sheet, leaving the captured intent pending for that flow to
/// consume (users still never manually re-do the action — the intent is held).
class GuestGatePrompt extends ConsumerWidget {
  const GuestGatePrompt({required this.actionLabel, super.key});

  final String actionLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      key: const Key('accountGateSignInPrompt'),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.guestGatePromptTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(l10n.guestGatePromptBody(actionLabel)),
          const SizedBox(height: 24),
          Row(
            children: [
              // Navigation to the sign-in/register screens is wired by T055;
              // until then these dismiss the sheet with the intent still captured.
              ElevatedButton(
                key: const Key('accountGateSignInButton'),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.guestGateSignInButton),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                key: const Key('accountGateRegisterButton'),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.guestGateRegisterButton),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.guestGateDismissButton),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
