# api_client.api.ComplianceApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAgeGate**](ComplianceApi.md#getagegate) | **GET** /compliance/age-gate | Get the per-surface age-gate configuration and jurisdiction rule


# **getAgeGate**
> AgeGateResponse getAgeGate(surface)

Get the per-surface age-gate configuration and jurisdiction rule

Returns the requested surface's gate strictness plus the legal drinking age for the caller's coarse (IP-based) jurisdiction (R13, FR-002a). The client renders the DOB-entry gate and validates the entered value itself — DOB is never transmitted or stored (checked-never-stored, Principle XII data minimization); only a client-side \"affirmed\" flag persists locally. When the jurisdiction cannot be resolved (offline lookup failure, unknown IP range) or no jurisdiction-specific rule exists, the strictest known rule applies (`strictestRuleApplied: true`).

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getComplianceApi();
final String surface = surface_example; // String | The surface key requesting a gate decision (e.g. \"registration\", \"recipe_detail\").

try {
    final response = api.getAgeGate(surface);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ComplianceApi->getAgeGate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **surface** | **String**| The surface key requesting a gate decision (e.g. \"registration\", \"recipe_detail\"). | 

### Return type

[**AgeGateResponse**](AgeGateResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

