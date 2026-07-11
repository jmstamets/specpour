# api_client.model.InboxMessage

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**type** | **String** | Typed notification key (e.g. \"prep_expiry\", \"account_deactivation_warning\"). | 
**payload** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | Type-specific structured payload. | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**readAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


