# api_client.model.IngredientDetail

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**name** | **String** |  | 
**parentId** | **String** |  | [optional] 
**parentName** | **String** | Resolved parent-ingredient name (contract sweep). | [optional] 
**sources** | **BuiltList&lt;String&gt;** |  | 
**description** | **String** |  | [optional] 
**abvPercent** | **num** |  | [optional] 
**allergens** | **BuiltList&lt;String&gt;** |  | 
**definingRecipeId** | **String** |  | [optional] 
**definingRecipeName** | **String** | Resolved defining-recipe name for house-made ingredients (contract sweep). | [optional] 
**yieldQuantity** | **num** |  | [optional] 
**yieldUnit** | **String** |  | [optional] 
**shelfLife** | **String** | ISO 8601 duration, when this is a house-made ingredient. | [optional] 
**storageInstructions** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


