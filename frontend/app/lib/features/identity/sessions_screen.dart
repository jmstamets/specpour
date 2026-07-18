// T051: list and revoke active sessions/devices. Not yet reachable from any
// navigation chrome (no account/settings shell exists yet — same flagged gap
// as mfa_settings_screen.dart, T161) but a real, complete, directly-routable
// screen at /account/sessions.

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/widgets/api_error_display.dart';
import 'user_agent_humanizer.dart';

final sessionsProvider = FutureProvider.autoDispose<List<Session>>(
  (ref) => ref.watch(identityAuthServiceProvider).listSessions(),
);

/// T189: humanized relative last-active time ("2 hours ago"). Pure given [now]
/// so it's testable; the screen passes the real clock.
String relativeLastActive(
  DateTime lastSeen,
  DateTime now,
  AppLocalizations l10n,
) {
  final delta = now.difference(lastSeen);
  if (delta.inMinutes < 1) {
    return l10n.sessionsRelativeJustNow;
  }
  if (delta.inHours < 1) {
    return l10n.sessionsRelativeMinutesAgo(delta.inMinutes);
  }
  if (delta.inDays < 1) {
    return l10n.sessionsRelativeHoursAgo(delta.inHours);
  }
  return l10n.sessionsRelativeDaysAgo(delta.inDays);
}

class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key});

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen> {
  String? _errorMessage;
  String? _revokingSessionId;

  /// T189: session ids whose raw user-agent detail row is expanded.
  final Set<String> _expandedSessionIds = {};

  /// T189: revoking a session. If it's the CALLER's own current session,
  /// revoking it is signing yourself out — so it goes through the exact same
  /// path as the Account-menu Sign out (T188): clear local auth, notify other
  /// tabs, land on Discover. Any other session is a plain per-session revoke
  /// that just refreshes the list.
  Future<void> _revoke(Session session) async {
    setState(() {
      _revokingSessionId = session.id;
      _errorMessage = null;
    });

    try {
      if (session.isCurrent) {
        await ref.read(identityAuthServiceProvider).signOutCurrentSession();
        if (mounted) {
          context.go('/');
        }
        return;
      }

      await ref
          .read(identityAuthServiceProvider)
          .revokeSession(sessionId: session.id);
      ref.invalidate(sessionsProvider);
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = describeIdentityError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _revokingSessionId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sessions = ref.watch(sessionsProvider);

    return Scaffold(
      key: const Key('sessionsScreen'),
      appBar: AppBar(title: Text(l10n.sessionsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: sessions.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text(describeIdentityError(error)),
          data: (list) => _buildBody(context, l10n, list),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    List<Session> sessions,
  ) {
    final now = DateTime.now();

    return ListView(
      key: const Key('sessionsList'),
      children: [
        if (_errorMessage case final error?) ...[
          ApiErrorDisplay(
            message: error,
            messageKey: const Key('sessionsErrorMessage'),
          ),
          const SizedBox(height: 16),
        ],
        if (sessions.isEmpty)
          Text(l10n.sessionsEmpty, key: const Key('sessionsEmptyMessage'))
        else
          for (final session in sessions)
            _sessionCard(context, l10n, session, now),
      ],
    );
  }

  Widget _sessionCard(
    BuildContext context,
    AppLocalizations l10n,
    Session session,
    DateTime now,
  ) {
    final humanized = humanizeUserAgent(session.deviceDescription);
    final expanded = _expandedSessionIds.contains(session.id);

    return Card(
      key: Key('sessionCard-${session.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Row(
              children: [
                // Fall back to the raw UA as the title when it isn't
                // recognizable — never hide the only identifying info we have.
                Flexible(child: Text(humanized ?? session.deviceDescription)),
                if (session.isCurrent) ...[
                  const SizedBox(width: 8),
                  Chip(
                    key: Key('sessionThisDeviceBadge-${session.id}'),
                    label: Text(l10n.sessionsThisDevice),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ],
            ),
            subtitle: Text(
              l10n.sessionsLastActive(
                relativeLastActive(session.lastSeenAt, now, l10n),
              ),
            ),
            trailing: ElevatedButton(
              key: Key('sessionRevokeButton-${session.id}'),
              onPressed: _revokingSessionId == session.id
                  ? null
                  : () => _revoke(session),
              // The current session's revoke IS a sign-out (T188 path).
              child: Text(
                session.isCurrent
                    ? l10n.sessionsSignOutButton
                    : l10n.sessionsRevokeButton,
              ),
            ),
          ),
          // T189: the raw User-Agent is one tap away — humanization is
          // best-effort, so the exact string stays inspectable.
          if (humanized != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                key: Key('sessionDetailsToggle-${session.id}'),
                onPressed: () => setState(() {
                  if (expanded) {
                    _expandedSessionIds.remove(session.id);
                  } else {
                    _expandedSessionIds.add(session.id);
                  }
                }),
                child: Text(l10n.sessionsDetailsLabel),
              ),
            ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SelectableText(
                session.deviceDescription,
                key: Key('sessionRawUserAgent-${session.id}'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
