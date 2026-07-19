# api_client.api.InventoryApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createInventoryItem**](InventoryApi.md#createinventoryitem) | **POST** /inventory/items | Add an item to the caller&#39;s personal inventory, or a venue&#39;s inventory the caller owns (T066, FR-029/FR-030)
[**deleteInventoryItem**](InventoryApi.md#deleteinventoryitem) | **DELETE** /inventory/items/{id} | Remove one of the caller&#39;s own inventory items (T066, FR-029)
[**getInventoryItem**](InventoryApi.md#getinventoryitem) | **GET** /inventory/items/{id} | Get one of the caller&#39;s own inventory items by id (T066, FR-029)
[**getMakeableRecipes**](InventoryApi.md#getmakeablerecipes) | **GET** /inventory/makeable | \&quot;What can I make?\&quot; against the caller&#39;s personal inventory, with near-misses and substitutions (T067, FR-031)
[**listInventoryItems**](InventoryApi.md#listinventoryitems) | **GET** /inventory/items | List the caller&#39;s own inventory, or a venue&#39;s inventory the caller owns (T066, FR-029)
[**updateInventoryItem**](InventoryApi.md#updateinventoryitem) | **PUT** /inventory/items/{id} | Update the quantity/bottle size of one of the caller&#39;s own inventory items (T066, FR-029)


# **createInventoryItem**
> InventoryItem createInventoryItem(createInventoryItemRequest)

Add an item to the caller's personal inventory, or a venue's inventory the caller owns (T066, FR-029/FR-030)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getInventoryApi();
final CreateInventoryItemRequest createInventoryItemRequest = ; // CreateInventoryItemRequest | 

try {
    final response = api.createInventoryItem(createInventoryItemRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling InventoryApi->createInventoryItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createInventoryItemRequest** | [**CreateInventoryItemRequest**](CreateInventoryItemRequest.md)|  | 

### Return type

[**InventoryItem**](InventoryItem.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteInventoryItem**
> deleteInventoryItem(id)

Remove one of the caller's own inventory items (T066, FR-029)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getInventoryApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deleteInventoryItem(id);
} on DioException catch (e) {
    print('Exception when calling InventoryApi->deleteInventoryItem: $e\n');
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

# **getInventoryItem**
> InventoryItem getInventoryItem(id)

Get one of the caller's own inventory items by id (T066, FR-029)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getInventoryApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getInventoryItem(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling InventoryApi->getInventoryItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**InventoryItem**](InventoryItem.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMakeableRecipes**
> MakeableResponse getMakeableRecipes()

\"What can I make?\" against the caller's personal inventory, with near-misses and substitutions (T067, FR-031)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getInventoryApi();

try {
    final response = api.getMakeableRecipes();
    print(response);
} on DioException catch (e) {
    print('Exception when calling InventoryApi->getMakeableRecipes: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MakeableResponse**](MakeableResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listInventoryItems**
> InventoryItemPage listInventoryItems(venueId, cursor, limit)

List the caller's own inventory, or a venue's inventory the caller owns (T066, FR-029)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getInventoryApi();
final String venueId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | When present, lists that venue's inventory instead of the caller's personal inventory (403 if the caller doesn't own it).
final String cursor = cursor_example; // String | Opaque pagination cursor from a previous page's `nextCursor`.
final int limit = 56; // int | Maximum number of items to return.

try {
    final response = api.listInventoryItems(venueId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling InventoryApi->listInventoryItems: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **venueId** | **String**| When present, lists that venue's inventory instead of the caller's personal inventory (403 if the caller doesn't own it). | [optional] 
 **cursor** | **String**| Opaque pagination cursor from a previous page's `nextCursor`. | [optional] 
 **limit** | **int**| Maximum number of items to return. | [optional] [default to 20]

### Return type

[**InventoryItemPage**](InventoryItemPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateInventoryItem**
> InventoryItem updateInventoryItem(id, updateInventoryItemRequest)

Update the quantity/bottle size of one of the caller's own inventory items (T066, FR-029)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getInventoryApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UpdateInventoryItemRequest updateInventoryItemRequest = ; // UpdateInventoryItemRequest | 

try {
    final response = api.updateInventoryItem(id, updateInventoryItemRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling InventoryApi->updateInventoryItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateInventoryItemRequest** | [**UpdateInventoryItemRequest**](UpdateInventoryItemRequest.md)|  | 

### Return type

[**InventoryItem**](InventoryItem.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

