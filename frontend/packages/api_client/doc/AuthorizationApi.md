# api_client.api.AuthorizationApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMyEntitlements**](AuthorizationApi.md#getmyentitlements) | **GET** /me/entitlements | Get the caller&#39;s entitlement manifest


# **getMyEntitlements**
> EntitlementManifest getMyEntitlements()

Get the caller's entitlement manifest

Returns the caller's tier, the capabilities that tier grants, and any active platform-scope role grants (constitution Principle VI's three independent axes: tier, role, scope). Works for both anonymous callers (guest pseudo-tier floor, FR-004b) and authenticated users — there is no unauthorized case for this endpoint. The client uses this manifest to shape UI (e.g. show admin routes only when a role grant is present); enforcement itself always happens server-side.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getAuthorizationApi();

try {
    final response = api.getMyEntitlements();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthorizationApi->getMyEntitlements: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**EntitlementManifest**](EntitlementManifest.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

