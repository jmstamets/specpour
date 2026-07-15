// T050: account recovery, step 1 — request a recovery code by email. Always
// shows the same success message regardless of whether the email matched an
// account (no enumeration, mirrors the backend's own 202-regardless response).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/l10n/gen/app_localizations.dart';

class RecoveryRequestScreen extends ConsumerStatefulWidget {
  const RecoveryRequestScreen({super.key});

  @override
  ConsumerState<RecoveryRequestScreen> createState() =>
      _RecoveryRequestScreenState();
}

class _RecoveryRequestScreenState extends ConsumerState<RecoveryRequestScreen> {
  final _emailController = TextEditingController();
  String? _errorMessage;
  String? _successMessage;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (_emailController.text.isEmpty) {
      setState(() => _errorMessage = l10n.recoveryRequestMissingFieldError);
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await ref
          .read(identityAuthServiceProvider)
          .requestRecovery(email: _emailController.text);
      if (mounted) {
        setState(() => _successMessage = l10n.recoveryRequestSuccessMessage);
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

    return Scaffold(
      key: const Key('recoveryRequestScreen'),
      appBar: AppBar(title: Text(l10n.recoveryRequestTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              key: const Key('recoveryRequestEmailField'),
              controller: _emailController,
              decoration: InputDecoration(
                labelText: l10n.recoveryRequestEmailLabel,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            if (_successMessage case final success?) ...[
              const SizedBox(height: 16),
              Text(success, key: const Key('recoveryRequestSuccessMessage')),
            ],
            if (_errorMessage case final error?) ...[
              const SizedBox(height: 16),
              Text(
                error,
                key: const Key('recoveryRequestErrorMessage'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('recoveryRequestSubmitButton'),
              onPressed: _submitting ? null : _submit,
              child: Text(l10n.recoveryRequestSubmitButton),
            ),
            const SizedBox(height: 12),
            TextButton(
              key: const Key('recoveryRequestGoToConfirmLink'),
              onPressed: () => context.push('/recovery/confirm'),
              child: Text(l10n.recoveryRequestGoToConfirmLink),
            ),
          ],
        ),
      ),
    );
  }
}
