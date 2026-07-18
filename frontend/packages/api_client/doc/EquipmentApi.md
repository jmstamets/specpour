# api_client.api.EquipmentApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createEquipment**](EquipmentApi.md#createequipment) | **POST** /equipment | Author an equipment item in the caller&#39;s personal or bar library (T060, FR-024)
[**deleteEquipmentItem**](EquipmentApi.md#deleteequipmentitem) | **DELETE** /equipment/{id} | Delete one of the caller&#39;s own authored equipment items (T060)
[**getEquipmentItem**](EquipmentApi.md#getequipmentitem) | **GET** /equipment/{id} | Get an equipment item&#39;s full detail (FR-024)
[**listEquipment**](EquipmentApi.md#listequipment) | **GET** /equipment | Browse equipment (FR-024)
[**updateEquipmentItem**](EquipmentApi.md#updateequipmentitem) | **PUT** /equipment/{id} | Update one of the caller&#39;s own authored equipment items (T060, FR-024)


# **createEquipment**
> EquipmentAuthor createEquipment(createEquipmentRequest)

Author an equipment item in the caller's personal or bar library (T060, FR-024)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getEquipmentApi();
final CreateEquipmentRequest createEquipmentRequest = ; // CreateEquipmentRequest | 

try {
    final response = api.createEquipment(createEquipmentRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EquipmentApi->createEquipment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createEquipmentRequest** | [**CreateEquipmentRequest**](CreateEquipmentRequest.md)|  | 

### Return type

[**EquipmentAuthor**](EquipmentAuthor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteEquipmentItem**
> deleteEquipmentItem(id)

Delete one of the caller's own authored equipment items (T060)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getEquipmentApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deleteEquipmentItem(id);
} on DioException catch (e) {
    print('Exception when calling EquipmentApi->deleteEquipmentItem: $e\n');
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

# **getEquipmentItem**
> EquipmentDetail getEquipmentItem(id)

Get an equipment item's full detail (FR-024)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getEquipmentApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getEquipmentItem(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EquipmentApi->getEquipmentItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**EquipmentDetail**](EquipmentDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listEquipment**
> EquipmentPage listEquipment(cursor, limit)

Browse equipment (FR-024)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getEquipmentApi();
final String cursor = cursor_example; // String | Opaque pagination cursor from a previous page's `nextCursor`.
final int limit = 56; // int | Maximum number of items to return.

try {
    final response = api.listEquipment(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EquipmentApi->listEquipment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque pagination cursor from a previous page's `nextCursor`. | [optional] 
 **limit** | **int**| Maximum number of items to return. | [optional] [default to 20]

### Return type

[**EquipmentPage**](EquipmentPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateEquipmentItem**
> EquipmentAuthor updateEquipmentItem(id, updateEquipmentRequest)

Update one of the caller's own authored equipment items (T060, FR-024)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getEquipmentApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UpdateEquipmentRequest updateEquipmentRequest = ; // UpdateEquipmentRequest | 

try {
    final response = api.updateEquipmentItem(id, updateEquipmentRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EquipmentApi->updateEquipmentItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateEquipmentRequest** | [**UpdateEquipmentRequest**](UpdateEquipmentRequest.md)|  | 

### Return type

[**EquipmentAuthor**](EquipmentAuthor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

