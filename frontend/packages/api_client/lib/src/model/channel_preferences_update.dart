//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/channel_preferences_update_channels_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'channel_preferences_update.g.dart';

/// ChannelPreferencesUpdate
///
/// Properties:
/// * [channels] 
@BuiltValue()
abstract class ChannelPreferencesUpdate implements Built<ChannelPreferencesUpdate, ChannelPreferencesUpdateBuilder> {
  @BuiltValueField(wireName: r'channels')
  BuiltList<ChannelPreferencesUpdateChannelsInner> get channels;

  ChannelPreferencesUpdate._();

  factory ChannelPreferencesUpdate([void updates(ChannelPreferencesUpdateBuilder b)]) = _$ChannelPreferencesUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChannelPreferencesUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChannelPreferencesUpdate> get serializer => _$ChannelPreferencesUpdateSerializer();
}

class _$ChannelPreferencesUpdateSerializer implements PrimitiveSerializer<ChannelPreferencesUpdate> {
  @override
  final Iterable<Type> types = const [ChannelPreferencesUpdate, _$ChannelPreferencesUpdate];

  @override
  final String wireName = r'ChannelPreferencesUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChannelPreferencesUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channels';
    yield serializers.serialize(
      object.channels,
      specifiedType: const FullType(BuiltList, [FullType(ChannelPreferencesUpdateChannelsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChannelPreferencesUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChannelPreferencesUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channels':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChannelPreferencesUpdateChannelsInner)]),
          ) as BuiltList<ChannelPreferencesUpdateChannelsInner>;
          result.channels.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChannelPreferencesUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChannelPreferencesUpdateBuilder();
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

