//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/recipe_ingredient_line_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_recipe_request.g.dart';

/// UpdateRecipeRequest
///
/// Properties:
/// * [primaryName] 
/// * [alternateNames] 
/// * [instructions] 
/// * [ingredientLines] 
/// * [categoryIds] 
/// * [tags] 
@BuiltValue()
abstract class UpdateRecipeRequest implements Built<UpdateRecipeRequest, UpdateRecipeRequestBuilder> {
  @BuiltValueField(wireName: r'primaryName')
  String get primaryName;

  @BuiltValueField(wireName: r'alternateNames')
  BuiltList<String>? get alternateNames;

  @BuiltValueField(wireName: r'instructions')
  BuiltList<String>? get instructions;

  @BuiltValueField(wireName: r'ingredientLines')
  BuiltList<RecipeIngredientLineInput>? get ingredientLines;

  @BuiltValueField(wireName: r'categoryIds')
  BuiltList<String>? get categoryIds;

  @BuiltValueField(wireName: r'tags')
  BuiltList<String>? get tags;

  UpdateRecipeRequest._();

  factory UpdateRecipeRequest([void updates(UpdateRecipeRequestBuilder b)]) = _$UpdateRecipeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateRecipeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateRecipeRequest> get serializer => _$UpdateRecipeRequestSerializer();
}

class _$UpdateRecipeRequestSerializer implements PrimitiveSerializer<UpdateRecipeRequest> {
  @override
  final Iterable<Type> types = const [UpdateRecipeRequest, _$UpdateRecipeRequest];

  @override
  final String wireName = r'UpdateRecipeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateRecipeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'primaryName';
    yield serializers.serialize(
      object.primaryName,
      specifiedType: const FullType(String),
    );
    if (object.alternateNames != null) {
      yield r'alternateNames';
      yield serializers.serialize(
        object.alternateNames,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    if (object.instructions != null) {
      yield r'instructions';
      yield serializers.serialize(
        object.instructions,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    if (object.ingredientLines != null) {
      yield r'ingredientLines';
      yield serializers.serialize(
        object.ingredientLines,
        specifiedType: const FullType.nullable(BuiltList, [FullType(RecipeIngredientLineInput)]),
      );
    }
    if (object.categoryIds != null) {
      yield r'categoryIds';
      yield serializers.serialize(
        object.categoryIds,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    if (object.tags != null) {
      yield r'tags';
      yield serializers.serialize(
        object.tags,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateRecipeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateRecipeRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'primaryName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.primaryName = valueDes;
          break;
        case r'alternateNames':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.alternateNames.replace(valueDes);
          break;
        case r'instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.instructions.replace(valueDes);
          break;
        case r'ingredientLines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(RecipeIngredientLineInput)]),
          ) as BuiltList<RecipeIngredientLineInput>?;
          if (valueDes == null) continue;
          result.ingredientLines.replace(valueDes);
          break;
        case r'categoryIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.categoryIds.replace(valueDes);
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.tags.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateRecipeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateRecipeRequestBuilder();
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

