// T161: the account/settings navigation shell — the single entry point that
// makes MFA, sessions, notification preferences, and account lifecycle/data
// screens actually reachable through normal navigation, rather than
// direct-route-only. Deliberately minimal (a list of destinations), not a
// full settings redesign.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/gen/app_localizations.dart';

class AccountMenuScreen extends ConsumerWidget {
  const AccountMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      key: const Key('accountMenuScreen'),
      appBar: AppBar(title: Text(l10n.accountMenuTitle)),
      body: ListView(
        children: [
          ListTile(
            key: const Key('accountMenuMfaButton'),
            leading: const Icon(Icons.lock_outline),
            title: Text(l10n.mfaSettingsTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/account/mfa'),
          ),
          ListTile(
            key: const Key('accountMenuSessionsButton'),
            leading: const Icon(Icons.devices_outlined),
            title: Text(l10n.sessionsTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/account/sessions'),
          ),
          ListTile(
            key: const Key('accountMenuChannelsButton'),
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l10n.channelPreferencesTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/account/channels'),
          ),
          ListTile(
            key: const Key('accountMenuDataButton'),
            leading: const Icon(Icons.download_outlined),
            title: Text(l10n.accountDataTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/account/data'),
          ),
          ListTile(
            key: const Key('accountMenuLifecycleButton'),
            leading: const Icon(Icons.person_off_outlined),
            title: Text(l10n.accountLifecycleTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/account/lifecycle'),
          ),
        ],
      ),
    );
  }
}
