# api_client.api.IngredientsApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createIngredient**](IngredientsApi.md#createingredient) | **POST** /ingredients | Author an ingredient in the caller&#39;s personal or bar library, optionally house-made (T059, FR-012/FR-017)
[**deleteIngredient**](IngredientsApi.md#deleteingredient) | **DELETE** /ingredients/{id} | Delete one of the caller&#39;s own authored ingredients (T059)
[**getIngredient**](IngredientsApi.md#getingredient) | **GET** /ingredients/{id} | Get an ingredient&#39;s full detail, including allergen attributes (FR-016)
[**getIngredientRecipes**](IngredientsApi.md#getingredientrecipes) | **GET** /ingredients/{id}/recipes | Recipes using this ingredient, hierarchy-aware (T155, FR-014a)
[**listIngredients**](IngredientsApi.md#listingredients) | **GET** /ingredients | Browse ingredients (FR-014)
[**updateIngredient**](IngredientsApi.md#updateingredient) | **PUT** /ingredients/{id} | Update one of the caller&#39;s own authored ingredients (T059, FR-012/FR-017)


# **createIngredient**
> IngredientAuthor createIngredient(createIngredientRequest)

Author an ingredient in the caller's personal or bar library, optionally house-made (T059, FR-012/FR-017)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIngredientsApi();
final CreateIngredientRequest createIngredientRequest = ; // CreateIngredientRequest | 

try {
    final response = api.createIngredient(createIngredientRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IngredientsApi->createIngredient: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createIngredientRequest** | [**CreateIngredientRequest**](CreateIngredientRequest.md)|  | 

### Return type

[**IngredientAuthor**](IngredientAuthor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteIngredient**
> deleteIngredient(id)

Delete one of the caller's own authored ingredients (T059)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIngredientsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deleteIngredient(id);
} on DioException catch (e) {
    print('Exception when calling IngredientsApi->deleteIngredient: $e\n');
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

# **getIngredient**
> IngredientDetail getIngredient(id)

Get an ingredient's full detail, including allergen attributes (FR-016)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIngredientsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getIngredient(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IngredientsApi->getIngredient: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**IngredientDetail**](IngredientDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getIngredientRecipes**
> IngredientRecipes getIngredientRecipes(id)

Recipes using this ingredient, hierarchy-aware (T155, FR-014a)

A class-level ingredient (e.g. \"Rum\") lists recipes using it or any descendant (\"Aged Rum\", \"White Rum\", ...) — mirrors FR-024's equipment-to-recipes linking. Unpaginated: a single ingredient's usage list is small at V1 scale.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIngredientsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getIngredientRecipes(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IngredientsApi->getIngredientRecipes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**IngredientRecipes**](IngredientRecipes.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listIngredients**
> IngredientPage listIngredients(category, cursor, limit)

Browse ingredients (FR-014)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIngredientsApi();
final String category = category_example; // String | 
final String cursor = cursor_example; // String | Opaque pagination cursor from a previous page's `nextCursor`.
final int limit = 56; // int | Maximum number of items to return.

try {
    final response = api.listIngredients(category, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IngredientsApi->listIngredients: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **category** | **String**|  | [optional] 
 **cursor** | **String**| Opaque pagination cursor from a previous page's `nextCursor`. | [optional] 
 **limit** | **int**| Maximum number of items to return. | [optional] [default to 20]

### Return type

[**IngredientPage**](IngredientPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateIngredient**
> IngredientAuthor updateIngredient(id, updateIngredientRequest)

Update one of the caller's own authored ingredients (T059, FR-012/FR-017)

Rejects (400) a house-made defining recipe change that would transitively include this ingredient itself (FR-017's circular-reference edge case).

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getIngredientsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UpdateIngredientRequest updateIngredientRequest = ; // UpdateIngredientRequest | 

try {
    final response = api.updateIngredient(id, updateIngredientRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IngredientsApi->updateIngredient: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateIngredientRequest** | [**UpdateIngredientRequest**](UpdateIngredientRequest.md)|  | 

### Return type

[**IngredientAuthor**](IngredientAuthor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

