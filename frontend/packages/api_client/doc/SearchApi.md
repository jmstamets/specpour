# api_client.api.SearchApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**search**](SearchApi.md#search) | **GET** /search | Full-text search across recipes, ingredients, equipment, glossary terms, and articles (FR-049)


# **search**
> SearchResultPage search(q, uses, cursor, limit)

Full-text search across recipes, ingredients, equipment, glossary terms, and articles (FR-049)

Guest-accessible (FR-004b). Search itself owns no schema and has no opinion on content facets (T141 ADR) — this endpoint returns entity references only (`entityType`/`entityId`); fetch the full record from that entity's own GET-by-id endpoint. Content-facet filtering composition lands in T148/T149.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSearchApi();
final String q = q_example; // String | Free-text query (websearch_to_tsquery syntax).
final String uses = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Hierarchy-aware \"uses:<ingredient>\" facet (T155/FR-050), narrowing results to recipes referencing the ingredient (or any descendant). Applied after ranking/pagination — a page can return fewer than `limit` items when this facet removes matches.
final String cursor = cursor_example; // String | Opaque pagination cursor from a previous page's `nextCursor`.
final int limit = 56; // int | Maximum number of items to return.

try {
    final response = api.search(q, uses, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->search: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**| Free-text query (websearch_to_tsquery syntax). | [optional] 
 **uses** | **String**| Hierarchy-aware \"uses:<ingredient>\" facet (T155/FR-050), narrowing results to recipes referencing the ingredient (or any descendant). Applied after ranking/pagination — a page can return fewer than `limit` items when this facet removes matches. | [optional] 
 **cursor** | **String**| Opaque pagination cursor from a previous page's `nextCursor`. | [optional] 
 **limit** | **int**| Maximum number of items to return. | [optional] [default to 20]

### Return type

[**SearchResultPage**](SearchResultPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

