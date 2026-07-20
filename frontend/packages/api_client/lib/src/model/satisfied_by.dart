//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'satisfied_by.g.dart';

/// The caller's inventory item (or substitution) satisfying a line. Absent (null) exactly when the line's matchQuality is \"missing\".
///
/// Properties:
/// * [inventoryItemId] 
/// * [ingredientId] 
/// * [ingredientName] 
@BuiltValue()
abstract class SatisfiedBy implements Built<SatisfiedBy, SatisfiedByBuilder> {
  @BuiltValueField(wireName: r'inventoryItemId')
  String get inventoryItemId;

  @BuiltValueField(wireName: r'ingredientId')
  String get ingredientId;

  @BuiltValueField(wireName: r'ingredientName')
  String? get ingredientName;

  SatisfiedBy._();

  factory SatisfiedBy([void updates(SatisfiedByBuilder b)]) = _$SatisfiedBy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SatisfiedByBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SatisfiedBy> get serializer => _$SatisfiedBySerializer();
}

class _$SatisfiedBySerializer implements PrimitiveSerializer<SatisfiedBy> {
  @override
  final Iterable<Type> types = const [SatisfiedBy, _$SatisfiedBy];

  @override
  final String wireName = r'SatisfiedBy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SatisfiedBy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'inventoryItemId';
    yield serializers.serialize(
      object.inventoryItemId,
      specifiedType: const FullType(String),
    );
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
  }

  @override
  Object serialize(
    Serializers serializers,
    SatisfiedBy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SatisfiedByBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'inventoryItemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.inventoryItemId = valueDes;
          break;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SatisfiedBy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SatisfiedByBuilder();
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

