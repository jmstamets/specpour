//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'equipment_detail.g.dart';

/// EquipmentDetail
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [category] 
/// * [cost] 
/// * [description] 
/// * [usageGuidance] 
/// * [typicalApplications] 
@BuiltValue()
abstract class EquipmentDetail implements Built<EquipmentDetail, EquipmentDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'cost')
  num? get cost;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'usageGuidance')
  String? get usageGuidance;

  @BuiltValueField(wireName: r'typicalApplications')
  BuiltList<String> get typicalApplications;

  EquipmentDetail._();

  factory EquipmentDetail([void updates(EquipmentDetailBuilder b)]) = _$EquipmentDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EquipmentDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EquipmentDetail> get serializer => _$EquipmentDetailSerializer();
}

class _$EquipmentDetailSerializer implements PrimitiveSerializer<EquipmentDetail> {
  @override
  final Iterable<Type> types = const [EquipmentDetail, _$EquipmentDetail];

  @override
  final String wireName = r'EquipmentDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EquipmentDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    if (object.cost != null) {
      yield r'cost';
      yield serializers.serialize(
        object.cost,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.usageGuidance != null) {
      yield r'usageGuidance';
      yield serializers.serialize(
        object.usageGuidance,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'typicalApplications';
    yield serializers.serialize(
      object.typicalApplications,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EquipmentDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EquipmentDetailBuilder result,
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
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'cost':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.cost = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'usageGuidance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.usageGuidance = valueDes;
          break;
        case r'typicalApplications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.typicalApplications.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EquipmentDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EquipmentDetailBuilder();
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

