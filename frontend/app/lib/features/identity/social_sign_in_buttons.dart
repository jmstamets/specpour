// T049: shared Google/Apple/Microsoft sign-in buttons for SignInScreen and
// RegisterScreen. Launching one navigates the WHOLE browser tab to the
// backend's OAuth challenge endpoint — this is a real cross-origin redirect
// handshake, not something Dio can drive; url_launcher's webOnlyWindowName:
// '_self' does that navigation on web.
//
// T173: a provider's button only renders if it's actually configured
// (IdentityModule only registers a provider's handler when its ClientId is
// set) — GET /auth/external/providers is the source of truth, fetched once
// per screen mount. Zero configured providers omits the whole section,
// including the "or" divider, rather than showing a dead-end row of buttons
// that would all 400 "unknown provider."

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/l10n/gen/app_localizations.dart';

final configuredExternalProvidersProvider =
    FutureProvider.autoDispose<Set<String>>(
      (ref) =>
          ref.read(identityAuthServiceProvider).configuredExternalProviders(),
    );

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

  Future<void> _launch(
    BuildContext context,
    WidgetRef ref,
    String provider,
  ) async {
    final redirectUri = _resolveCallbackUri();
    final url = ref
        .read(identityAuthServiceProvider)
        .socialSignInUrl(provider: provider, redirectUri: redirectUri);

    await launchUrl(Uri.parse(url), webOnlyWindowName: '_self');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final providersAsync = ref.watch(configuredExternalProvidersProvider);

    return providersAsync.when(
      // A transient loading/error state renders nothing rather than a flash
      // of dead buttons — the section fades in once the real configured set
      // is known, same "never show what might 400" rule as the empty-set
      // case below.
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (providers) {
        final buttons = <Widget>[
          if (providers.contains('google'))
            OutlinedButton(
              key: const Key('socialSignInGoogleButton'),
              onPressed: () => _launch(context, ref, 'google'),
              child: Text(l10n.socialSignInGoogleButton),
            ),
          if (providers.contains('apple'))
            OutlinedButton(
              key: const Key('socialSignInAppleButton'),
              onPressed: () => _launch(context, ref, 'apple'),
              child: Text(l10n.socialSignInAppleButton),
            ),
          if (providers.contains('microsoft'))
            OutlinedButton(
              key: const Key('socialSignInMicrosoftButton'),
              onPressed: () => _launch(context, ref, 'microsoft'),
              child: Text(l10n.socialSignInMicrosoftButton),
            ),
        ];

        if (buttons.isEmpty) {
          return const SizedBox.shrink();
        }

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
            for (final (index, button) in buttons.indexed) ...[
              if (index > 0) const SizedBox(height: 8),
              button,
            ],
          ],
        );
      },
    );
  }
}
