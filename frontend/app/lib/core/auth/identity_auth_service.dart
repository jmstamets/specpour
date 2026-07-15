// T047/T055/ADR-0003: registration and sign-in establish a cookie session
// (POST /auth/register, POST /auth/login — generated IdentityApi), then this
// service drives the standard authorization-code+PKCE exchange against
// /connect/authorize + /connect/token itself (no system browser/webview needed —
// the exchange reuses the same cookie via a shared CookieJar, see
// api_client_provider.dart's cookieJarProvider/authDioProvider). On success, the
// resulting access token is written to authTokenProvider, the same seam the rest
// of the app already reads bearer auth from.

import 'dart:convert';
import 'dart:math';

import 'package:api_client/api_client.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client_provider.dart';

/// Must exactly match a redirect URI OpenIddictClientSeedingHostedService
/// registered for the `specpour-app` client — never actually navigated to (the
/// PKCE exchange below intercepts the redirect via the Location header instead
/// of following it), so its value only matters as an exact-match key.
const _redirectUri = 'http://localhost:5173/callback';
const _clientId = 'specpour-app';
const _scope = 'openid email profile offline_access';

class IdentityAuthService {
  IdentityAuthService(
    this._identityApi,
    this._authDio,
    this._authToken,
    this._refreshToken,
    this._apiHostBaseUrl,
  );

