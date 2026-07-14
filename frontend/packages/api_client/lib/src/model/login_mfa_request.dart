//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_mfa_request.g.dart';

/// LoginMfaRequest
///
/// Properties:
/// * [code] - The current 6-digit TOTP code.
@BuiltValue()
abstract class LoginMfaRequest implements Built<LoginMfaRequest, LoginMfaRequestBuilder> {
  /// The current 6-digit TOTP code.
  @BuiltValueField(wireName: r'code')
  String get code;

  LoginMfaRequest._();

  factory LoginMfaRequest([void updates(LoginMfaRequestBuilder b)]) = _$LoginMfaRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoginMfaRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoginMfaRequest> get serializer => _$LoginMfaRequestSerializer();
}

class _$LoginMfaRequestSerializer implements PrimitiveSerializer<LoginMfaRequest> {
  @override
  final Iterable<Type> types = const [LoginMfaRequest, _$LoginMfaRequest];

  @override
  final String wireName = r'LoginMfaRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoginMfaRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoginMfaRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoginMfaRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  LoginMfaRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoginMfaRequestBuilder();
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

