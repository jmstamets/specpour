// Non-web stub for web_authorize.dart. Native platforms use the custom-scheme
// redirect and read the Location header directly (see IdentityAuthService), so this
// path is never taken off web; it exists only so the conditional import compiles.

Future<String> resolveAuthorizationCode(
  String authorizeUrl,
  String expectedState,
) {
  throw UnsupportedError(
    'resolveAuthorizationCode is web-only; native uses the custom-scheme redirect.',
  );
}
