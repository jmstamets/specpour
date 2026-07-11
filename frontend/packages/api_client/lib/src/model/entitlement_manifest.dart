//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/role_grant_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'entitlement_manifest.g.dart';

/// Shapes client UI only; every capability/role check is re-enforced server-side on the actual operation.
///
/// Properties:
/// * [tier] - Stable tier key (e.g. \"guest\", \"default\") — never a display string.
/// * [capabilities] - Capability keys granted to the caller's tier.
/// * [roles] - Active platform-scope role grants held by the caller (empty for guests).
@BuiltValue()
abstract class EntitlementManifest implements Built<EntitlementManifest, EntitlementManifestBuilder> {
  /// Stable tier key (e.g. \"guest\", \"default\") — never a display string.
  @BuiltValueField(wireName: r'tier')
  String get tier;

  /// Capability keys granted to the caller's tier.
  @BuiltValueField(wireName: r'capabilities')
  BuiltList<String> get capabilities;

  /// Active platform-scope role grants held by the caller (empty for guests).
  @BuiltValueField(wireName: r'roles')
  BuiltList<RoleGrantSummary> get roles;

  EntitlementManifest._();

  factory EntitlementManifest([void updates(EntitlementManifestBuilder b)]) = _$EntitlementManifest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EntitlementManifestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EntitlementManifest> get serializer => _$EntitlementManifestSerializer();
}

class _$EntitlementManifestSerializer implements PrimitiveSerializer<EntitlementManifest> {
  @override
  final Iterable<Type> types = const [EntitlementManifest, _$EntitlementManifest];

  @override
  final String wireName = r'EntitlementManifest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EntitlementManifest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(String),
    );
    yield r'capabilities';
    yield serializers.serialize(
      object.capabilities,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'roles';
    yield serializers.serialize(
      object.roles,
      specifiedType: const FullType(BuiltList, [FullType(RoleGrantSummary)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EntitlementManifest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EntitlementManifestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tier = valueDes;
          break;
        case r'capabilities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.capabilities.replace(valueDes);
          break;
        case r'roles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RoleGrantSummary)]),
          ) as BuiltList<RoleGrantSummary>;
          result.roles.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EntitlementManifest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EntitlementManifestBuilder();
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

