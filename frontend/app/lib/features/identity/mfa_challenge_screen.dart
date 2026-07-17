// T050: shown when signIn() (or a social sign-in callback) reports
// requiresMfa=true. Submits the caller's TOTP code to complete sign-in.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/guest_gate/guest_gate.dart';
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/widgets/api_error_display.dart';

class MfaChallengeScreen extends ConsumerStatefulWidget {
  const MfaChallengeScreen({super.key});

  @override
  ConsumerState<MfaChallengeScreen> createState() => _MfaChallengeScreenState();
}

class _MfaChallengeScreenState extends ConsumerState<MfaChallengeScreen> {
  final _codeController = TextEditingController();
  String? _errorMessage;
  bool _submitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (_codeController.text.isEmpty) {
      setState(() => _errorMessage = l10n.mfaChallengeMissingCodeError);
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(identityAuthServiceProvider)
          .completeMfaSignIn(code: _codeController.text);

      if (!mounted) {
        return;
      }

      completePendingIntent(ref);
      if (context.canPop()) {
        context.pop();
      }
      context.go('/');
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
      key: const Key('mfaChallengeScreen'),
      appBar: AppBar(title: Text(l10n.mfaChallengeTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text(l10n.mfaChallengeBody),
            const SizedBox(height: 16),
            TextField(
              key: const Key('mfaChallengeCodeField'),
              controller: _codeController,
              decoration: InputDecoration(
                labelText: l10n.mfaChallengeCodeLabel,
              ),
              keyboardType: TextInputType.number,
            ),
            if (_errorMessage case final error?) ...[
              const SizedBox(height: 16),
              ApiErrorDisplay(
                message: error,
                messageKey: const Key('mfaChallengeErrorMessage'),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('mfaChallengeSubmitButton'),
              onPressed: _submitting ? null : _submit,
              child: Text(l10n.mfaChallengeSubmitButton),
            ),
          ],
        ),
      ),
    );
  }
}
