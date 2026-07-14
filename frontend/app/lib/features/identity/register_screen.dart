// T047/T055: registration screen. The date-of-birth field is a real date
// picker (never a checkbox), same convention as the guest age gate — but unlike
// the age gate, the entered DOB IS transmitted once, to POST /auth/register
// (it's the sole capture point; FR-002b's encrypted-storage/derived-predicate-only
// rule takes over from there). On success, completes the pending guest intent
// (T043) if one triggered this screen, otherwise returns to Discover.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/guest_gate/guest_gate.dart';
import '../../core/l10n/gen/app_localizations.dart';
import 'social_sign_in_buttons.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  DateTime? _dateOfBirth;
  String? _errorMessage;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _displayNameController.text.isEmpty ||
        dateOfBirth == null) {
      setState(() => _errorMessage = l10n.registerMissingFieldsError);
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      await ref.read(identityAuthServiceProvider).register(
            email: _emailController.text,
            password: _passwordController.text,
            displayName: _displayNameController.text,
            dateOfBirth: dateOfBirth,
          );

      if (!mounted) {
        return;
      }

      completePendingIntent(ref);
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/');
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _errorMessage = describeIdentityError(error));
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
      key: const Key('registerScreen'),
      appBar: AppBar(title: Text(l10n.registerTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              key: const Key('registerEmailField'),
              controller: _emailController,
              decoration: InputDecoration(labelText: l10n.registerEmailLabel),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('registerPasswordField'),
              controller: _passwordController,
              decoration: InputDecoration(labelText: l10n.registerPasswordLabel),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('registerDisplayNameField'),
              controller: _displayNameController,
              decoration: InputDecoration(labelText: l10n.registerDisplayNameLabel),
            ),
            const SizedBox(height: 16),
            Text(l10n.registerDateOfBirthLabel, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            OutlinedButton(
              key: const Key('registerDateOfBirthButton'),
              onPressed: () => _pickDate(context),
              child: Text(
                _dateOfBirth == null ? l10n.registerDateOfBirthHint : _formatDate(_dateOfBirth!),
              ),
            ),
            if (_errorMessage case final error?) ...[
              const SizedBox(height: 16),
              Text(
                error,
                key: const Key('registerErrorMessage'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('registerSubmitButton'),
              onPressed: _submitting ? null : _submit,
              child: Text(l10n.registerSubmitButton),
            ),
            const SizedBox(height: 12),
            TextButton(
              key: const Key('registerSignInInsteadLink'),
              onPressed: () => context.push('/sign-in'),
              child: Text(l10n.registerSignInInstead),
            ),
            const SocialSignInButtons(),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
