//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'backup_codes.g.dart';

/// BackupCodes
///
/// Properties:
/// * [backupCodes] 
@BuiltValue()
abstract class BackupCodes implements Built<BackupCodes, BackupCodesBuilder> {
  @BuiltValueField(wireName: r'backupCodes')
  BuiltList<String> get backupCodes;

  BackupCodes._();

  factory BackupCodes([void updates(BackupCodesBuilder b)]) = _$BackupCodes;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BackupCodesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BackupCodes> get serializer => _$BackupCodesSerializer();
}

class _$BackupCodesSerializer implements PrimitiveSerializer<BackupCodes> {
  @override
  final Iterable<Type> types = const [BackupCodes, _$BackupCodes];

  @override
  final String wireName = r'BackupCodes';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BackupCodes object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'backupCodes';
    yield serializers.serialize(
      object.backupCodes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BackupCodes object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BackupCodesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'backupCodes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.backupCodes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BackupCodes deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BackupCodesBuilder();
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

