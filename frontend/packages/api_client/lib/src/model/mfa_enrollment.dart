//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_enrollment.g.dart';

/// secret/otpAuthUri are populated only on the start-enrollment response (enabled=false) — never re-shown once enabled=true.
///
/// Properties:
/// * [enabled] 
/// * [secret] 
/// * [otpAuthUri] 
@BuiltValue()
abstract class MfaEnrollment implements Built<MfaEnrollment, MfaEnrollmentBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'secret')
  String? get secret;

  @BuiltValueField(wireName: r'otpAuthUri')
  String? get otpAuthUri;

  MfaEnrollment._();

  factory MfaEnrollment([void updates(MfaEnrollmentBuilder b)]) = _$MfaEnrollment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaEnrollmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaEnrollment> get serializer => _$MfaEnrollmentSerializer();
}

class _$MfaEnrollmentSerializer implements PrimitiveSerializer<MfaEnrollment> {
  @override
  final Iterable<Type> types = const [MfaEnrollment, _$MfaEnrollment];

  @override
  final String wireName = r'MfaEnrollment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaEnrollment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    if (object.secret != null) {
      yield r'secret';
      yield serializers.serialize(
        object.secret,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.otpAuthUri != null) {
      yield r'otpAuthUri';
      yield serializers.serialize(
        object.otpAuthUri,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaEnrollment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaEnrollmentBuilder result,
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
        case r'secret':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.secret = valueDes;
          break;
        case r'otpAuthUri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.otpAuthUri = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaEnrollment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaEnrollmentBuilder();
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

