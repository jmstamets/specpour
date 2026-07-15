// T051: list and revoke active sessions/devices. Not yet reachable from any
// navigation chrome (no account/settings shell exists yet — same flagged gap
// as mfa_settings_screen.dart, T161) but a real, complete, directly-routable
// screen at /account/sessions.

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/l10n/gen/app_localizations.dart';

final sessionsProvider = FutureProvider.autoDispose<List<Session>>(
  (ref) => ref.watch(identityAuthServiceProvider).listSessions(),
);

class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key});

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen> {
  String? _errorMessage;
  String? _revokingSessionId;

  Future<void> _revoke(String sessionId) async {
    setState(() {
      _revokingSessionId = sessionId;
      _errorMessage = null;
    });

    try {
      await ref
          .read(identityAuthServiceProvider)
          .revokeSession(sessionId: sessionId);
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
    final dateFormat = DateFormat.yMMMd().add_jm();

    return ListView(
      key: const Key('sessionsList'),
      children: [
        if (_errorMessage case final error?) ...[
          Text(
            error,
            key: const Key('sessionsErrorMessage'),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 16),
        ],
        if (sessions.isEmpty)
          Text(l10n.sessionsEmpty, key: const Key('sessionsEmptyMessage'))
        else
          for (final session in sessions)
            Card(
              key: Key('sessionCard-${session.id}'),
              child: ListTile(
                title: Text(session.deviceDescription),
                subtitle: Text(
                  l10n.sessionsLastActive(
                    dateFormat.format(session.lastSeenAt),
                  ),
                ),
                trailing: ElevatedButton(
                  key: Key('sessionRevokeButton-${session.id}'),
                  onPressed: _revokingSessionId == session.id
                      ? null
                      : () => _revoke(session.id),
                  child: Text(l10n.sessionsRevokeButton),
                ),
              ),
            ),
      ],
    );
  }
}
