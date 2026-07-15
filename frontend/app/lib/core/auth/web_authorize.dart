// Web-only implementation of the ADR-0003 PKCE authorize step.
//
// On Flutter web the browser follows the /connect/authorize 302 opaquely and Dio
// discards the redirected URL (dio_web_adapter never surfaces xhr.responseURL /
// Response.url), so the Location-header approach used on native is impossible in a
// browser. Instead the client registers a same-origin no-op landing endpoint
// (TokenEndpoints' /connect/spa-callback) as its web redirect_uri, lets the browser
// follow the redirect via fetch, and reads the authorization code straight off the
// final redirected URL exposed by Response.url. Verified end-to-end in headless
// Chrome (2026-07-15) before shipping.

import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Drives GET [authorizeUrl] with credentials, follows the redirect, and returns
/// the `code` query parameter from the final (spa-callback) URL. Throws if no code
/// comes back (e.g. the caller isn't actually signed in, so /connect/authorize
/// challenged instead of redirecting).
Future<String> resolveAuthorizationCode(String authorizeUrl) async {
  final response = await web.window
      .fetch(authorizeUrl.toJS, web.RequestInit(credentials: 'include'))
      .toDart;

  final code = Uri.parse(response.url).queryParameters['code'];
  if (code == null || code.isEmpty) {
    throw StateError(
      'Sign-in did not complete: the authorization endpoint returned no code '
      '(final URL: ${response.url}).',
    );
  }
  return code;
}
