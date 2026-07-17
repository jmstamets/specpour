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
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client_provider.dart';
import 'web_authorize_stub.dart'
    if (dart.library.js_interop) 'web_authorize.dart';

/// The native (custom-scheme) redirect URI. On web the redirect URI is instead the
/// API's same-origin /connect/spa-callback endpoint, computed at runtime from the
/// API host (see [IdentityAuthService._redirectUri]) so nothing is hardcoded to a
/// served origin. Both must be registered for the `specpour-app` client
/// (OpenIddictClientSeedingHostedService).
const _nativeRedirectUri = 'com.specpour.app://callback';
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

  /// T173: which social providers are actually configured — a login screen
  /// renders a provider's button only if its key appears here, so it never
  /// shows a button that would 400 "unknown provider" when tapped.
  Future<Set<String>> configuredExternalProviders() async {
    final response = await _identityApi.listExternalProviders();
    return response.data!.providers.map((p) => p.name).toSet();
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

  /// The redirect URI for the current platform. On web it's the API's own
  /// /connect/spa-callback (see web_authorize.dart for why); on native it's the
  /// registered custom scheme. Must match between the authorize request and the
  /// token exchange (OAuth requirement).
  String get _redirectUri =>
      kIsWeb ? '$_apiHostBaseUrl/connect/spa-callback' : _nativeRedirectUri;

  Future<({String accessToken, String? refreshToken})> _acquireTokens() async {
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _codeChallengeFor(codeVerifier);
    final state = _generateCodeVerifier();
    final query = {
      'client_id': _clientId,
      'response_type': 'code',
      'redirect_uri': _redirectUri,
      'scope': _scope,
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
      'state': state,
    };

    final String code;
    if (kIsWeb) {
      // Web: let the browser follow the redirect and read the code off the final
      // URL — Dio can't read a followed redirect's Location on web. See
      // web_authorize.dart. State is validated there (T174).
      final authorizeUrl = Uri.parse(
        '$_apiHostBaseUrl/connect/authorize',
      ).replace(queryParameters: query).toString();
      code = await resolveAuthorizationCode(authorizeUrl, state);
    } else {
      // Native: honor followRedirects:false and read the Location header.
      final authorizeResponse = await _authDio.get<void>(
        '/connect/authorize',
        queryParameters: query,
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

      final parsed = Uri.parse(location).queryParameters['code'];
      if (parsed == null) {
        throw StateError('No authorization code in redirect: $location');
      }
      code = parsed;
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

/// A friendly message plus (only for unexpected/server-side failures) a
/// correlation ID the user can quote to support — see [describeApiError].
class ApiErrorPresentation {
  const ApiErrorPresentation({required this.message, this.correlationId});

  final String message;
  final String? correlationId;
}

const _genericServerErrorMessage =
    'Something went wrong on our end. Please try again in a moment.';
const _genericNetworkErrorMessage =
    'Could not reach the server. Check your connection and try again.';

/// T170 (Phase 4 walkthrough finding #2): raw exceptions must never render to
/// users — the walkthrough caught Dio's internal `[connection error]` text
/// rendering verbatim in the register form. The backend returns RFC 9457
/// problem+json on every non-2xx response (`AddSpecPourProblemDetails`,
/// always carrying a `correlationId` extension); this is the single funnel
/// every screen's catch block already goes through.
///
/// 5xx (and anything without a parseable body — including a network-level
/// failure with no response at all, or Development's
/// `UseDeveloperExceptionPage` HTML page, which isn't JSON) is treated as an
/// UNEXPECTED failure: never trust its body to be safe to show verbatim,
/// always the generic message, with the correlation ID surfaced so a
/// walkthrough/support report can be matched to server logs. 4xx responses
/// are EXPECTED, actionable failures (bad password, underage, etc.) — their
/// `detail`/`title` is already a friendly, specific message, and no
/// correlation ID is shown for them (per this task's own scoping: unexpected
/// failures get the ID, not routine validation).
ApiErrorPresentation describeApiError(Object error) {
  if (error is DioException) {
    final response = error.response;
    if (response == null) {
      return const ApiErrorPresentation(message: _genericNetworkErrorMessage);
    }

    final status = response.statusCode ?? 0;
    final data = response.data;
    final correlationId = data is Map<String, dynamic>
        ? data['correlationId'] as String?
        : null;

    if (status >= 500) {
      return ApiErrorPresentation(
        message: _genericServerErrorMessage,
        correlationId: correlationId,
      );
    }

    if (data is Map<String, dynamic>) {
      final fieldMessages = _fieldErrorMessages(data['errors']);
      if (fieldMessages != null) {
        return ApiErrorPresentation(message: fieldMessages);
      }
      final detail = data['detail'];
      if (detail is String && detail.isNotEmpty) {
        return ApiErrorPresentation(message: detail);
      }
      final title = data['title'];
      if (title is String && title.isNotEmpty) {
        return ApiErrorPresentation(message: title);
      }
    }
  }

  return const ApiErrorPresentation(message: _genericServerErrorMessage);
}

/// ASP.NET Core's ValidationProblemDetails `errors` extension shape
/// (`{field: [messages]}`) — no endpoint in this codebase populates it today
/// (validation failures currently join into a single `detail` string
/// instead), but this funnel handles it defensively since every screen
/// already goes through it.
String? _fieldErrorMessages(Object? errors) {
  if (errors is! Map) {
    return null;
  }
  final messages = errors.values
      .whereType<List<dynamic>>()
      .expand((list) => list.whereType<String>())
      .toList();
  return messages.isEmpty ? null : messages.join(' ');
}

/// String-returning convenience wrapper for existing call sites — the
/// correlation ID (when present) is appended inline for now; a selectable/
/// copyable presentation with its own copy button lands in T172.
String describeIdentityError(Object error) {
  final result = describeApiError(error);
  if (result.correlationId case final id?) {
    return '${result.message} (Reference: $id)';
  }
  return result.message;
}
