# api_client.api.VenuesApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createVenue**](VenuesApi.md#createvenue) | **POST** /venues | Create a venue owned by the caller (T061, FR-058)
[**deleteVenue**](VenuesApi.md#deletevenue) | **DELETE** /venues/{id} | Delete one of the caller&#39;s venues (T061, FR-058)
[**getVenue**](VenuesApi.md#getvenue) | **GET** /venues/{id} | Get one of the caller&#39;s venues by id (T061, FR-058)
[**listVenues**](VenuesApi.md#listvenues) | **GET** /venues | List the caller&#39;s venues (T061, FR-058)
[**updateVenue**](VenuesApi.md#updatevenue) | **PUT** /venues/{id} | Update one of the caller&#39;s venues (T061, FR-058)


# **createVenue**
> Venue createVenue(createVenueRequest)

Create a venue owned by the caller (T061, FR-058)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getVenuesApi();
final CreateVenueRequest createVenueRequest = ; // CreateVenueRequest | 

try {
    final response = api.createVenue(createVenueRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VenuesApi->createVenue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createVenueRequest** | [**CreateVenueRequest**](CreateVenueRequest.md)|  | 

### Return type

[**Venue**](Venue.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteVenue**
> deleteVenue(id)

Delete one of the caller's venues (T061, FR-058)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getVenuesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deleteVenue(id);
} on DioException catch (e) {
    print('Exception when calling VenuesApi->deleteVenue: $e\n');
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

# **getVenue**
> Venue getVenue(id)

Get one of the caller's venues by id (T061, FR-058)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getVenuesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getVenue(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VenuesApi->getVenue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Venue**](Venue.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVenues**
> VenuePage listVenues(cursor, limit)

List the caller's venues (T061, FR-058)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getVenuesApi();
final String cursor = cursor_example; // String | Opaque pagination cursor from a previous page's `nextCursor`.
final int limit = 56; // int | Maximum number of items to return.

try {
    final response = api.listVenues(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VenuesApi->listVenues: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque pagination cursor from a previous page's `nextCursor`. | [optional] 
 **limit** | **int**| Maximum number of items to return. | [optional] [default to 20]

### Return type

[**VenuePage**](VenuePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateVenue**
> Venue updateVenue(id, updateVenueRequest)

Update one of the caller's venues (T061, FR-058)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getVenuesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UpdateVenueRequest updateVenueRequest = ; // UpdateVenueRequest | 

try {
    final response = api.updateVenue(id, updateVenueRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VenuesApi->updateVenue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateVenueRequest** | [**UpdateVenueRequest**](UpdateVenueRequest.md)|  | 

### Return type

[**Venue**](Venue.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

