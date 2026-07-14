//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'complete_external_registration_request.g.dart';

/// CompleteExternalRegistrationRequest
///
/// Properties:
/// * [dateOfBirth] - Same input-only, never-echoed-back handling as RegisterRequest.dateOfBirth.
/// * [displayName] - Used only if the provider didn't share a name.
/// * [unitPreference] 
/// * [locale] 
@BuiltValue()
abstract class CompleteExternalRegistrationRequest implements Built<CompleteExternalRegistrationRequest, CompleteExternalRegistrationRequestBuilder> {
  /// Same input-only, never-echoed-back handling as RegisterRequest.dateOfBirth.
  @BuiltValueField(wireName: r'dateOfBirth')
  Date get dateOfBirth;

  /// Used only if the provider didn't share a name.
  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'unitPreference')
  CompleteExternalRegistrationRequestUnitPreferenceEnum? get unitPreference;
  // enum unitPreferenceEnum {  Milliliters,  Ounces,  Centiliters,  };

  @BuiltValueField(wireName: r'locale')
  String? get locale;

  CompleteExternalRegistrationRequest._();

  factory CompleteExternalRegistrationRequest([void updates(CompleteExternalRegistrationRequestBuilder b)]) = _$CompleteExternalRegistrationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompleteExternalRegistrationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompleteExternalRegistrationRequest> get serializer => _$CompleteExternalRegistrationRequestSerializer();
}

class _$CompleteExternalRegistrationRequestSerializer implements PrimitiveSerializer<CompleteExternalRegistrationRequest> {
  @override
  final Iterable<Type> types = const [CompleteExternalRegistrationRequest, _$CompleteExternalRegistrationRequest];

  @override
  final String wireName = r'CompleteExternalRegistrationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompleteExternalRegistrationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'dateOfBirth';
    yield serializers.serialize(
      object.dateOfBirth,
      specifiedType: const FullType(Date),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    if (object.unitPreference != null) {
      yield r'unitPreference';
      yield serializers.serialize(
        object.unitPreference,
        specifiedType: const FullType(CompleteExternalRegistrationRequestUnitPreferenceEnum),
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
    CompleteExternalRegistrationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CompleteExternalRegistrationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'dateOfBirth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.dateOfBirth = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'unitPreference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CompleteExternalRegistrationRequestUnitPreferenceEnum),
          ) as CompleteExternalRegistrationRequestUnitPreferenceEnum;
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
  CompleteExternalRegistrationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompleteExternalRegistrationRequestBuilder();
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

class CompleteExternalRegistrationRequestUnitPreferenceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Milliliters')
  static const CompleteExternalRegistrationRequestUnitPreferenceEnum milliliters = _$completeExternalRegistrationRequestUnitPreferenceEnum_milliliters;
  @BuiltValueEnumConst(wireName: r'Ounces')
  static const CompleteExternalRegistrationRequestUnitPreferenceEnum ounces = _$completeExternalRegistrationRequestUnitPreferenceEnum_ounces;
  @BuiltValueEnumConst(wireName: r'Centiliters')
  static const CompleteExternalRegistrationRequestUnitPreferenceEnum centiliters = _$completeExternalRegistrationRequestUnitPreferenceEnum_centiliters;

  static Serializer<CompleteExternalRegistrationRequestUnitPreferenceEnum> get serializer => _$completeExternalRegistrationRequestUnitPreferenceEnumSerializer;

  const CompleteExternalRegistrationRequestUnitPreferenceEnum._(String name): super(name);

  static BuiltSet<CompleteExternalRegistrationRequestUnitPreferenceEnum> get values => _$completeExternalRegistrationRequestUnitPreferenceEnumValues;
  static CompleteExternalRegistrationRequestUnitPreferenceEnum valueOf(String name) => _$completeExternalRegistrationRequestUnitPreferenceEnumValueOf(name);
}

