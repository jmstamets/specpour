// T049: shown when a social sign-in callback reports needsDateOfBirth=true —
// a brand-new account via Google/Apple/Microsoft, none of which reliably
// supply a date of birth (Apple deliberately never does). FR-002/FR-002c
// apply identically to social registration (spec.md US2's own wording), so
// this is the same real date-picker capture RegisterScreen uses, reading the
// still-pending external identity server-side rather than re-collecting
// email/password.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/guest_gate/guest_gate.dart';
import '../../core/l10n/gen/app_localizations.dart';

class CompleteExternalRegistrationScreen extends ConsumerStatefulWidget {
  const CompleteExternalRegistrationScreen({super.key});

  @override
  ConsumerState<CompleteExternalRegistrationScreen> createState() =>
      _CompleteExternalRegistrationScreenState();
}

class _CompleteExternalRegistrationScreenState
    extends ConsumerState<CompleteExternalRegistrationScreen> {
  final _displayNameController = TextEditingController();
  DateTime? _dateOfBirth;
  String? _errorMessage;
  bool _submitting = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 21, now.month, now.day),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
    );
    if (picked != null && mounted) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final dateOfBirth = _dateOfBirth;

    if (_displayNameController.text.isEmpty || dateOfBirth == null) {
      setState(() => _errorMessage = l10n.completeExternalRegistrationMissingFieldsError);
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      await ref.read(identityAuthServiceProvider).completeExternalRegistration(
            dateOfBirth: dateOfBirth,
            displayName: _displayNameController.text,
          );

      if (!mounted) {
        return;
      }

      completePendingIntent(ref);
      context.go('/');
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
      key: const Key('completeExternalRegistrationScreen'),
      appBar: AppBar(title: Text(l10n.completeExternalRegistrationTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text(l10n.completeExternalRegistrationBody),
            const SizedBox(height: 16),
            TextField(
              key: const Key('completeExternalRegistrationDisplayNameField'),
              controller: _displayNameController,
              decoration: InputDecoration(labelText: l10n.completeExternalRegistrationDisplayNameLabel),
            ),
            const SizedBox(height: 16),
            Text(l10n.completeExternalRegistrationDateOfBirthLabel, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            OutlinedButton(
              key: const Key('completeExternalRegistrationDateOfBirthButton'),
              onPressed: () => _pickDate(context),
              child: Text(
                _dateOfBirth == null
                    ? l10n.completeExternalRegistrationDateOfBirthHint
                    : _formatDate(_dateOfBirth!),
              ),
            ),
            if (_errorMessage case final error?) ...[
              const SizedBox(height: 16),
              Text(
                error,
                key: const Key('completeExternalRegistrationErrorMessage'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('completeExternalRegistrationSubmitButton'),
              onPressed: _submitting ? null : _submit,
              child: Text(l10n.completeExternalRegistrationSubmitButton),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
