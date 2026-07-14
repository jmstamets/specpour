# api_client.api.IdentityApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**challengeExternalSignIn**](IdentityApi.md#challengeexternalsignin) | **GET** /auth/external/{provider} | Start social sign-in with a provider (T049)
[**completeExternalRegistration**](IdentityApi.md#completeexternalregistration) | **POST** /auth/external/complete-registration | Finish a new account after social sign-in supplied no date of birth (T049)
[**confirmAccountRecovery**](IdentityApi.md#confirmaccountrecovery) | **POST** /auth/recovery/confirm | Complete account recovery with the emailed code and a new password (T050)
[**deactivateMyAccount**](IdentityApi.md#deactivatemyaccount) | **POST** /me/deactivate | Deactivate the caller&#39;s account (T052)
[**deleteMyAccount**](IdentityApi.md#deletemyaccount) | **DELETE** /me | Delete the caller&#39;s account (T053)
[**disableMfa**](IdentityApi.md#disablemfa) | **DELETE** /me/mfa | Disable TOTP MFA (T050)
[**enrollOrConfirmMfa**](IdentityApi.md#enrollorconfirmmfa) | **POST** /me/mfa | Start or confirm TOTP MFA enrollment (T050)
[**exportMyAccount**](IdentityApi.md#exportmyaccount) | **GET** /me/export | Export the caller&#39;s account data (T053)
[**externalSignInCallback**](IdentityApi.md#externalsignincallback) | **GET** /auth/external/{provider}/callback | Provider redirect target — not called directly by clients (T049)
[**getMfaStatus**](IdentityApi.md#getmfastatus) | **GET** /me/mfa | Get the caller&#39;s TOTP MFA enrollment status (T050)
[**listMySessions**](IdentityApi.md#listmysessions) | **GET** /me/sessions | List the caller&#39;s active sessions/devices (T051)
[**login**](IdentityApi.md#login) | **POST** /auth/login | Email/password sign-in, establishing the cookie session (T047)
[**loginMfa**](IdentityApi.md#loginmfa) | **POST** /auth/login/mfa | Complete a sign-in that requiresMfa (T050)
[**reactivateMyAccount**](IdentityApi.md#reactivatemyaccount) | **POST** /me/reactivate | Reactivate the caller&#39;s deactivated account (T052)
[**regenerateMfaBackupCodes**](IdentityApi.md#regeneratemfabackupcodes) | **POST** /me/mfa/backup-codes | Regenerate the caller&#39;s MFA backup codes (T163)
[**registerAccount**](IdentityApi.md#registeraccount) | **POST** /auth/register | Email/password registration with DOB capture and underage rejection (FR-001/FR-002/FR-002c, T047)
[**requestAccountRecovery**](IdentityApi.md#requestaccountrecovery) | **POST** /auth/recovery | Request account recovery (T050, FR — lost-credential recovery)
[**revokeMySession**](IdentityApi.md#revokemysession) | **DELETE** /me/sessions/{id} | Revoke a session/device (T051)


# **challengeExternalSignIn**
> challengeExternalSignIn(provider, redirectUri)

Start social sign-in with a provider (T049)

Anonymous. A real browser-redirect OAuth handshake, not a \"submit a token you already have\" endpoint — redirects to the provider's own consent screen. The client opens this URL in a system browser/tab (not a WebView — providers discourage or block WebView-embedded sign-in) and waits for redirectUri to be hit. redirectUri receives requiresMfa=true|false on success, or needsDateOfBirth=true when this is a brand-new account (FR-002 requires a date of birth for every registration method — the caller must then call POST /auth/external/complete-registration), or error=external_auth_failed.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();
final String provider = provider_example; // String | 
final String redirectUri = redirectUri_example; // String | Where the browser ends up when the whole flow (including any DOB completion) is done.

try {
    api.challengeExternalSignIn(provider, redirectUri);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->challengeExternalSignIn: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider** | **String**|  | 
 **redirectUri** | **String**| Where the browser ends up when the whole flow (including any DOB completion) is done. | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **completeExternalRegistration**
> AuthAccount completeExternalRegistration(completeExternalRegistrationRequest)

Finish a new account after social sign-in supplied no date of birth (T049)

Anonymous — call this after the callback redirected with needsDateOfBirth=true. Reads the pending external identity from the short-lived cookie the callback step left in place; there is nothing else to authenticate this call with yet. Same FR-002c underage handling as POST /auth/register: nothing is persisted on rejection.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();
final CompleteExternalRegistrationRequest completeExternalRegistrationRequest = ; // CompleteExternalRegistrationRequest | 

try {
    final response = api.completeExternalRegistration(completeExternalRegistrationRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->completeExternalRegistration: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **completeExternalRegistrationRequest** | [**CompleteExternalRegistrationRequest**](CompleteExternalRegistrationRequest.md)|  | 

### Return type

[**AuthAccount**](AuthAccount.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmAccountRecovery**
> confirmAccountRecovery(recoveryConfirmRequest)

Complete account recovery with the emailed code and a new password (T050)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();
final RecoveryConfirmRequest recoveryConfirmRequest = ; // RecoveryConfirmRequest | 

try {
    api.confirmAccountRecovery(recoveryConfirmRequest);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->confirmAccountRecovery: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **recoveryConfirmRequest** | [**RecoveryConfirmRequest**](RecoveryConfirmRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deactivateMyAccount**
> deactivateMyAccount()

Deactivate the caller's account (T052)

Signs the account out of every active session/device immediately. Retained for an operator-configurable grace period (default 12 months, FR-003) during which the caller can reactivate; a warning is sent before expiry, after which the account is automatically deleted via the same path as DELETE /me.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();

try {
    api.deactivateMyAccount();
} on DioException catch (e) {
    print('Exception when calling IdentityApi->deactivateMyAccount: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteMyAccount**
> deleteMyAccount()

Delete the caller's account (T053)

Hard-deletes the account immediately (self-service path) — the same AccountDeletionService used by T052's grace-period-expiry background job. Cascades to MFA enrollment/backup codes/sessions via real foreign keys; publishes AccountDeleted for the future Community module's public-attribution anonymization.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();

try {
    api.deleteMyAccount();
} on DioException catch (e) {
    print('Exception when calling IdentityApi->deleteMyAccount: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **disableMfa**
> disableMfa()

Disable TOTP MFA (T050)

Also clears any backup codes (T163) — they're meaningless without an active enrollment.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();

try {
    api.disableMfa();
} on DioException catch (e) {
    print('Exception when calling IdentityApi->disableMfa: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **enrollOrConfirmMfa**
> MfaEnrollment enrollOrConfirmMfa(enrollMfaRequest)

Start or confirm TOTP MFA enrollment (T050)

Two-phase over a single endpoint: an empty/no-code body starts enrollment (issues a new secret + otpauth:// URI for the caller's authenticator app); a body carrying the 6-digit code confirms the most recently issued secret and enables MFA. The secret/URI are returned only from the start-enrollment response; the one-time backup-code set (T163) is returned only from the response that actually enables MFA. Neither is ever shown again afterward — POST /me/mfa/backup-codes issues a fresh set if the caller needs one later.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();
final EnrollMfaRequest enrollMfaRequest = ; // EnrollMfaRequest | 

try {
    final response = api.enrollOrConfirmMfa(enrollMfaRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->enrollOrConfirmMfa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enrollMfaRequest** | [**EnrollMfaRequest**](EnrollMfaRequest.md)|  | [optional] 

### Return type

[**MfaEnrollment**](MfaEnrollment.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **exportMyAccount**
> MeExport exportMyAccount()

Export the caller's account data (T053)

The sole surface anywhere in the platform that returns the raw date of birth (FR-002b/SC-017) — every call is audit-logged (identity.dob_exported).

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();

try {
    final response = api.exportMyAccount();
    print(response);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->exportMyAccount: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MeExport**](MeExport.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **externalSignInCallback**
> externalSignInCallback(provider)

Provider redirect target — not called directly by clients (T049)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();
final String provider = provider_example; // String | 

try {
    api.externalSignInCallback(provider);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->externalSignInCallback: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMfaStatus**
> MfaStatus getMfaStatus()

Get the caller's TOTP MFA enrollment status (T050)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();

try {
    final response = api.getMfaStatus();
    print(response);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->getMfaStatus: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MfaStatus**](MfaStatus.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMySessions**
> SessionList listMySessions()

List the caller's active sessions/devices (T051)

A \"session\" is one OpenIddict authorization — created the first time a device completes the PKCE exchange, refreshed on every subsequent token refresh. Revoked sessions are omitted (not just flagged) since there is nothing further the caller can do with one.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();

try {
    final response = api.listMySessions();
    print(response);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->listMySessions: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SessionList**](SessionList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **login**
> LoginResult login(loginRequest)

Email/password sign-in, establishing the cookie session (T047)

Anonymous. On success, establishes the caller's cookie session (ADR-0003); the client then completes the standard authorization-code+PKCE exchange to obtain API access/refresh tokens, same as registration.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();
final LoginRequest loginRequest = ; // LoginRequest | 

try {
    final response = api.login(loginRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->login: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)|  | 

### Return type

[**LoginResult**](LoginResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **loginMfa**
> AuthAccount loginMfa(loginMfaRequest)

Complete a sign-in that requiresMfa (T050)

Anonymous (the caller isn't authenticated yet — the interim state is carried by a short-lived cookie login set, not a bearer token). Call this after a login response with requiresMfa=true, submitting the current 6-digit code from the caller's authenticator app.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();
final LoginMfaRequest loginMfaRequest = ; // LoginMfaRequest | 

try {
    final response = api.loginMfa(loginMfaRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->loginMfa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginMfaRequest** | [**LoginMfaRequest**](LoginMfaRequest.md)|  | 

### Return type

[**AuthAccount**](AuthAccount.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reactivateMyAccount**
> reactivateMyAccount()

Reactivate the caller's deactivated account (T052)

Only meaningful once the caller has a fresh, valid bearer token — deactivation revokes every prior session, so reactivating requires signing in again first.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();

try {
    api.reactivateMyAccount();
} on DioException catch (e) {
    print('Exception when calling IdentityApi->reactivateMyAccount: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **regenerateMfaBackupCodes**
> BackupCodes regenerateMfaBackupCodes()

Regenerate the caller's MFA backup codes (T163)

Invalidates every prior backup code (used or not) and issues a fresh set of 10. Requires MFA to already be enabled — there is nothing to recover into otherwise. Codes are shown exactly once, in this response.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();

try {
    final response = api.regenerateMfaBackupCodes();
    print(response);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->regenerateMfaBackupCodes: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BackupCodes**](BackupCodes.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerAccount**
> AuthAccount registerAccount(registerRequest)

Email/password registration with DOB capture and underage rejection (FR-001/FR-002/FR-002c, T047)

Anonymous. Rejects underage attempts with 403 and persists nothing (no DOB, no identifying record of the attempt) — FR-002c. On success, establishes the caller's cookie session (ADR-0003); the client then completes the standard authorization-code+PKCE exchange against /connect/authorize and /connect/token to obtain API access/refresh tokens — this endpoint never returns a token directly.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();
final RegisterRequest registerRequest = ; // RegisterRequest | 

try {
    final response = api.registerAccount(registerRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->registerAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerRequest** | [**RegisterRequest**](RegisterRequest.md)|  | 

### Return type

[**AuthAccount**](AuthAccount.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestAccountRecovery**
> requestAccountRecovery(recoveryRequest)

Request account recovery (T050, FR — lost-credential recovery)

Anonymous. Always returns 202 regardless of whether the email matches an account, to avoid account enumeration. If it matches, an email with a recovery code is sent via the notifications email channel.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();
final RecoveryRequest recoveryRequest = ; // RecoveryRequest | 

try {
    api.requestAccountRecovery(recoveryRequest);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->requestAccountRecovery: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **recoveryRequest** | [**RecoveryRequest**](RecoveryRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **revokeMySession**
> revokeMySession(id)

Revoke a session/device (T051)

Revokes the underlying OpenIddict authorization directly — the whole refresh-token family for that device stops working immediately, not just this one call's session-list visibility.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIdentityApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.revokeMySession(id);
} on DioException catch (e) {
    print('Exception when calling IdentityApi->revokeMySession: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

