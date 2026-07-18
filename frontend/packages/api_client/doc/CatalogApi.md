# api_client.api.CatalogApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createRecipe**](CatalogApi.md#createrecipe) | **POST** /recipes | Author a recipe in the caller&#39;s personal or bar library (T058, FR-018)
[**deleteRecipe**](CatalogApi.md#deleterecipe) | **DELETE** /recipes/{id} | Delete one of the caller&#39;s own authored recipes (T058, FR-018)
[**getConcept**](CatalogApi.md#getconcept) | **GET** /concepts/{id} | Get a concept page with its approved variant recipes (FR-021)
[**getRecipe**](CatalogApi.md#getrecipe) | **GET** /recipes/{id} | Get a recipe&#39;s full detail, including derived ABV/standard drinks/allergens (FR-022)
[**listConcepts**](CatalogApi.md#listconcepts) | **GET** /concepts | Browse concept pages (FR-021)
[**listRecipes**](CatalogApi.md#listrecipes) | **GET** /recipes | Browse/search recipes with content facets (FR-050)
[**updateRecipe**](CatalogApi.md#updaterecipe) | **PUT** /recipes/{id} | Update one of the caller&#39;s own authored recipes (T058, FR-018)


# **createRecipe**
> RecipeAuthor createRecipe(createRecipeRequest)

Author a recipe in the caller's personal or bar library (T058, FR-018)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getCatalogApi();
final CreateRecipeRequest createRecipeRequest = ; // CreateRecipeRequest | 

try {
    final response = api.createRecipe(createRecipeRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CatalogApi->createRecipe: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createRecipeRequest** | [**CreateRecipeRequest**](CreateRecipeRequest.md)|  | 

### Return type

[**RecipeAuthor**](RecipeAuthor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteRecipe**
> deleteRecipe(id)

Delete one of the caller's own authored recipes (T058, FR-018)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getCatalogApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deleteRecipe(id);
} on DioException catch (e) {
    print('Exception when calling CatalogApi->deleteRecipe: $e\n');
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

# **getConcept**
> ConceptDetail getConcept(id)

Get a concept page with its approved variant recipes (FR-021)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getCatalogApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getConcept(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CatalogApi->getConcept: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**ConceptDetail**](ConceptDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRecipe**
> RecipeDetail getRecipe(id)

Get a recipe's full detail, including derived ABV/standard drinks/allergens (FR-022)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getCatalogApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getRecipe(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CatalogApi->getRecipe: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RecipeDetail**](RecipeDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listConcepts**
> ConceptPage listConcepts(cursor, limit)

Browse concept pages (FR-021)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getCatalogApi();
final String cursor = cursor_example; // String | Opaque pagination cursor from a previous page's `nextCursor`.
final int limit = 56; // int | Maximum number of items to return.

try {
    final response = api.listConcepts(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CatalogApi->listConcepts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque pagination cursor from a previous page's `nextCursor`. | [optional] 
 **limit** | **int**| Maximum number of items to return. | [optional] [default to 20]

### Return type

[**ConceptPage**](ConceptPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listRecipes**
> RecipePage listRecipes(family, category, tag, flavorProfile, equipment, glassware, ice, uses, allergenExclude, source_, scope, cursor, limit)

Browse/search recipes with content facets (FR-050)

Guest-accessible (FR-004b). Only public/core recipes are returned — private personal-library recipes land with the personal-library story (US3). The rating and makeable-from-inventory facets are staged (T149/T148); ABV-range filtering computes ABV per candidate at request time rather than from a stored column, since ABV is always derived, never persisted (data-model.md).

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getCatalogApi();
final String family = family_example; // String | Family taxonomy key (e.g. \"family.sour\").
final String category = category_example; // String | 
final String tag = tag_example; // String | 
final String flavorProfile = flavorProfile_example; // String | 
final String equipment = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String glassware = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String ice = ice_example; // String | 
final String uses = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Hierarchy-aware \"uses:<ingredient>\" facet (T155/FR-050) — a class-level ingredient ID matches recipes using it or any descendant.
final String allergenExclude = allergenExclude_example; // String | Comma-separated allergen keys to exclude.
final String source_ = source__example; // String | 
final String scope = scope_example; // String | T058, FR-050 \"my library\" facet: the caller's own recipes in that library, regardless of visibility. Requires an authenticated caller (401 otherwise).
final String cursor = cursor_example; // String | Opaque pagination cursor from a previous page's `nextCursor`.
final int limit = 56; // int | Maximum number of items to return.

try {
    final response = api.listRecipes(family, category, tag, flavorProfile, equipment, glassware, ice, uses, allergenExclude, source_, scope, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CatalogApi->listRecipes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **family** | **String**| Family taxonomy key (e.g. \"family.sour\"). | [optional] 
 **category** | **String**|  | [optional] 
 **tag** | **String**|  | [optional] 
 **flavorProfile** | **String**|  | [optional] 
 **equipment** | **String**|  | [optional] 
 **glassware** | **String**|  | [optional] 
 **ice** | **String**|  | [optional] 
 **uses** | **String**| Hierarchy-aware \"uses:<ingredient>\" facet (T155/FR-050) — a class-level ingredient ID matches recipes using it or any descendant. | [optional] 
 **allergenExclude** | **String**| Comma-separated allergen keys to exclude. | [optional] 
 **source_** | **String**|  | [optional] 
 **scope** | **String**| T058, FR-050 \"my library\" facet: the caller's own recipes in that library, regardless of visibility. Requires an authenticated caller (401 otherwise). | [optional] 
 **cursor** | **String**| Opaque pagination cursor from a previous page's `nextCursor`. | [optional] 
 **limit** | **int**| Maximum number of items to return. | [optional] [default to 20]

### Return type

[**RecipePage**](RecipePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateRecipe**
> RecipeAuthor updateRecipe(id, updateRecipeRequest)

Update one of the caller's own authored recipes (T058, FR-018)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getCatalogApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UpdateRecipeRequest updateRecipeRequest = ; // UpdateRecipeRequest | 

try {
    final response = api.updateRecipe(id, updateRecipeRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CatalogApi->updateRecipe: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateRecipeRequest** | [**UpdateRecipeRequest**](UpdateRecipeRequest.md)|  | 

### Return type

[**RecipeAuthor**](RecipeAuthor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

