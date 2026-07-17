// T049: the redirectUri social sign-in buttons send the browser to — reads
// the query params ExternalAuthEndpoints.CallbackAsync appended and routes
// accordingly. Never navigated to directly by the app itself.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/guest_gate/guest_gate.dart';
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/widgets/api_error_display.dart';

class ExternalSignInCallbackScreen extends ConsumerStatefulWidget {
  const ExternalSignInCallbackScreen({
    required this.queryParameters,
    super.key,
  });

  final Map<String, String> queryParameters;

  @override
  ConsumerState<ExternalSignInCallbackScreen> createState() =>
      _ExternalSignInCallbackScreenState();
}

class _ExternalSignInCallbackScreenState
    extends ConsumerState<ExternalSignInCallbackScreen> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    Future.microtask(_process);
  }

  Future<void> _process() async {
    if (widget.queryParameters['error'] != null) {
      setState(
        () => _errorMessage = AppLocalizations.of(
          context,
        ).externalCallbackErrorMessage,
      );
      return;
    }

    if (widget.queryParameters['needsDateOfBirth'] == 'true') {
      if (mounted) {
        context.go('/auth/external/complete-registration');
      }
      return;
    }

    if (widget.queryParameters['requiresMfa'] == 'true') {
      if (mounted) {
        context.go('/mfa-challenge');
      }
      return;
    }

    try {
      await ref.read(identityAuthServiceProvider).completeSocialSignIn();
      if (!mounted) {
        return;
      }
      completePendingIntent(ref);
      context.go('/');
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = describeIdentityError(error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final error = _errorMessage;

    return Scaffold(
      key: const Key('externalSignInCallbackScreen'),
      body: Center(
        child: error != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ApiErrorDisplay(
                    message: error,
                    messageKey: const Key('externalCallbackErrorMessage'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/sign-in'),
                    child: Text(l10n.signInTitle),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l10n.externalCallbackProcessingMessage),
                ],
              ),
      ),
    );
  }
}
