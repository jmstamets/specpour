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
> SearchResultPage search(q, uses, makeable, cursor, limit)

Full-text search across recipes, ingredients, equipment, glossary terms, and articles (FR-049)

Guest-accessible (FR-004b) unless `makeable=true` is used. Search itself owns no schema and has no opinion on content facets (T141 ADR) — this endpoint returns entity references only (`entityType`/`entityId`); fetch the full record from that entity's own GET-by-id endpoint. Rating-facet composition lands in T149. `q` returning nothing is a pre-existing adapter limitation, not a facet bug — this endpoint requires non-empty text; browsing (no `q`) is `GET /recipes`'s job, not this one's.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSearchApi();
final String q = q_example; // String | Free-text query (websearch_to_tsquery syntax).
final String uses = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Hierarchy-aware \"uses:<ingredient>\" facet (T155/FR-050), narrowing results to recipes referencing the ingredient (or any descendant). Applied INSIDE the search adapter's own query, before pagination (T148 — previously a post-filter that could shrink a page below `limit`).
final String makeable = makeable_example; // String | Makeable-from-inventory facet (T148, FR-050) — bearer-only (401 if not authenticated). Narrows recipe-type results to the caller's own fully-makeable and near-miss recipes, applied the same way as `uses` (inside the adapter's query, before pagination). Combining `uses` and `makeable` intersects (both must match). Only public recipes are ever reachable via this endpoint (unlike `GET /recipes`'s `scope`/`makeable`, which also surfaces the caller's own private recipes) — Search's index only ever carries public content.
final String cursor = cursor_example; // String | Opaque pagination cursor from a previous page's `nextCursor`.
final int limit = 56; // int | Maximum number of items to return.

try {
    final response = api.search(q, uses, makeable, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->search: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**| Free-text query (websearch_to_tsquery syntax). | [optional] 
 **uses** | **String**| Hierarchy-aware \"uses:<ingredient>\" facet (T155/FR-050), narrowing results to recipes referencing the ingredient (or any descendant). Applied INSIDE the search adapter's own query, before pagination (T148 — previously a post-filter that could shrink a page below `limit`). | [optional] 
 **makeable** | **String**| Makeable-from-inventory facet (T148, FR-050) — bearer-only (401 if not authenticated). Narrows recipe-type results to the caller's own fully-makeable and near-miss recipes, applied the same way as `uses` (inside the adapter's query, before pagination). Combining `uses` and `makeable` intersects (both must match). Only public recipes are ever reachable via this endpoint (unlike `GET /recipes`'s `scope`/`makeable`, which also surfaces the caller's own private recipes) — Search's index only ever carries public content. | [optional] 
 **cursor** | **String**| Opaque pagination cursor from a previous page's `nextCursor`. | [optional] 
 **limit** | **int**| Maximum number of items to return. | [optional] [default to 20]

### Return type

[**SearchResultPage**](SearchResultPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

