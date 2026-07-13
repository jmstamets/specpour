//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_account.g.dart';

/// Deliberately minimal — no dateOfBirth field (sensitive-PII invariant, see this document's top-level description) and no token (ADR-0003: tokens come from the standard /connect/token exchange, never from these endpoints).
///
/// Properties:
/// * [userId] 
/// * [email] 
/// * [displayName] 
@BuiltValue()
abstract class AuthAccount implements Built<AuthAccount, AuthAccountBuilder> {
  @BuiltValueField(wireName: r'userId')
  String get userId;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  AuthAccount._();

  factory AuthAccount([void updates(AuthAccountBuilder b)]) = _$AuthAccount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthAccountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthAccount> get serializer => _$AuthAccountSerializer();
}

class _$AuthAccountSerializer implements PrimitiveSerializer<AuthAccount> {
  @override
  final Iterable<Type> types = const [AuthAccount, _$AuthAccount];

  @override
  final String wireName = r'AuthAccount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthAccountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthAccount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthAccountBuilder();
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

