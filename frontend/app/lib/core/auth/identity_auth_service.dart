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
  IdentityAuthService(this._identityApi, this._authDio, this._authToken);

  final IdentityApi _identityApi;
  final Dio _authDio;
  final AuthToken _authToken;

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

  Future<void> signIn({required String email, required String password}) async {
    await _identityApi.login(
      loginRequest: LoginRequest((b) => b
        ..email = email
        ..password = password),
    );
    await _completeTokenExchange();
  }

  Future<void> _completeTokenExchange() async {
    final accessToken = await _acquireAccessToken();
    _authToken.set(accessToken);
  }

  Future<String> _acquireAccessToken() async {
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

    return tokenResponse.data!['access_token'] as String;
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
