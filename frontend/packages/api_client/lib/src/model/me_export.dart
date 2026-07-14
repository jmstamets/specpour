//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/session.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'me_export.g.dart';

/// The sole schema in this document allowed a raw dateOfBirth field (see this document's top-level description and SensitivePiiInvariantTests's allowlist).
///
/// Properties:
/// * [userId] 
/// * [email] 
/// * [displayName] 
/// * [dateOfBirth] 
/// * [unitPreference] 
/// * [locale] 
/// * [createdAt] 
/// * [mfaEnabled] 
/// * [sessions] 
/// * [externalLoginProviders] 
@BuiltValue()
abstract class MeExport implements Built<MeExport, MeExportBuilder> {
  @BuiltValueField(wireName: r'userId')
  String get userId;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'dateOfBirth')
  Date get dateOfBirth;

  @BuiltValueField(wireName: r'unitPreference')
  MeExportUnitPreferenceEnum get unitPreference;
  // enum unitPreferenceEnum {  Milliliters,  Ounces,  Centiliters,  };

  @BuiltValueField(wireName: r'locale')
  String get locale;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'mfaEnabled')
  bool get mfaEnabled;

  @BuiltValueField(wireName: r'sessions')
  BuiltList<Session> get sessions;

  @BuiltValueField(wireName: r'externalLoginProviders')
  BuiltList<String> get externalLoginProviders;

  MeExport._();

  factory MeExport([void updates(MeExportBuilder b)]) = _$MeExport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeExportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MeExport> get serializer => _$MeExportSerializer();
}

class _$MeExportSerializer implements PrimitiveSerializer<MeExport> {
  @override
  final Iterable<Type> types = const [MeExport, _$MeExport];

  @override
  final String wireName = r'MeExport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MeExport object, {
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
    yield r'dateOfBirth';
    yield serializers.serialize(
      object.dateOfBirth,
      specifiedType: const FullType(Date),
    );
    yield r'unitPreference';
    yield serializers.serialize(
      object.unitPreference,
      specifiedType: const FullType(MeExportUnitPreferenceEnum),
    );
    yield r'locale';
    yield serializers.serialize(
      object.locale,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'mfaEnabled';
    yield serializers.serialize(
      object.mfaEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'sessions';
    yield serializers.serialize(
      object.sessions,
      specifiedType: const FullType(BuiltList, [FullType(Session)]),
    );
    yield r'externalLoginProviders';
    yield serializers.serialize(
      object.externalLoginProviders,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MeExport object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MeExportBuilder result,
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
            specifiedType: const FullType(MeExportUnitPreferenceEnum),
          ) as MeExportUnitPreferenceEnum;
          result.unitPreference = valueDes;
          break;
        case r'locale':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.locale = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'mfaEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mfaEnabled = valueDes;
          break;
        case r'sessions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Session)]),
          ) as BuiltList<Session>;
          result.sessions.replace(valueDes);
          break;
        case r'externalLoginProviders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.externalLoginProviders.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MeExport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeExportBuilder();
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

class MeExportUnitPreferenceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Milliliters')
  static const MeExportUnitPreferenceEnum milliliters = _$meExportUnitPreferenceEnum_milliliters;
  @BuiltValueEnumConst(wireName: r'Ounces')
  static const MeExportUnitPreferenceEnum ounces = _$meExportUnitPreferenceEnum_ounces;
  @BuiltValueEnumConst(wireName: r'Centiliters')
  static const MeExportUnitPreferenceEnum centiliters = _$meExportUnitPreferenceEnum_centiliters;

  static Serializer<MeExportUnitPreferenceEnum> get serializer => _$meExportUnitPreferenceEnumSerializer;

  const MeExportUnitPreferenceEnum._(String name): super(name);

  static BuiltSet<MeExportUnitPreferenceEnum> get values => _$meExportUnitPreferenceEnumValues;
  static MeExportUnitPreferenceEnum valueOf(String name) => _$meExportUnitPreferenceEnumValueOf(name);
}

