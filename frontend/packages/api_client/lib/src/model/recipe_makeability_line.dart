//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/match_quality.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_makeability_line.g.dart';

/// RecipeMakeabilityLine
///
/// Properties:
/// * [requirementIngredientId] 
/// * [requirementIngredientName] 
/// * [matchQuality] 
/// * [satisfiedByIngredientId] 
/// * [satisfiedByIngredientName] 
@BuiltValue()
abstract class RecipeMakeabilityLine implements Built<RecipeMakeabilityLine, RecipeMakeabilityLineBuilder> {
  @BuiltValueField(wireName: r'requirementIngredientId')
  String get requirementIngredientId;

  @BuiltValueField(wireName: r'requirementIngredientName')
  String? get requirementIngredientName;

  @BuiltValueField(wireName: r'matchQuality')
  MatchQuality get matchQuality;
  // enum matchQualityEnum {  exact-product,  class-satisfied,  substitution,  missing,  };

  @BuiltValueField(wireName: r'satisfiedByIngredientId')
  String? get satisfiedByIngredientId;

  @BuiltValueField(wireName: r'satisfiedByIngredientName')
  String? get satisfiedByIngredientName;

  RecipeMakeabilityLine._();

  factory RecipeMakeabilityLine([void updates(RecipeMakeabilityLineBuilder b)]) = _$RecipeMakeabilityLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeMakeabilityLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeMakeabilityLine> get serializer => _$RecipeMakeabilityLineSerializer();
}

class _$RecipeMakeabilityLineSerializer implements PrimitiveSerializer<RecipeMakeabilityLine> {
  @override
  final Iterable<Type> types = const [RecipeMakeabilityLine, _$RecipeMakeabilityLine];

  @override
  final String wireName = r'RecipeMakeabilityLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeMakeabilityLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'requirementIngredientId';
    yield serializers.serialize(
      object.requirementIngredientId,
      specifiedType: const FullType(String),
    );
    if (object.requirementIngredientName != null) {
      yield r'requirementIngredientName';
      yield serializers.serialize(
        object.requirementIngredientName,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'matchQuality';
    yield serializers.serialize(
      object.matchQuality,
      specifiedType: const FullType(MatchQuality),
    );
    if (object.satisfiedByIngredientId != null) {
      yield r'satisfiedByIngredientId';
      yield serializers.serialize(
        object.satisfiedByIngredientId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.satisfiedByIngredientName != null) {
      yield r'satisfiedByIngredientName';
      yield serializers.serialize(
        object.satisfiedByIngredientName,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeMakeabilityLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecipeMakeabilityLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'requirementIngredientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requirementIngredientId = valueDes;
          break;
        case r'requirementIngredientName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.requirementIngredientName = valueDes;
          break;
        case r'matchQuality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MatchQuality),
          ) as MatchQuality;
          result.matchQuality = valueDes;
          break;
        case r'satisfiedByIngredientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.satisfiedByIngredientId = valueDes;
          break;
        case r'satisfiedByIngredientName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.satisfiedByIngredientName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeMakeabilityLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeMakeabilityLineBuilder();
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

