//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_status.g.dart';

/// MfaStatus
///
/// Properties:
/// * [enabled] 
/// * [method] 
@BuiltValue()
abstract class MfaStatus implements Built<MfaStatus, MfaStatusBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'method')
  MfaStatusMethodEnum? get method;
  // enum methodEnum {  totp,  ,  };

  MfaStatus._();

  factory MfaStatus([void updates(MfaStatusBuilder b)]) = _$MfaStatus;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaStatusBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaStatus> get serializer => _$MfaStatusSerializer();
}

class _$MfaStatusSerializer implements PrimitiveSerializer<MfaStatus> {
  @override
  final Iterable<Type> types = const [MfaStatus, _$MfaStatus];

  @override
  final String wireName = r'MfaStatus';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    if (object.method != null) {
      yield r'method';
      yield serializers.serialize(
        object.method,
        specifiedType: const FullType.nullable(MfaStatusMethodEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaStatusBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MfaStatusMethodEnum),
          ) as MfaStatusMethodEnum?;
          if (valueDes == null) continue;
          result.method = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaStatusBuilder();
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

class MfaStatusMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'totp')
  static const MfaStatusMethodEnum totp = _$mfaStatusMethodEnum_totp;

  static Serializer<MfaStatusMethodEnum> get serializer => _$mfaStatusMethodEnumSerializer;

  const MfaStatusMethodEnum._(String name): super(name);

  static BuiltSet<MfaStatusMethodEnum> get values => _$mfaStatusMethodEnumValues;
  static MfaStatusMethodEnum valueOf(String name) => _$mfaStatusMethodEnumValueOf(name);
}

