//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_equipment_request.g.dart';

/// UpdateEquipmentRequest
///
/// Properties:
/// * [name] 
/// * [category] 
/// * [cost] 
/// * [description] 
/// * [usageGuidance] 
/// * [typicalApplications] 
@BuiltValue()
abstract class UpdateEquipmentRequest implements Built<UpdateEquipmentRequest, UpdateEquipmentRequestBuilder> {
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
  BuiltList<String>? get typicalApplications;

  UpdateEquipmentRequest._();

  factory UpdateEquipmentRequest([void updates(UpdateEquipmentRequestBuilder b)]) = _$UpdateEquipmentRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateEquipmentRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateEquipmentRequest> get serializer => _$UpdateEquipmentRequestSerializer();
}

class _$UpdateEquipmentRequestSerializer implements PrimitiveSerializer<UpdateEquipmentRequest> {
  @override
  final Iterable<Type> types = const [UpdateEquipmentRequest, _$UpdateEquipmentRequest];

  @override
  final String wireName = r'UpdateEquipmentRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateEquipmentRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.typicalApplications != null) {
      yield r'typicalApplications';
      yield serializers.serialize(
        object.typicalApplications,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateEquipmentRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateEquipmentRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
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
  UpdateEquipmentRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateEquipmentRequestBuilder();
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

