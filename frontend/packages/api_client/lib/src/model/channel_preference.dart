//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'channel_preference.g.dart';

/// ChannelPreference
///
/// Properties:
/// * [channel] 
/// * [optedIn] 
/// * [updatedAt] 
@BuiltValue()
abstract class ChannelPreference implements Built<ChannelPreference, ChannelPreferenceBuilder> {
  @BuiltValueField(wireName: r'channel')
  ChannelPreferenceChannelEnum get channel;
  // enum channelEnum {  email,  push,  };

  @BuiltValueField(wireName: r'optedIn')
  bool get optedIn;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  ChannelPreference._();

  factory ChannelPreference([void updates(ChannelPreferenceBuilder b)]) = _$ChannelPreference;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChannelPreferenceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChannelPreference> get serializer => _$ChannelPreferenceSerializer();
}

class _$ChannelPreferenceSerializer implements PrimitiveSerializer<ChannelPreference> {
  @override
  final Iterable<Type> types = const [ChannelPreference, _$ChannelPreference];

  @override
  final String wireName = r'ChannelPreference';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChannelPreference object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(ChannelPreferenceChannelEnum),
    );
    yield r'optedIn';
    yield serializers.serialize(
      object.optedIn,
      specifiedType: const FullType(bool),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChannelPreference object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChannelPreferenceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChannelPreferenceChannelEnum),
          ) as ChannelPreferenceChannelEnum;
          result.channel = valueDes;
          break;
        case r'optedIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.optedIn = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChannelPreference deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChannelPreferenceBuilder();
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

class ChannelPreferenceChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'email')
  static const ChannelPreferenceChannelEnum email = _$channelPreferenceChannelEnum_email;
  @BuiltValueEnumConst(wireName: r'push')
  static const ChannelPreferenceChannelEnum push = _$channelPreferenceChannelEnum_push;

  static Serializer<ChannelPreferenceChannelEnum> get serializer => _$channelPreferenceChannelEnumSerializer;

  const ChannelPreferenceChannelEnum._(String name): super(name);

  static BuiltSet<ChannelPreferenceChannelEnum> get values => _$channelPreferenceChannelEnumValues;
  static ChannelPreferenceChannelEnum valueOf(String name) => _$channelPreferenceChannelEnumValueOf(name);
}

