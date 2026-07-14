//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'channel_preferences_update_channels_inner.g.dart';

/// ChannelPreferencesUpdateChannelsInner
///
/// Properties:
/// * [channel] 
/// * [optedIn] 
@BuiltValue()
abstract class ChannelPreferencesUpdateChannelsInner implements Built<ChannelPreferencesUpdateChannelsInner, ChannelPreferencesUpdateChannelsInnerBuilder> {
  @BuiltValueField(wireName: r'channel')
  ChannelPreferencesUpdateChannelsInnerChannelEnum get channel;
  // enum channelEnum {  email,  push,  };

  @BuiltValueField(wireName: r'optedIn')
  bool get optedIn;

  ChannelPreferencesUpdateChannelsInner._();

  factory ChannelPreferencesUpdateChannelsInner([void updates(ChannelPreferencesUpdateChannelsInnerBuilder b)]) = _$ChannelPreferencesUpdateChannelsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChannelPreferencesUpdateChannelsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChannelPreferencesUpdateChannelsInner> get serializer => _$ChannelPreferencesUpdateChannelsInnerSerializer();
}

class _$ChannelPreferencesUpdateChannelsInnerSerializer implements PrimitiveSerializer<ChannelPreferencesUpdateChannelsInner> {
  @override
  final Iterable<Type> types = const [ChannelPreferencesUpdateChannelsInner, _$ChannelPreferencesUpdateChannelsInner];

  @override
  final String wireName = r'ChannelPreferencesUpdateChannelsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChannelPreferencesUpdateChannelsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(ChannelPreferencesUpdateChannelsInnerChannelEnum),
    );
    yield r'optedIn';
    yield serializers.serialize(
      object.optedIn,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChannelPreferencesUpdateChannelsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChannelPreferencesUpdateChannelsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChannelPreferencesUpdateChannelsInnerChannelEnum),
          ) as ChannelPreferencesUpdateChannelsInnerChannelEnum;
          result.channel = valueDes;
          break;
        case r'optedIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.optedIn = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChannelPreferencesUpdateChannelsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChannelPreferencesUpdateChannelsInnerBuilder();
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

class ChannelPreferencesUpdateChannelsInnerChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'email')
  static const ChannelPreferencesUpdateChannelsInnerChannelEnum email = _$channelPreferencesUpdateChannelsInnerChannelEnum_email;
  @BuiltValueEnumConst(wireName: r'push')
  static const ChannelPreferencesUpdateChannelsInnerChannelEnum push = _$channelPreferencesUpdateChannelsInnerChannelEnum_push;

  static Serializer<ChannelPreferencesUpdateChannelsInnerChannelEnum> get serializer => _$channelPreferencesUpdateChannelsInnerChannelEnumSerializer;

  const ChannelPreferencesUpdateChannelsInnerChannelEnum._(String name): super(name);

  static BuiltSet<ChannelPreferencesUpdateChannelsInnerChannelEnum> get values => _$channelPreferencesUpdateChannelsInnerChannelEnumValues;
  static ChannelPreferencesUpdateChannelsInnerChannelEnum valueOf(String name) => _$channelPreferencesUpdateChannelsInnerChannelEnumValueOf(name);
}

