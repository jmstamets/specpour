//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recovery_confirm_request.g.dart';

/// RecoveryConfirmRequest
///
/// Properties:
/// * [email] 
/// * [token] - The recovery code from the account-recovery email.
/// * [newPassword] 
@BuiltValue()
abstract class RecoveryConfirmRequest implements Built<RecoveryConfirmRequest, RecoveryConfirmRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  /// The recovery code from the account-recovery email.
  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'newPassword')
  String get newPassword;

  RecoveryConfirmRequest._();

  factory RecoveryConfirmRequest([void updates(RecoveryConfirmRequestBuilder b)]) = _$RecoveryConfirmRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecoveryConfirmRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecoveryConfirmRequest> get serializer => _$RecoveryConfirmRequestSerializer();
}

class _$RecoveryConfirmRequestSerializer implements PrimitiveSerializer<RecoveryConfirmRequest> {
  @override
  final Iterable<Type> types = const [RecoveryConfirmRequest, _$RecoveryConfirmRequest];

  @override
  final String wireName = r'RecoveryConfirmRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecoveryConfirmRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'newPassword';
    yield serializers.serialize(
      object.newPassword,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecoveryConfirmRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecoveryConfirmRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        case r'newPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.newPassword = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecoveryConfirmRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecoveryConfirmRequestBuilder();
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

