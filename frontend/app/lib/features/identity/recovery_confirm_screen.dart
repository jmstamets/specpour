// T050: account recovery, step 2 — submit the emailed code plus a new
// password. On success, sends the caller to sign in with the new password.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/l10n/gen/app_localizations.dart';

class RecoveryConfirmScreen extends ConsumerStatefulWidget {
  const RecoveryConfirmScreen({super.key});

  @override
  ConsumerState<RecoveryConfirmScreen> createState() => _RecoveryConfirmScreenState();
}

class _RecoveryConfirmScreenState extends ConsumerState<RecoveryConfirmScreen> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  String? _errorMessage;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (_emailController.text.isEmpty ||
        _tokenController.text.isEmpty ||
        _newPasswordController.text.isEmpty) {
      setState(() => _errorMessage = l10n.recoveryConfirmMissingFieldsError);
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      await ref.read(identityAuthServiceProvider).confirmRecovery(
            email: _emailController.text,
            token: _tokenController.text,
            newPassword: _newPasswordController.text,
          );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.recoveryConfirmSuccessMessage)),
      );
      context.go('/sign-in');
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
      key: const Key('recoveryConfirmScreen'),
      appBar: AppBar(title: Text(l10n.recoveryConfirmTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              key: const Key('recoveryConfirmEmailField'),
              controller: _emailController,
              decoration: InputDecoration(labelText: l10n.recoveryConfirmEmailLabel),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('recoveryConfirmTokenField'),
              controller: _tokenController,
              decoration: InputDecoration(labelText: l10n.recoveryConfirmTokenLabel),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('recoveryConfirmNewPasswordField'),
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: l10n.recoveryConfirmNewPasswordLabel),
              obscureText: true,
            ),
            if (_errorMessage case final error?) ...[
              const SizedBox(height: 16),
              Text(
                error,
                key: const Key('recoveryConfirmErrorMessage'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('recoveryConfirmSubmitButton'),
              onPressed: _submitting ? null : _submit,
              child: Text(l10n.recoveryConfirmSubmitButton),
            ),
          ],
        ),
      ),
    );
  }
}
