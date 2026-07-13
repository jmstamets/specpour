# api_client.api.IdentityApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**login**](IdentityApi.md#login) | **POST** /auth/login | Email/password sign-in, establishing the cookie session (T047)
[**registerAccount**](IdentityApi.md#registeraccount) | **POST** /auth/register | Email/password registration with DOB capture and underage rejection (FR-001/FR-002/FR-002c, T047)


# **login**
> AuthAccount login(loginRequest)

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

[**AuthAccount**](AuthAccount.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
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

