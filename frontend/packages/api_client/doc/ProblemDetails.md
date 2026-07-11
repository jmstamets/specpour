# api_client.model.ProblemDetails

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**type** | **String** | A URI identifying the problem type. \"about:blank\" if none is more specific. | [optional] 
**title** | **String** | Short, human-readable summary of the problem type. | 
**status** | **int** | The HTTP status code. | 
**detail** | **String** | Human-readable explanation specific to this occurrence. | [optional] 
**instance** | **String** | A URI identifying the specific occurrence of the problem. | [optional] 
**correlationId** | **String** | Correlation ID propagated from request tracing (OTel), for support/debugging. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


