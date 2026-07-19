//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/makeability_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'near_miss_recipe.g.dart';

/// NearMissRecipe
///
/// Properties:
/// * [recipeId] 
/// * [recipeName] 
/// * [lines] 
@BuiltValue()
abstract class NearMissRecipe implements Built<NearMissRecipe, NearMissRecipeBuilder> {
  @BuiltValueField(wireName: r'recipeId')
  String get recipeId;

  @BuiltValueField(wireName: r'recipeName')
  String get recipeName;

  @BuiltValueField(wireName: r'lines')
  BuiltList<MakeabilityLine> get lines;

  NearMissRecipe._();

  factory NearMissRecipe([void updates(NearMissRecipeBuilder b)]) = _$NearMissRecipe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NearMissRecipeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NearMissRecipe> get serializer => _$NearMissRecipeSerializer();
}

class _$NearMissRecipeSerializer implements PrimitiveSerializer<NearMissRecipe> {
  @override
  final Iterable<Type> types = const [NearMissRecipe, _$NearMissRecipe];

  @override
  final String wireName = r'NearMissRecipe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NearMissRecipe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'recipeId';
    yield serializers.serialize(
      object.recipeId,
      specifiedType: const FullType(String),
    );
    yield r'recipeName';
    yield serializers.serialize(
      object.recipeName,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(MakeabilityLine)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NearMissRecipe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NearMissRecipeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recipeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.recipeId = valueDes;
          break;
        case r'recipeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.recipeName = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MakeabilityLine)]),
          ) as BuiltList<MakeabilityLine>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NearMissRecipe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NearMissRecipeBuilder();
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

