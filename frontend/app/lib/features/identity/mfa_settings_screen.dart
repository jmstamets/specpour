// T050: view/enroll/disable TOTP MFA. Not yet reachable from any navigation
// chrome (there is no account/settings shell in the app yet — flagged as a
// follow-on task) but is a real, complete, directly-routable screen at
// /account/mfa.

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/l10n/gen/app_localizations.dart';

final mfaStatusProvider = FutureProvider.autoDispose<MfaStatus>(
  (ref) => ref.watch(identityAuthServiceProvider).mfaStatus(),
);

class MfaSettingsScreen extends ConsumerStatefulWidget {
  const MfaSettingsScreen({super.key});

  @override
  ConsumerState<MfaSettingsScreen> createState() => _MfaSettingsScreenState();
}

class _MfaSettingsScreenState extends ConsumerState<MfaSettingsScreen> {
  final _codeController = TextEditingController();
  MfaEnrollment? _pendingEnrollment;
  String? _errorMessage;
  String? _infoMessage;
  bool _submitting = false;

  /// T163: the backup-code set from the most recent confirm/regenerate
  /// response — shown exactly once (the backend never re-shows a set once
  /// issued), then dismissed by the user acknowledging they've saved it.
  List<String>? _backupCodesToShow;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _startEnrollment() async {
    setState(() {
      _submitting = true;
      _errorMessage = null;
      _infoMessage = null;
    });

    try {
      final enrollment = await ref
          .read(identityAuthServiceProvider)
          .startMfaEnrollment();
      if (mounted) {
        setState(() => _pendingEnrollment = enrollment);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = describeIdentityError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _confirmEnrollment() async {
    final l10n = AppLocalizations.of(context);

    if (_codeController.text.isEmpty) {
      setState(() => _errorMessage = l10n.mfaSettingsMissingCodeError);
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      final enrollment = await ref
          .read(identityAuthServiceProvider)
          .confirmMfaEnrollment(code: _codeController.text);
      if (!mounted) {
        return;
      }
      setState(() {
        _pendingEnrollment = null;
        _infoMessage = l10n.mfaSettingsEnabledConfirmation;
        _backupCodesToShow = enrollment.backupCodes?.toList();
      });
      _codeController.clear();
      ref.invalidate(mfaStatusProvider);
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = describeIdentityError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _disable() async {
    final l10n = AppLocalizations.of(context);

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      await ref.read(identityAuthServiceProvider).disableMfa();
      if (!mounted) {
        return;
      }
      setState(() {
        _infoMessage = l10n.mfaSettingsDisabledConfirmation;
        // Disabling MFA clears backup codes server-side (meaningless without
        // an active enrollment) — nothing left to show.
        _backupCodesToShow = null;
      });
      ref.invalidate(mfaStatusProvider);
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = describeIdentityError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  /// T163: invalidates every prior backup code and issues a fresh set of 10.
  Future<void> _regenerateBackupCodes() async {
    final l10n = AppLocalizations.of(context);

    setState(() {
      _submitting = true;
      _errorMessage = null;
      _infoMessage = null;
    });

    try {
      final codes = await ref
          .read(identityAuthServiceProvider)
          .regenerateBackupCodes();
      if (mounted) {
        setState(() {
          _backupCodesToShow = codes.backupCodes.toList();
          _infoMessage = l10n.mfaSettingsBackupCodesRegeneratedConfirmation;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = describeIdentityError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(mfaStatusProvider);

    return Scaffold(
      key: const Key('mfaSettingsScreen'),
      appBar: AppBar(title: Text(l10n.mfaSettingsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: status.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text(describeIdentityError(error)),
          data: (mfaStatus) => _buildBody(context, l10n, mfaStatus),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    MfaStatus status,
  ) {
    final pending = _pendingEnrollment;

    return ListView(
      children: [
        Text(
          status.enabled
              ? l10n.mfaSettingsStatusEnabled
              : l10n.mfaSettingsStatusDisabled,
          key: const Key('mfaSettingsStatusText'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        if (_infoMessage case final info?) ...[
          Text(info, key: const Key('mfaSettingsInfoMessage')),
          const SizedBox(height: 16),
        ],
        if (_errorMessage case final error?) ...[
          Text(
            error,
            key: const Key('mfaSettingsErrorMessage'),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 16),
        ],
        if (_backupCodesToShow case final codes?) ...[
          Text(l10n.mfaSettingsBackupCodesLabel),
          const SizedBox(height: 8),
          SelectableText(
            codes.join('\n'),
            key: const Key('mfaSettingsBackupCodesText'),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontFamily: 'monospace'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            key: const Key('mfaSettingsBackupCodesSavedButton'),
            onPressed: () => setState(() => _backupCodesToShow = null),
            child: Text(l10n.mfaSettingsBackupCodesSavedButton),
          ),
        ] else if (status.enabled) ...[
          ElevatedButton(
            key: const Key('mfaSettingsDisableButton'),
            onPressed: _submitting ? null : _disable,
            child: Text(l10n.mfaSettingsDisableButton),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            key: const Key('mfaSettingsRegenerateBackupCodesButton'),
            onPressed: _submitting ? null : _regenerateBackupCodes,
            child: Text(l10n.mfaSettingsRegenerateBackupCodesButton),
          ),
        ] else if (pending == null) ...[
          ElevatedButton(
            key: const Key('mfaSettingsEnrollButton'),
            onPressed: _submitting ? null : _startEnrollment,
            child: Text(l10n.mfaSettingsEnrollButton),
          ),
        ] else ...[
          Text(l10n.mfaSettingsSecretLabel),
          const SizedBox(height: 8),
          SelectableText(
            pending.secret ?? '',
            key: const Key('mfaSettingsSecretText'),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontFamily: 'monospace'),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('mfaSettingsCodeField'),
            controller: _codeController,
            decoration: InputDecoration(
              labelText: l10n.mfaSettingsEnterCodeLabel,
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            key: const Key('mfaSettingsConfirmButton'),
            onPressed: _submitting ? null : _confirmEnrollment,
            child: Text(l10n.mfaSettingsConfirmButton),
          ),
        ],
      ],
    );
  }
}
