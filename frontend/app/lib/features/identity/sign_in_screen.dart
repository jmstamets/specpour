// T047/T055: sign-in screen. On success, completes the pending guest intent
// (T043) if one triggered this screen, otherwise returns to Discover.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/guest_gate/guest_gate.dart';
import '../../core/l10n/gen/app_localizations.dart';
import 'social_sign_in_buttons.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = l10n.signInMissingFieldsError);
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      final requiresMfa = await ref.read(identityAuthServiceProvider).signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );

      if (!mounted) {
        return;
      }

      if (requiresMfa) {
        context.push('/mfa-challenge');
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
      key: const Key('signInScreen'),
      appBar: AppBar(title: Text(l10n.signInTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              key: const Key('signInEmailField'),
              controller: _emailController,
              decoration: InputDecoration(labelText: l10n.registerEmailLabel),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('signInPasswordField'),
              controller: _passwordController,
              decoration: InputDecoration(labelText: l10n.registerPasswordLabel),
              obscureText: true,
            ),
            if (_errorMessage case final error?) ...[
              const SizedBox(height: 16),
              Text(
                error,
                key: const Key('signInErrorMessage'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('signInSubmitButton'),
              onPressed: _submitting ? null : _submit,
              child: Text(l10n.signInSubmitButton),
            ),
            const SizedBox(height: 12),
            TextButton(
              key: const Key('signInRegisterInsteadLink'),
              onPressed: () => context.push('/register'),
              child: Text(l10n.signInRegisterInstead),
            ),
            TextButton(
              key: const Key('signInForgotPasswordLink'),
              onPressed: () => context.push('/recovery'),
              child: Text(l10n.signInForgotPasswordLink),
            ),
            const SocialSignInButtons(),
          ],
        ),
      ),
    );
  }
}
