//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'equipment_ref.g.dart';

/// A glassware/equipment reference with its resolved name (contract sweep). name is null only if the equipment can no longer be resolved.
///
/// Properties:
/// * [id] 
/// * [name] 
@BuiltValue()
abstract class EquipmentRef implements Built<EquipmentRef, EquipmentRefBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  EquipmentRef._();

  factory EquipmentRef([void updates(EquipmentRefBuilder b)]) = _$EquipmentRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EquipmentRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EquipmentRef> get serializer => _$EquipmentRefSerializer();
}

class _$EquipmentRefSerializer implements PrimitiveSerializer<EquipmentRef> {
  @override
  final Iterable<Type> types = const [EquipmentRef, _$EquipmentRef];

  @override
  final String wireName = r'EquipmentRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EquipmentRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EquipmentRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EquipmentRefBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EquipmentRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EquipmentRefBuilder();
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

