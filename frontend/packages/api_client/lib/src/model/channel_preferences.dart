//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/channel_preference.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'channel_preferences.g.dart';

/// ChannelPreferences
///
/// Properties:
/// * [channels] 
@BuiltValue()
abstract class ChannelPreferences implements Built<ChannelPreferences, ChannelPreferencesBuilder> {
  @BuiltValueField(wireName: r'channels')
  BuiltList<ChannelPreference> get channels;

  ChannelPreferences._();

  factory ChannelPreferences([void updates(ChannelPreferencesBuilder b)]) = _$ChannelPreferences;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChannelPreferencesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChannelPreferences> get serializer => _$ChannelPreferencesSerializer();
}

class _$ChannelPreferencesSerializer implements PrimitiveSerializer<ChannelPreferences> {
  @override
  final Iterable<Type> types = const [ChannelPreferences, _$ChannelPreferences];

  @override
  final String wireName = r'ChannelPreferences';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChannelPreferences object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channels';
    yield serializers.serialize(
      object.channels,
      specifiedType: const FullType(BuiltList, [FullType(ChannelPreference)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChannelPreferences object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChannelPreferencesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channels':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChannelPreference)]),
          ) as BuiltList<ChannelPreference>;
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
  ChannelPreferences deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChannelPreferencesBuilder();
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

