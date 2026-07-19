//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_equipment_request.g.dart';

/// T060, FR-024. libraryScope \"bar\" requires venueId, verified as owned by the caller (403 otherwise). Newly authored equipment always starts private (FR-008b).
///
/// Properties:
/// * [name] 
/// * [category] 
/// * [libraryScope] 
/// * [venueId] 
/// * [cost] 
/// * [description] 
/// * [usageGuidance] 
/// * [typicalApplications] 
@BuiltValue()
abstract class CreateEquipmentRequest implements Built<CreateEquipmentRequest, CreateEquipmentRequestBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'libraryScope')
  CreateEquipmentRequestLibraryScopeEnum get libraryScope;
  // enum libraryScopeEnum {  personal,  bar,  };

  @BuiltValueField(wireName: r'venueId')
  String? get venueId;

  @BuiltValueField(wireName: r'cost')
  num? get cost;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'usageGuidance')
  String? get usageGuidance;

  @BuiltValueField(wireName: r'typicalApplications')
  BuiltList<String>? get typicalApplications;

  CreateEquipmentRequest._();

  factory CreateEquipmentRequest([void updates(CreateEquipmentRequestBuilder b)]) = _$CreateEquipmentRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateEquipmentRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateEquipmentRequest> get serializer => _$CreateEquipmentRequestSerializer();
}

class _$CreateEquipmentRequestSerializer implements PrimitiveSerializer<CreateEquipmentRequest> {
  @override
  final Iterable<Type> types = const [CreateEquipmentRequest, _$CreateEquipmentRequest];

  @override
  final String wireName = r'CreateEquipmentRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateEquipmentRequest object, {
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
    yield r'libraryScope';
    yield serializers.serialize(
      object.libraryScope,
      specifiedType: const FullType(CreateEquipmentRequestLibraryScopeEnum),
    );
    if (object.venueId != null) {
      yield r'venueId';
      yield serializers.serialize(
        object.venueId,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    CreateEquipmentRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateEquipmentRequestBuilder result,
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
        case r'libraryScope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateEquipmentRequestLibraryScopeEnum),
          ) as CreateEquipmentRequestLibraryScopeEnum;
          result.libraryScope = valueDes;
          break;
        case r'venueId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.venueId = valueDes;
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
  CreateEquipmentRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateEquipmentRequestBuilder();
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

class CreateEquipmentRequestLibraryScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'personal')
  static const CreateEquipmentRequestLibraryScopeEnum personal = _$createEquipmentRequestLibraryScopeEnum_personal;
  @BuiltValueEnumConst(wireName: r'bar')
  static const CreateEquipmentRequestLibraryScopeEnum bar = _$createEquipmentRequestLibraryScopeEnum_bar;

  static Serializer<CreateEquipmentRequestLibraryScopeEnum> get serializer => _$createEquipmentRequestLibraryScopeEnumSerializer;

  const CreateEquipmentRequestLibraryScopeEnum._(String name): super(name);

  static BuiltSet<CreateEquipmentRequestLibraryScopeEnum> get values => _$createEquipmentRequestLibraryScopeEnumValues;
  static CreateEquipmentRequestLibraryScopeEnum valueOf(String name) => _$createEquipmentRequestLibraryScopeEnumValueOf(name);
}

