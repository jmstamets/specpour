// T052: deactivate/reactivate the account. Not yet reachable from any
// navigation chrome (same flagged gap as mfa_settings_screen.dart, T161) but a
// real, complete, directly-routable screen at /account/lifecycle.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/widgets/api_error_display.dart';

class AccountLifecycleScreen extends ConsumerStatefulWidget {
  const AccountLifecycleScreen({super.key});

  @override
  ConsumerState<AccountLifecycleScreen> createState() =>
      _AccountLifecycleScreenState();
}

class _AccountLifecycleScreenState
    extends ConsumerState<AccountLifecycleScreen> {
  String? _errorMessage;
  String? _infoMessage;
  bool _submitting = false;
  bool _deactivated = false;

  Future<void> _deactivate() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await _confirm(
      title: l10n.accountLifecycleDeactivateConfirmTitle,
      message: l10n.accountLifecycleDeactivateConfirmMessage,
      confirmLabel: l10n.accountLifecycleDeactivateButton,
    );
    if (!confirmed || !mounted) {
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
      _infoMessage = null;
    });

    try {
      await ref.read(identityAuthServiceProvider).deactivateAccount();
      if (mounted) {
        setState(() {
          _deactivated = true;
          _infoMessage = l10n.accountLifecycleDeactivatedConfirmation;
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

  Future<void> _reactivate() async {
    final l10n = AppLocalizations.of(context);

    setState(() {
      _submitting = true;
      _errorMessage = null;
      _infoMessage = null;
    });

    try {
      await ref.read(identityAuthServiceProvider).reactivateAccount();
      if (mounted) {
        setState(() {
          _deactivated = false;
          _infoMessage = l10n.accountLifecycleReactivatedConfirmation;
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

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('accountLifecycleConfirmDialog'),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.accountLifecycleCancelButton),
          ),
          TextButton(
            key: const Key('accountLifecycleConfirmDialogButton'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      key: const Key('accountLifecycleScreen'),
      appBar: AppBar(title: Text(l10n.accountLifecycleTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            if (_infoMessage case final info?) ...[
              Text(info, key: const Key('accountLifecycleInfoMessage')),
              const SizedBox(height: 16),
            ],
            if (_errorMessage case final error?) ...[
              ApiErrorDisplay(
                message: error,
                messageKey: const Key('accountLifecycleErrorMessage'),
              ),
              const SizedBox(height: 16),
            ],
            Text(l10n.accountLifecycleGracePeriodExplanation),
            const SizedBox(height: 24),
            if (_deactivated)
              ElevatedButton(
                key: const Key('accountLifecycleReactivateButton'),
                onPressed: _submitting ? null : _reactivate,
                child: Text(l10n.accountLifecycleReactivateButton),
              )
            else
              ElevatedButton(
                key: const Key('accountLifecycleDeactivateButton'),
                onPressed: _submitting ? null : _deactivate,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onError,
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: Text(l10n.accountLifecycleDeactivateButton),
              ),
          ],
        ),
      ),
    );
  }
}
