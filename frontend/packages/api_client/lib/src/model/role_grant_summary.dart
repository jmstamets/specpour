//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'role_grant_summary.g.dart';

/// RoleGrantSummary
///
/// Properties:
/// * [roleKey] - Stable platform role key (e.g. \"curator\", \"super_admin\").
/// * [scopeType] 
/// * [scopeId] - Null for platform-scope grants (V1 issues platform-scope grants only, FR-063).
@BuiltValue()
abstract class RoleGrantSummary implements Built<RoleGrantSummary, RoleGrantSummaryBuilder> {
  /// Stable platform role key (e.g. \"curator\", \"super_admin\").
  @BuiltValueField(wireName: r'roleKey')
  String get roleKey;

  @BuiltValueField(wireName: r'scopeType')
  RoleGrantSummaryScopeTypeEnum get scopeType;
  // enum scopeTypeEnum {  platform,  venue,  };

  /// Null for platform-scope grants (V1 issues platform-scope grants only, FR-063).
  @BuiltValueField(wireName: r'scopeId')
  String? get scopeId;

  RoleGrantSummary._();

  factory RoleGrantSummary([void updates(RoleGrantSummaryBuilder b)]) = _$RoleGrantSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoleGrantSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoleGrantSummary> get serializer => _$RoleGrantSummarySerializer();
}

class _$RoleGrantSummarySerializer implements PrimitiveSerializer<RoleGrantSummary> {
  @override
  final Iterable<Type> types = const [RoleGrantSummary, _$RoleGrantSummary];

  @override
  final String wireName = r'RoleGrantSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoleGrantSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'roleKey';
    yield serializers.serialize(
      object.roleKey,
      specifiedType: const FullType(String),
    );
    yield r'scopeType';
    yield serializers.serialize(
      object.scopeType,
      specifiedType: const FullType(RoleGrantSummaryScopeTypeEnum),
    );
    yield r'scopeId';
    yield object.scopeId == null ? null : serializers.serialize(
      object.scopeId,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RoleGrantSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RoleGrantSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'roleKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.roleKey = valueDes;
          break;
        case r'scopeType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RoleGrantSummaryScopeTypeEnum),
          ) as RoleGrantSummaryScopeTypeEnum;
          result.scopeType = valueDes;
          break;
        case r'scopeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.scopeId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RoleGrantSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoleGrantSummaryBuilder();
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

class RoleGrantSummaryScopeTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'platform')
  static const RoleGrantSummaryScopeTypeEnum platform = _$roleGrantSummaryScopeTypeEnum_platform;
  @BuiltValueEnumConst(wireName: r'venue')
  static const RoleGrantSummaryScopeTypeEnum venue = _$roleGrantSummaryScopeTypeEnum_venue;

  static Serializer<RoleGrantSummaryScopeTypeEnum> get serializer => _$roleGrantSummaryScopeTypeEnumSerializer;

  const RoleGrantSummaryScopeTypeEnum._(String name): super(name);

  static BuiltSet<RoleGrantSummaryScopeTypeEnum> get values => _$roleGrantSummaryScopeTypeEnumValues;
  static RoleGrantSummaryScopeTypeEnum valueOf(String name) => _$roleGrantSummaryScopeTypeEnumValueOf(name);
}