  final IdentityApi _identityApi;
  final Dio _authDio;
  final AuthToken _authToken;
  final RefreshToken _refreshToken;
  final String _apiHostBaseUrl;

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required DateTime dateOfBirth,
    String? locale,
  }) async {
    await _identityApi.registerAccount(
      registerRequest: RegisterRequest(
        (b) => b
          ..email = email
          ..password = password
          ..displayName = displayName
          ..dateOfBirth = dateOfBirth.toDate()
          ..locale = locale,
      ),
    );
    await _completeTokenExchange();
  }

  /// T050: login is no longer always a straight sign-in — an MFA-enabled
  /// account gets parked in a short-lived server-side cookie instead, and the
  /// caller must submit a code via [completeMfaSignIn] to finish. The
  /// returned bool is true when that second step is needed.
  Future<bool> signIn({required String email, required String password}) async {
    final response = await _identityApi.login(
      loginRequest: LoginRequest(
        (b) => b
          ..email = email
          ..password = password,
      ),
    );

    if (response.data!.requiresMfa) {
      return true;
    }

    await _completeTokenExchange();
    return false;
  }

  /// Completes a sign-in that [signIn] (or a social sign-in's callback)
  /// reported as requiring an MFA code.
  Future<void> completeMfaSignIn({required String code}) async {
    await _identityApi.loginMfa(
      loginMfaRequest: LoginMfaRequest((b) => b..code = code),
    );
    await _completeTokenExchange();
  }

  Future<MfaStatus> mfaStatus() async {
    final response = await _identityApi.getMfaStatus();
    return response.data!;
  }

  /// Issues a new TOTP secret (Enabled=false) — call [confirmMfaEnrollment]
  /// with a code from the caller's authenticator app to actually enable it.
  Future<MfaEnrollment> startMfaEnrollment() async {
    final response = await _identityApi.enrollOrConfirmMfa();
    return response.data!;
  }

  Future<MfaEnrollment> confirmMfaEnrollment({required String code}) async {
    final response = await _identityApi.enrollOrConfirmMfa(
      enrollMfaRequest: EnrollMfaRequest((b) => b..code = code),
    );
    return response.data!;
  }

  Future<void> disableMfa() async {
    await _identityApi.disableMfa();
  }

  /// T163: invalidates every prior backup code and issues a fresh set of 10,
  /// shown exactly once in this response — same "shown once" handling the
  /// initial TOTP secret gets.
  Future<BackupCodes> regenerateBackupCodes() async {
    final response = await _identityApi.regenerateMfaBackupCodes();
    return response.data!;
  }

  /// T051: active sessions/devices, most recently active first.
  Future<List<Session>> listSessions() async {
    final response = await _identityApi.listMySessions();
    return response.data!.sessions.toList();
  }

  /// T051: revokes the underlying OpenIddict authorization for [sessionId] —
  /// that device's refresh capability stops working immediately (see
  /// IdentityModule.cs's SetAccessTokenLifetime doc comment for what "revoke"
  /// does and doesn't guarantee about an already-issued access token).
  Future<void> revokeSession({required String sessionId}) async {
    await _identityApi.revokeMySession(id: sessionId);
  }

  /// T052: signs the account out of every active session/device immediately;
  /// retained for an operator-configurable grace period before deletion.
  Future<void> deactivateAccount() async {
    await _identityApi.deactivateMyAccount();
  }

  /// T052: only meaningful with a fresh bearer token — deactivation revoked
  /// every prior session, so the caller must have signed in again first.
  Future<void> reactivateAccount() async {
    await _identityApi.reactivateMyAccount();
  }

  /// T053: the sole surface anywhere in the platform that returns the raw
  /// date of birth.
  Future<MeExport> exportAccountData() async {
    final response = await _identityApi.exportMyAccount();
    return response.data!;
  }

  /// T053: hard-deletes the account immediately. Callers should confirm with
  /// the user before invoking this — there is no undo.
  Future<void> deleteAccount() async {
    await _identityApi.deleteMyAccount();
    _authToken.set(null);
    _refreshToken.set(null);
  }

  Future<void> requestRecovery({required String email}) async {
    await _identityApi.requestAccountRecovery(
      recoveryRequest: RecoveryRequest((b) => b..email = email),
    );
  }

  Future<void> confirmRecovery({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    await _identityApi.confirmAccountRecovery(
      recoveryConfirmRequest: RecoveryConfirmRequest(
        (b) => b
          ..email = email
          ..token = token
          ..newPassword = newPassword,
      ),
    );
  }

  /// T049: the URL to navigate the WHOLE browser tab to (not a Dio call —
  /// this is a real cross-origin OAuth redirect the app must leave itself for;
  /// see the social sign-in button's use of url_launcher's webOnlyWindowName:
  /// '_self'). [redirectUri] is where the provider's callback eventually
  /// sends the browser back to — the app's own /auth/external/callback route.
  String socialSignInUrl({
    required String provider,
    required String redirectUri,
  }) {
    final uri = Uri.parse(
      '$_apiHostBaseUrl/api/v1/auth/external/$provider',
    ).replace(queryParameters: {'redirectUri': redirectUri});
    return uri.toString();
  }

  /// The social callback route calls this once it sees requiresMfa=false and
  /// no needsDateOfBirth flag: the backend already established the real
  /// cookie session, so only the PKCE exchange itself remains.
  Future<void> completeSocialSignIn() => _completeTokenExchange();

  /// Finishes a brand-new social account after the callback reported
  /// needsDateOfBirth=true — FR-002/FR-002c apply identically to social
  /// registration (spec.md US2), and no provider reliably supplies a DOB.
  Future<void> completeExternalRegistration({
    required DateTime dateOfBirth,
    required String displayName,
    String? locale,
  }) async {
    await _identityApi.completeExternalRegistration(
      completeExternalRegistrationRequest: CompleteExternalRegistrationRequest(
        (b) => b
          ..dateOfBirth = dateOfBirth.toDate()
          ..displayName = displayName
          ..locale = locale,
      ),
    );
    await _completeTokenExchange();
  }

  Future<void> _completeTokenExchange() async {
    final tokens = await _acquireTokens();
    _authToken.set(tokens.accessToken);
    _refreshToken.set(tokens.refreshToken);
  }

  Future<({String accessToken, String? refreshToken})> _acquireTokens() async {
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _codeChallengeFor(codeVerifier);

    final authorizeResponse = await _authDio.get<void>(
      '/connect/authorize',
      queryParameters: {
        'client_id': _clientId,
        'response_type': 'code',
        'redirect_uri': _redirectUri,
        'scope': _scope,
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
        'state': _generateCodeVerifier(),
      },
      options: Options(
        followRedirects: false,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    final location = authorizeResponse.headers.value('location');
    if (location == null) {
      throw StateError(
        '/connect/authorize did not redirect (status ${authorizeResponse.statusCode}) — is the caller actually signed in?',
      );
    }

    final code = Uri.parse(location).queryParameters['code'];
    if (code == null) {
      throw StateError('No authorization code in redirect: $location');
    }

    final tokenResponse = await _authDio.post<Map<String, dynamic>>(
      '/connect/token',
      data: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': _redirectUri,
        'client_id': _clientId,
        'code_verifier': codeVerifier,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    return (
      accessToken: tokenResponse.data!['access_token'] as String,
      refreshToken: tokenResponse.data!['refresh_token'] as String?,
    );
  }

  static String _generateCodeVerifier() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  static String _codeChallengeFor(String codeVerifier) {
    final digest = sha256.convert(ascii.encode(codeVerifier));
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }
}

final identityAuthServiceProvider = Provider<IdentityAuthService>(
  (ref) => IdentityAuthService(
    ref.watch(identityApiProvider),
    ref.watch(authDioProvider),
    ref.watch(authTokenProvider.notifier),
    ref.watch(refreshTokenProvider.notifier),
    ref.watch(apiHostBaseUrlProvider),
  ),
);

/// Extracts a human-readable message from a failed register/login call — the
/// backend returns RFC 9457 problem+json (e.g. underage rejection, bad
/// credentials); falls back to a generic message for anything unparseable.
String describeIdentityError(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      final title = data['title'];
      if (detail is String && detail.isNotEmpty) {
        return detail;
      }
      if (title is String && title.isNotEmpty) {
        return title;
      }
    }
  }

  return error.toString();
}
