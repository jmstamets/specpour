# api_client.api.EquipmentApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getEquipmentItem**](EquipmentApi.md#getequipmentitem) | **GET** /equipment/{id} | Get an equipment item&#39;s full detail (FR-024)
[**listEquipment**](EquipmentApi.md#listequipment) | **GET** /equipment | Browse equipment (FR-024)


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

