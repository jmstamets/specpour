//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'concept_variant.g.dart';

/// ConceptVariant
///
/// Properties:
/// * [recipeId] 
/// * [differentiatorText] 
@BuiltValue()
abstract class ConceptVariant implements Built<ConceptVariant, ConceptVariantBuilder> {
  @BuiltValueField(wireName: r'recipeId')
  String get recipeId;

  @BuiltValueField(wireName: r'differentiatorText')
  String get differentiatorText;

  ConceptVariant._();

  factory ConceptVariant([void updates(ConceptVariantBuilder b)]) = _$ConceptVariant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConceptVariantBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConceptVariant> get serializer => _$ConceptVariantSerializer();
}

class _$ConceptVariantSerializer implements PrimitiveSerializer<ConceptVariant> {
  @override
  final Iterable<Type> types = const [ConceptVariant, _$ConceptVariant];

  @override
  final String wireName = r'ConceptVariant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConceptVariant object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'recipeId';
    yield serializers.serialize(
      object.recipeId,
      specifiedType: const FullType(String),
    );
    yield r'differentiatorText';
    yield serializers.serialize(
      object.differentiatorText,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConceptVariant object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConceptVariantBuilder result,
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
        case r'differentiatorText':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.differentiatorText = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConceptVariant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConceptVariantBuilder();
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

