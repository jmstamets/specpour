// T049: shared Google/Apple/Microsoft sign-in buttons for SignInScreen and
// RegisterScreen. Launching one navigates the WHOLE browser tab to the
// backend's OAuth challenge endpoint — this is a real cross-origin redirect
// handshake, not something Dio can drive; url_launcher's webOnlyWindowName:
// '_self' does that navigation on web.

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/l10n/gen/app_localizations.dart';

class SocialSignInButtons extends ConsumerWidget {
  const SocialSignInButtons({super.key});

  static const _callbackPath = '/auth/external/callback';

  String _resolveCallbackUri() {
    if (kIsWeb) {
      return Uri.base.replace(path: _callbackPath, query: '').toString();
    }

    // Native deep-linking (e.g. a registered specpour:// scheme) needs
    // platform manifest/Info.plist wiring this sandbox can't build or verify
    // (only the web target is buildable/servable here) — flagged rather than
    // silently producing a broken redirect.
    throw UnsupportedError(
      'Native social sign-in needs a registered app deep link — not wired up yet.',
    );
  }

  Future<void> _launch(BuildContext context, WidgetRef ref, String provider) async {
    final redirectUri = _resolveCallbackUri();
    final url = ref
        .read(identityAuthServiceProvider)
        .socialSignInUrl(provider: provider, redirectUri: redirectUri);

    await launchUrl(Uri.parse(url), webOnlyWindowName: '_self');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(l10n.socialSignInDivider),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          key: const Key('socialSignInGoogleButton'),
          onPressed: () => _launch(context, ref, 'google'),
          child: Text(l10n.socialSignInGoogleButton),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          key: const Key('socialSignInAppleButton'),
          onPressed: () => _launch(context, ref, 'apple'),
          child: Text(l10n.socialSignInAppleButton),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          key: const Key('socialSignInMicrosoftButton'),
          onPressed: () => _launch(context, ref, 'microsoft'),
          child: Text(l10n.socialSignInMicrosoftButton),
        ),
      ],
    );
  }
}
