//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/ingredient_recipe_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ingredient_recipes.g.dart';

/// IngredientRecipes
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class IngredientRecipes implements Built<IngredientRecipes, IngredientRecipesBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<IngredientRecipeRef> get items;

  IngredientRecipes._();

  factory IngredientRecipes([void updates(IngredientRecipesBuilder b)]) = _$IngredientRecipes;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IngredientRecipesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IngredientRecipes> get serializer => _$IngredientRecipesSerializer();
}

class _$IngredientRecipesSerializer implements PrimitiveSerializer<IngredientRecipes> {
  @override
  final Iterable<Type> types = const [IngredientRecipes, _$IngredientRecipes];

  @override
  final String wireName = r'IngredientRecipes';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IngredientRecipes object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(IngredientRecipeRef)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    IngredientRecipes object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IngredientRecipesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(IngredientRecipeRef)]),
          ) as BuiltList<IngredientRecipeRef>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IngredientRecipes deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IngredientRecipesBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

