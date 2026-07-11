# api_client.api.GlossaryApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getGlossaryArticle**](GlossaryApi.md#getglossaryarticle) | **GET** /glossary/articles/{id} | Get an article&#39;s full body (FR-026)
[**getGlossaryAutolink**](GlossaryApi.md#getglossaryautolink) | **GET** /glossary/autolink | Resolve auto-link matches for a block of content (FR-027)
[**getGlossaryTerm**](GlossaryApi.md#getglossaryterm) | **GET** /glossary/terms/{id} | Get a glossary term&#39;s ordered, numbered definitions (FR-025)
[**listGlossaryArticles**](GlossaryApi.md#listglossaryarticles) | **GET** /glossary/articles | Browse glossary articles (FR-026)
[**listGlossaryTerms**](GlossaryApi.md#listglossaryterms) | **GET** /glossary/terms | Browse glossary terms (FR-025)


# **getGlossaryArticle**
> GlossaryArticleDetail getGlossaryArticle(id)

Get an article's full body (FR-026)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGlossaryApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getGlossaryArticle(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GlossaryApi->getGlossaryArticle: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**GlossaryArticleDetail**](GlossaryArticleDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGlossaryAutolink**
> AutoLinkResponse getGlossaryAutolink(context, content)

Resolve auto-link matches for a block of content (FR-027)

Best-effort automated matching: first occurrence per term, longest-match-wins on overlapping terms, curator Suppress/Force overrides applied per `context`. Auto-links are computed at render time from the live term list, never stored.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGlossaryApi();
final String context = context_example; // String | Identifies the page/content this text belongs to, so curator link overrides scoped to that page apply.
final String content = content_example; // String | The text to resolve auto-links within.

try {
    final response = api.getGlossaryAutolink(context, content);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GlossaryApi->getGlossaryAutolink: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **context** | **String**| Identifies the page/content this text belongs to, so curator link overrides scoped to that page apply. | 
 **content** | **String**| The text to resolve auto-links within. | 

### Return type

[**AutoLinkResponse**](AutoLinkResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGlossaryTerm**
> GlossaryTermDetail getGlossaryTerm(id)

Get a glossary term's ordered, numbered definitions (FR-025)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGlossaryApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getGlossaryTerm(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GlossaryApi->getGlossaryTerm: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**GlossaryTermDetail**](GlossaryTermDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listGlossaryArticles**
> GlossaryArticlePage listGlossaryArticles(cursor, limit)

Browse glossary articles (FR-026)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGlossaryApi();
final String cursor = cursor_example; // String | Opaque pagination cursor from a previous page's `nextCursor`.
final int limit = 56; // int | Maximum number of items to return.

try {
    final response = api.listGlossaryArticles(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GlossaryApi->listGlossaryArticles: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque pagination cursor from a previous page's `nextCursor`. | [optional] 
 **limit** | **int**| Maximum number of items to return. | [optional] [default to 20]

### Return type

[**GlossaryArticlePage**](GlossaryArticlePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listGlossaryTerms**
> GlossaryTermPage listGlossaryTerms(cursor, limit)

Browse glossary terms (FR-025)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGlossaryApi();
final String cursor = cursor_example; // String | Opaque pagination cursor from a previous page's `nextCursor`.
final int limit = 56; // int | Maximum number of items to return.

try {
    final response = api.listGlossaryTerms(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GlossaryApi->listGlossaryTerms: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque pagination cursor from a previous page's `nextCursor`. | [optional] 
 **limit** | **int**| Maximum number of items to return. | [optional] [default to 20]

### Return type

[**GlossaryTermPage**](GlossaryTermPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

