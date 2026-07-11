# api_client.model.EntitlementManifest

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**tier** | **String** | Stable tier key (e.g. \"guest\", \"default\") — never a display string. | 
**capabilities** | **BuiltList&lt;String&gt;** | Capability keys granted to the caller's tier. | 
**roles** | [**BuiltList&lt;RoleGrantSummary&gt;**](RoleGrantSummary.md) | Active platform-scope role grants held by the caller (empty for guests). | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


