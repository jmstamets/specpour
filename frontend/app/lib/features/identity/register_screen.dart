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
import '../../core/widgets/api_error_display.dart';
import 'social_sign_in_buttons.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

/// T171: mirrors IdentityModule's actual server-side policy exactly
/// (`AddIdentityCore`: `RequiredLength = 12`; Require Digit/Lowercase/
/// Uppercase/NonAlphanumeric all disabled per T047's NIST-800-63B
/// relaxation) — the only client-side rule to show/enforce is length. Keep
/// this in lockstep with the backend so the two can't drift.
const _minimumPasswordLength = 12;

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  DateTime? _dateOfBirth;
  String? _errorMessage;
  // T171: bound to the password field specifically (TextField.errorText),
  // distinct from _errorMessage's form-level display — either a local
  // pre-submit length check, or a server error whose text names the
  // password (the backend joins all IdentityResult errors into one `detail`
  // string, not a field-keyed shape, so this is a text-match heuristic, not
  // a structural guarantee; see describeApiError's own doc comment, T170).
  String? _passwordFieldError;
  bool _obscurePassword = true;
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

    // T171: mirrors the server policy locally so a too-short password never
    // needs a round trip to discover — the field-level error, not a generic
    // form-level one, since the failure is specifically about this field.
    if (_passwordController.text.length < _minimumPasswordLength) {
      setState(() => _passwordFieldError = l10n.registerPasswordPolicyHint);
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
      _passwordFieldError = null;
    });

    try {
      await ref
          .read(identityAuthServiceProvider)
          .register(
            email: _emailController.text,
            password: _passwordController.text,
            displayName: _displayNameController.text,
            dateOfBirth: dateOfBirth,
          );

      if (!mounted) {
        return;
      }

      // F2: only navigate ourselves when there was no pending intent — a resumed
      // intent already navigates to its target (see sign_in_screen).
      if (!completePendingIntent(ref)) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      final message = describeIdentityError(error);
      // T171: a heuristic, not a structural field-binding — the backend
      // joins all IdentityResult errors into one `detail` string rather than
      // a field-keyed shape (see describeApiError's own doc comment, T170).
      // Routes it to the password field specifically when the message names
      // the password, so "Passwords must be at least 12 characters." lands
      // where the user is looking instead of in a form-level banner.
      if (message.toLowerCase().contains('password')) {
        setState(() => _passwordFieldError = message);
      } else {
        setState(() => _errorMessage = message);
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
              decoration: InputDecoration(
                labelText: l10n.registerPasswordLabel,
                // T171: shown before first failure, not only after — the
                // walkthrough's own finding was that the 12-char minimum
                // was discoverable only by a 400.
                helperText: l10n.registerPasswordPolicyHint,
                errorText: _passwordFieldError,
                suffixIcon: IconButton(
                  key: const Key('registerPasswordRevealToggle'),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  tooltip: _obscurePassword
                      ? l10n.registerPasswordRevealTooltip
                      : l10n.registerPasswordHideTooltip,
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              obscureText: _obscurePassword,
              onChanged: (_) {
                if (_passwordFieldError != null) {
                  setState(() => _passwordFieldError = null);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('registerDisplayNameField'),
              controller: _displayNameController,
              decoration: InputDecoration(
                labelText: l10n.registerDisplayNameLabel,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.registerDateOfBirthLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              key: const Key('registerDateOfBirthButton'),
              onPressed: () => _pickDate(context),
              child: Text(
                _dateOfBirth == null
                    ? l10n.registerDateOfBirthHint
                    : _formatDate(_dateOfBirth!),
              ),
            ),
            if (_errorMessage case final error?) ...[
              const SizedBox(height: 16),
              ApiErrorDisplay(
                message: error,
                messageKey: const Key('registerErrorMessage'),
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
