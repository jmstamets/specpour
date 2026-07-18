// T050: view/enroll/disable TOTP MFA. Not yet reachable from any navigation
// chrome (there is no account/settings shell in the app yet — flagged as a
// follow-on task) but is a real, complete, directly-routable screen at
// /account/mfa.

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/widgets/api_error_display.dart';

/// T187: formats a base32 TOTP secret in groups of four for legible manual
/// entry ("ABCD EFGH IJKL ..."), the standard authenticator-app fallback layout
/// when a QR code can't be scanned.
String _groupSecretInFours(String secret) {
  final groups = <String>[];
  for (var i = 0; i < secret.length; i += 4) {
    groups.add(
      secret.substring(i, i + 4 > secret.length ? secret.length : i + 4),
    );
  }
  return groups.join(' ');
}

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
          ApiErrorDisplay(
            message: error,
            messageKey: const Key('mfaSettingsErrorMessage'),
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
          // T187: enrollment is QR-first. The backend returns a standard
          // otpauth:// URI (algorithm/digits/period confirmed SHA1/6/30 against
          // the server's own verify path); render it as a scannable code with
          // instructions above and the manual key beneath as the fallback.
          Text(l10n.mfaSettingsScanInstructions),
          const SizedBox(height: 16),
          if (pending.otpAuthUri case final uri?) ...[
            Center(
              child: QrImageView(
                key: const Key('mfaSettingsQrCode'),
                data: uri,
                version: QrVersions.auto,
                size: 200,
                // A fixed white quiet-zone background so the code stays scannable
                // regardless of the app's (light/dark) theme surface behind it.
                backgroundColor: Colors.white,
              ),
            ),
            // T187 (e): the otpauth:// URI is otherwise encoded only inside the
            // QR bitmap, unreadable by the browser-tier test. This offstage node
            // (not laid out, not painted, no a11y surface) exposes the exact URI
            // the backend returned so the test can assert it's well-formed
            // (issuer + secret) end-to-end against the real server.
            Offstage(child: Text(uri, key: const Key('mfaSettingsOtpAuthUri'))),
          ],
          const SizedBox(height: 16),
          Text(l10n.mfaSettingsManualKeyLabel),
          const SizedBox(height: 8),
          SelectableText(
            _groupSecretInFours(pending.secret ?? ''),
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
