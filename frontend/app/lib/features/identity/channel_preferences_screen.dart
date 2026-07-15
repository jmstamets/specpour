// T151/T055: view and update notification channel opt-in preferences
// (GET/PUT /me/channels). Completes T055's last remaining screen gap.
// Reachable via T161's account menu at /account/channels.

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client_provider.dart';
import '../../core/auth/identity_auth_service.dart' show describeIdentityError;
import '../../core/l10n/gen/app_localizations.dart';

final channelPreferencesProvider =
    FutureProvider.autoDispose<ChannelPreferences>((ref) async {
      final response = await ref
          .watch(notificationsApiProvider)
          .getMyChannelPreferences();
      return response.data!;
    });

class ChannelPreferencesScreen extends ConsumerStatefulWidget {
  const ChannelPreferencesScreen({super.key});

  @override
  ConsumerState<ChannelPreferencesScreen> createState() =>
      _ChannelPreferencesScreenState();
}

class _ChannelPreferencesScreenState
    extends ConsumerState<ChannelPreferencesScreen> {
  String? _errorMessage;
  final Set<String> _pendingChannels = {};

  Future<void> _toggle(
    ChannelPreferenceChannelEnum channel,
    bool optedIn,
  ) async {
    final channelKey = channel.name;
    setState(() {
      _pendingChannels.add(channelKey);
      _errorMessage = null;
    });

    try {
      await ref
          .read(notificationsApiProvider)
          .updateMyChannelPreferences(
            channelPreferencesUpdate: ChannelPreferencesUpdate(
              (b) => b.channels.add(
                (ChannelPreferencesUpdateChannelsInnerBuilder()
                      ..channel =
                          ChannelPreferencesUpdateChannelsInnerChannelEnum.valueOf(
                            channel.name,
                          )
                      ..optedIn = optedIn)
                    .build(),
              ),
            ),
          );
      ref.invalidate(channelPreferencesProvider);
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = describeIdentityError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _pendingChannels.remove(channelKey));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final preferences = ref.watch(channelPreferencesProvider);

    return Scaffold(
      key: const Key('channelPreferencesScreen'),
      appBar: AppBar(title: Text(l10n.channelPreferencesTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: preferences.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text(describeIdentityError(error)),
          data: (data) => _buildBody(context, l10n, data),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    ChannelPreferences preferences,
  ) {
    return ListView(
      children: [
        if (_errorMessage case final error?) ...[
          Text(
            error,
            key: const Key('channelPreferencesErrorMessage'),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 16),
        ],
        for (final preference in preferences.channels)
          SwitchListTile(
            key: Key('channelPreferenceSwitch-${preference.channel.name}'),
            title: Text(_labelFor(l10n, preference.channel)),
            value: preference.optedIn,
            onChanged: _pendingChannels.contains(preference.channel.name)
                ? null
                : (value) => _toggle(preference.channel, value),
          ),
      ],
    );
  }

  String _labelFor(
    AppLocalizations l10n,
    ChannelPreferenceChannelEnum channel,
  ) => switch (channel) {
    ChannelPreferenceChannelEnum.email => l10n.channelPreferencesEmailLabel,
    ChannelPreferenceChannelEnum.push => l10n.channelPreferencesPushLabel,
    _ => channel.name,
  };
}
