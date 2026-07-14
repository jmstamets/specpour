# api_client.api.NotificationsApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getInbox**](NotificationsApi.md#getinbox) | **GET** /inbox | Get the caller&#39;s inbox messages
[**getMyChannelPreferences**](NotificationsApi.md#getmychannelpreferences) | **GET** /me/channels | Get the caller&#39;s notification channel opt-in preferences
[**markInboxMessageRead**](NotificationsApi.md#markinboxmessageread) | **POST** /inbox/{id}/read | Mark an inbox message as read
[**updateMyChannelPreferences**](NotificationsApi.md#updatemychannelpreferences) | **PUT** /me/channels | Update the caller&#39;s notification channel opt-in preferences


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

# **getMyChannelPreferences**
> ChannelPreferences getMyChannelPreferences()

Get the caller's notification channel opt-in preferences

Email is the V1 opt-in alert channel (FR-040a); the push preference is modeled here but push delivery is deferred to Phase 2, so opting into push has no delivery effect in V1.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNotificationsApi();

try {
    final response = api.getMyChannelPreferences();
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->getMyChannelPreferences: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ChannelPreferences**](ChannelPreferences.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markInboxMessageRead**
> markInboxMessageRead(id)

Mark an inbox message as read

Sets the message's read timestamp. Idempotent — marking an already-read message again succeeds without changing the original readAt.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNotificationsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.markInboxMessageRead(id);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->markInboxMessageRead: $e\n');
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

# **updateMyChannelPreferences**
> ChannelPreferences updateMyChannelPreferences(channelPreferencesUpdate)

Update the caller's notification channel opt-in preferences

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNotificationsApi();
final ChannelPreferencesUpdate channelPreferencesUpdate = ; // ChannelPreferencesUpdate | 

try {
    final response = api.updateMyChannelPreferences(channelPreferencesUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->updateMyChannelPreferences: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **channelPreferencesUpdate** | [**ChannelPreferencesUpdate**](ChannelPreferencesUpdate.md)|  | 

### Return type

[**ChannelPreferences**](ChannelPreferences.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

