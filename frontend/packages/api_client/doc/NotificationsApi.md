# api_client.api.NotificationsApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getInbox**](NotificationsApi.md#getinbox) | **GET** /inbox | Get the caller&#39;s inbox messages


# **getInbox**
> InboxPage getInbox(cursor, limit)

Get the caller's inbox messages

Cursor-paginated in-app inbox (FR-040a) — the always-on notification channel. Email is the V1 opt-in alert channel (also carrying identity transactional mail); push delivery is modeled but deferred to Phase 2.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNotificationsApi();
final String cursor = cursor_example; // String | Opaque pagination cursor from a previous page's `nextCursor`.
final int limit = 56; // int | Maximum number of items to return.

try {
    final response = api.getInbox(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->getInbox: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque pagination cursor from a previous page's `nextCursor`. | [optional] 
 **limit** | **int**| Maximum number of items to return. | [optional] [default to 20]

### Return type

[**InboxPage**](InboxPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

