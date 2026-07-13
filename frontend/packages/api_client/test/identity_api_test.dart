import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for IdentityApi
void main() {
  final instance = ApiClient().getIdentityApi();

  group(IdentityApi, () {
    // Email/password sign-in, establishing the cookie session (T047)
    //
    // Anonymous. On success, establishes the caller's cookie session (ADR-0003); the client then completes the standard authorization-code+PKCE exchange to obtain API access/refresh tokens, same as registration.
    //
    //Future<AuthAccount> login(LoginRequest loginRequest) async
    test('test login', () async {
      // TODO
    });

    // Email/password registration with DOB capture and underage rejection (FR-001/FR-002/FR-002c, T047)
    //
    // Anonymous. Rejects underage attempts with 403 and persists nothing (no DOB, no identifying record of the attempt) — FR-002c. On success, establishes the caller's cookie session (ADR-0003); the client then completes the standard authorization-code+PKCE exchange against /connect/authorize and /connect/token to obtain API access/refresh tokens — this endpoint never returns a token directly.
    //
    //Future<AuthAccount> registerAccount(RegisterRequest registerRequest) async
    test('test registerAccount', () async {
      // TODO
    });

  });
}
