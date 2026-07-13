//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_request.g.dart';

/// RegisterRequest
///
/// Properties:
/// * [email] 
/// * [password] 
/// * [displayName] 
/// * [dateOfBirth] - Accepted as input only — never stored in plaintext (FR-002b) and never echoed back in this or any other response.
/// * [unitPreference] 
/// * [locale] 
@BuiltValue()
abstract class RegisterRequest implements Built<RegisterRequest, RegisterRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  /// Accepted as input only — never stored in plaintext (FR-002b) and never echoed back in this or any other response.
  @BuiltValueField(wireName: r'dateOfBirth')
  Date get dateOfBirth;

  @BuiltValueField(wireName: r'unitPreference')
  RegisterRequestUnitPreferenceEnum? get unitPreference;
  // enum unitPreferenceEnum {  Milliliters,  Ounces,  Centiliters,  };

  @BuiltValueField(wireName: r'locale')
  String? get locale;

  RegisterRequest._();

  factory RegisterRequest([void updates(RegisterRequestBuilder b)]) = _$RegisterRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterRequest> get serializer => _$RegisterRequestSerializer();
}

class _$RegisterRequestSerializer implements PrimitiveSerializer<RegisterRequest> {
  @override
  final Iterable<Type> types = const [RegisterRequest, _$RegisterRequest];

  @override
  final String wireName = r'RegisterRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'dateOfBirth';
    yield serializers.serialize(
      object.dateOfBirth,
      specifiedType: const FullType(Date),
    );
    if (object.unitPreference != null) {
      yield r'unitPreference';
      yield serializers.serialize(
        object.unitPreference,
        specifiedType: const FullType(RegisterRequestUnitPreferenceEnum),
      );
    }
    if (object.locale != null) {
      yield r'locale';
      yield serializers.serialize(
        object.locale,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterRequestBuilder result,
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
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'dateOfBirth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.dateOfBirth = valueDes;
          break;
        case r'unitPreference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegisterRequestUnitPreferenceEnum),
          ) as RegisterRequestUnitPreferenceEnum;
          result.unitPreference = valueDes;
          break;
        case r'locale':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.locale = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegisterRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterRequestBuilder();
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

class RegisterRequestUnitPreferenceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Milliliters')
  static const RegisterRequestUnitPreferenceEnum milliliters = _$registerRequestUnitPreferenceEnum_milliliters;
  @BuiltValueEnumConst(wireName: r'Ounces')
  static const RegisterRequestUnitPreferenceEnum ounces = _$registerRequestUnitPreferenceEnum_ounces;
  @BuiltValueEnumConst(wireName: r'Centiliters')
  static const RegisterRequestUnitPreferenceEnum centiliters = _$registerRequestUnitPreferenceEnum_centiliters;

  static Serializer<RegisterRequestUnitPreferenceEnum> get serializer => _$registerRequestUnitPreferenceEnumSerializer;

  const RegisterRequestUnitPreferenceEnum._(String name): super(name);

  static BuiltSet<RegisterRequestUnitPreferenceEnum> get values => _$registerRequestUnitPreferenceEnumValues;
  static RegisterRequestUnitPreferenceEnum valueOf(String name) => _$registerRequestUnitPreferenceEnumValueOf(name);
}

