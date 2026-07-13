# api_client.model.RecipeDetail

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**primaryName** | **String** |  | 
**alternateNames** | **BuiltList&lt;String&gt;** |  | 
**familyKey** | **String** |  | [optional] 
**categoryKeys** | **BuiltList&lt;String&gt;** |  | [optional] 
**flavorProfileKeys** | **BuiltList&lt;String&gt;** |  | [optional] 
**tags** | **BuiltList&lt;String&gt;** |  | [optional] 
**ingredientLines** | [**BuiltList&lt;RecipeIngredientLine&gt;**](RecipeIngredientLine.md) |  | 
**instructions** | **BuiltList&lt;String&gt;** |  | 
**garnishes** | **BuiltList&lt;String&gt;** |  | [optional] 
**iceSpec** | **String** |  | 
**glassware** | [**BuiltList&lt;EquipmentRef&gt;**](EquipmentRef.md) |  | 
**equipment** | [**BuiltList&lt;EquipmentRef&gt;**](EquipmentRef.md) |  | 
**creatorAttribution** | **String** |  | [optional] 
**history** | **String** |  | [optional] 
**notes** | **String** |  | [optional] 
**abvPercent** | **num** | Derived — never stored, computed at read time from ingredient composition and method dilution (FR-022). | 
**standardDrinks** | **num** |  | 
**allergens** | **BuiltList&lt;String&gt;** | Rolled up from ingredient allergen attributes, conservative for uncertain (FR-055). | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


