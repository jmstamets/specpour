//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/makeability_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/match_quality.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'makeable_recipe.g.dart';

/// matchQuality here is a derived summary of lines (the loosest satisfied-line quality) — never independent truth.
///
/// Properties:
/// * [recipeId] 
/// * [recipeName] 
/// * [matchQuality] 
/// * [lines] 
@BuiltValue()
abstract class MakeableRecipe implements Built<MakeableRecipe, MakeableRecipeBuilder> {
  @BuiltValueField(wireName: r'recipeId')
  String get recipeId;

  @BuiltValueField(wireName: r'recipeName')
  String get recipeName;

  @BuiltValueField(wireName: r'matchQuality')
  MatchQuality get matchQuality;
  // enum matchQualityEnum {  exact-product,  class-satisfied,  substitution,  missing,  };

  @BuiltValueField(wireName: r'lines')
  BuiltList<MakeabilityLine> get lines;

  MakeableRecipe._();

  factory MakeableRecipe([void updates(MakeableRecipeBuilder b)]) = _$MakeableRecipe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MakeableRecipeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MakeableRecipe> get serializer => _$MakeableRecipeSerializer();
}

class _$MakeableRecipeSerializer implements PrimitiveSerializer<MakeableRecipe> {
  @override
  final Iterable<Type> types = const [MakeableRecipe, _$MakeableRecipe];

  @override
  final String wireName = r'MakeableRecipe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MakeableRecipe object, {
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
    yield r'matchQuality';
    yield serializers.serialize(
      object.matchQuality,
      specifiedType: const FullType(MatchQuality),
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
    MakeableRecipe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MakeableRecipeBuilder result,
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
        case r'matchQuality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MatchQuality),
          ) as MatchQuality;
          result.matchQuality = valueDes;
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
  MakeableRecipe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MakeableRecipeBuilder();
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

