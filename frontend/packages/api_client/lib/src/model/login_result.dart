//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_result.g.dart';

/// User fields are null when requiresMfa is true — see the login operation description.
///
/// Properties:
/// * [requiresMfa] 
/// * [userId] 
/// * [email] 
/// * [displayName] 
@BuiltValue()
abstract class LoginResult implements Built<LoginResult, LoginResultBuilder> {
  @BuiltValueField(wireName: r'requiresMfa')
  bool get requiresMfa;

  @BuiltValueField(wireName: r'userId')
  String? get userId;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'displayName')
  String? get displayName;

  LoginResult._();

  factory LoginResult([void updates(LoginResultBuilder b)]) = _$LoginResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoginResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoginResult> get serializer => _$LoginResultSerializer();
}

class _$LoginResultSerializer implements PrimitiveSerializer<LoginResult> {
  @override
  final Iterable<Type> types = const [LoginResult, _$LoginResult];

  @override
  final String wireName = r'LoginResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoginResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'requiresMfa';
    yield serializers.serialize(
      object.requiresMfa,
      specifiedType: const FullType(bool),
    );
    if (object.userId != null) {
      yield r'userId';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.email != null) {
      yield r'email';
      yield serializers.serialize(
        object.email,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.displayName != null) {
      yield r'displayName';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LoginResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoginResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'requiresMfa':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.requiresMfa = valueDes;
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.userId = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  LoginResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoginResultBuilder();
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

