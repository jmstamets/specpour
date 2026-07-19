//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'requirement.g.dart';

/// A recipe line's requirement as stated, name-resolved.
///
/// Properties:
/// * [ingredientId] 
/// * [ingredientName] 
/// * [quantity] 
/// * [unit] 
@BuiltValue()
abstract class Requirement implements Built<Requirement, RequirementBuilder> {
  @BuiltValueField(wireName: r'ingredientId')
  String get ingredientId;

  @BuiltValueField(wireName: r'ingredientName')
  String? get ingredientName;

  @BuiltValueField(wireName: r'quantity')
  num get quantity;

  @BuiltValueField(wireName: r'unit')
  String get unit;

  Requirement._();

  factory Requirement([void updates(RequirementBuilder b)]) = _$Requirement;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RequirementBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Requirement> get serializer => _$RequirementSerializer();
}

class _$RequirementSerializer implements PrimitiveSerializer<Requirement> {
  @override
  final Iterable<Type> types = const [Requirement, _$Requirement];

  @override
  final String wireName = r'Requirement';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Requirement object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ingredientId';
    yield serializers.serialize(
      object.ingredientId,
      specifiedType: const FullType(String),
    );
    if (object.ingredientName != null) {
      yield r'ingredientName';
      yield serializers.serialize(
        object.ingredientName,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(num),
    );
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Requirement object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RequirementBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ingredientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ingredientId = valueDes;
          break;
        case r'ingredientName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ingredientName = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.quantity = valueDes;
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Requirement deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RequirementBuilder();
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

