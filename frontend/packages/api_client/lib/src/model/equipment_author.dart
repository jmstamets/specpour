//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'equipment_author.g.dart';

/// EquipmentAuthor
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [category] 
/// * [libraryScope] 
/// * [venueId] 
/// * [cost] 
/// * [description] 
/// * [usageGuidance] 
/// * [typicalApplications] 
/// * [visibility] 
@BuiltValue()
abstract class EquipmentAuthor implements Built<EquipmentAuthor, EquipmentAuthorBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'libraryScope')
  EquipmentAuthorLibraryScopeEnum get libraryScope;
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
  BuiltList<String> get typicalApplications;

  @BuiltValueField(wireName: r'visibility')
  EquipmentAuthorVisibilityEnum get visibility;
  // enum visibilityEnum {  private,  public,  };

  EquipmentAuthor._();

  factory EquipmentAuthor([void updates(EquipmentAuthorBuilder b)]) = _$EquipmentAuthor;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EquipmentAuthorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EquipmentAuthor> get serializer => _$EquipmentAuthorSerializer();
}

class _$EquipmentAuthorSerializer implements PrimitiveSerializer<EquipmentAuthor> {
  @override
  final Iterable<Type> types = const [EquipmentAuthor, _$EquipmentAuthor];

  @override
  final String wireName = r'EquipmentAuthor';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EquipmentAuthor object, {
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
    yield r'libraryScope';
    yield serializers.serialize(
      object.libraryScope,
      specifiedType: const FullType(EquipmentAuthorLibraryScopeEnum),
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
    yield r'typicalApplications';
    yield serializers.serialize(
      object.typicalApplications,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'visibility';
    yield serializers.serialize(
      object.visibility,
      specifiedType: const FullType(EquipmentAuthorVisibilityEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EquipmentAuthor object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EquipmentAuthorBuilder result,
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
        case r'libraryScope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EquipmentAuthorLibraryScopeEnum),
          ) as EquipmentAuthorLibraryScopeEnum;
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
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.typicalApplications.replace(valueDes);
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EquipmentAuthorVisibilityEnum),
          ) as EquipmentAuthorVisibilityEnum;
          result.visibility = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EquipmentAuthor deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EquipmentAuthorBuilder();
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

class EquipmentAuthorLibraryScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'personal')
  static const EquipmentAuthorLibraryScopeEnum personal = _$equipmentAuthorLibraryScopeEnum_personal;
  @BuiltValueEnumConst(wireName: r'bar')
  static const EquipmentAuthorLibraryScopeEnum bar = _$equipmentAuthorLibraryScopeEnum_bar;

  static Serializer<EquipmentAuthorLibraryScopeEnum> get serializer => _$equipmentAuthorLibraryScopeEnumSerializer;

  const EquipmentAuthorLibraryScopeEnum._(String name): super(name);

  static BuiltSet<EquipmentAuthorLibraryScopeEnum> get values => _$equipmentAuthorLibraryScopeEnumValues;
  static EquipmentAuthorLibraryScopeEnum valueOf(String name) => _$equipmentAuthorLibraryScopeEnumValueOf(name);
}

class EquipmentAuthorVisibilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'private')
  static const EquipmentAuthorVisibilityEnum private = _$equipmentAuthorVisibilityEnum_private;
  @BuiltValueEnumConst(wireName: r'public')
  static const EquipmentAuthorVisibilityEnum public = _$equipmentAuthorVisibilityEnum_public;

  static Serializer<EquipmentAuthorVisibilityEnum> get serializer => _$equipmentAuthorVisibilityEnumSerializer;

  const EquipmentAuthorVisibilityEnum._(String name): super(name);

  static BuiltSet<EquipmentAuthorVisibilityEnum> get values => _$equipmentAuthorVisibilityEnumValues;
  static EquipmentAuthorVisibilityEnum valueOf(String name) => _$equipmentAuthorVisibilityEnumValueOf(name);
}

