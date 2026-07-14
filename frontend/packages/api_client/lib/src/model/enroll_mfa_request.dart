//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enroll_mfa_request.g.dart';

/// Omit code (or send an empty body) to start enrollment; include it to confirm.
///
/// Properties:
/// * [code] 
@BuiltValue()
abstract class EnrollMfaRequest implements Built<EnrollMfaRequest, EnrollMfaRequestBuilder> {
  @BuiltValueField(wireName: r'code')
  String? get code;

  EnrollMfaRequest._();

  factory EnrollMfaRequest([void updates(EnrollMfaRequestBuilder b)]) = _$EnrollMfaRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnrollMfaRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnrollMfaRequest> get serializer => _$EnrollMfaRequestSerializer();
}

class _$EnrollMfaRequestSerializer implements PrimitiveSerializer<EnrollMfaRequest> {
  @override
  final Iterable<Type> types = const [EnrollMfaRequest, _$EnrollMfaRequest];

  @override
  final String wireName = r'EnrollMfaRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnrollMfaRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.code != null) {
      yield r'code';
      yield serializers.serialize(
        object.code,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EnrollMfaRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnrollMfaRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EnrollMfaRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnrollMfaRequestBuilder();
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

