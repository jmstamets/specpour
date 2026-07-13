//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'responsible_consumption_message_response.g.dart';

/// ResponsibleConsumptionMessageResponse
///
/// Properties:
/// * [surface] 
/// * [jurisdictionCode] 
/// * [placement] 
/// * [messageContentKey] - i18n key for the message copy — resolved client-side, never hard-coded.
@BuiltValue()
abstract class ResponsibleConsumptionMessageResponse implements Built<ResponsibleConsumptionMessageResponse, ResponsibleConsumptionMessageResponseBuilder> {
  @BuiltValueField(wireName: r'surface')
  String get surface;

  @BuiltValueField(wireName: r'jurisdictionCode')
  String get jurisdictionCode;

  @BuiltValueField(wireName: r'placement')
  String get placement;

  /// i18n key for the message copy — resolved client-side, never hard-coded.
  @BuiltValueField(wireName: r'messageContentKey')
  String get messageContentKey;

  ResponsibleConsumptionMessageResponse._();

  factory ResponsibleConsumptionMessageResponse([void updates(ResponsibleConsumptionMessageResponseBuilder b)]) = _$ResponsibleConsumptionMessageResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResponsibleConsumptionMessageResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResponsibleConsumptionMessageResponse> get serializer => _$ResponsibleConsumptionMessageResponseSerializer();
}

class _$ResponsibleConsumptionMessageResponseSerializer implements PrimitiveSerializer<ResponsibleConsumptionMessageResponse> {
  @override
  final Iterable<Type> types = const [ResponsibleConsumptionMessageResponse, _$ResponsibleConsumptionMessageResponse];

  @override
  final String wireName = r'ResponsibleConsumptionMessageResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResponsibleConsumptionMessageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'surface';
    yield serializers.serialize(
      object.surface,
      specifiedType: const FullType(String),
    );
    yield r'jurisdictionCode';
    yield serializers.serialize(
      object.jurisdictionCode,
      specifiedType: const FullType(String),
    );
    yield r'placement';
    yield serializers.serialize(
      object.placement,
      specifiedType: const FullType(String),
    );
    yield r'messageContentKey';
    yield serializers.serialize(
      object.messageContentKey,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ResponsibleConsumptionMessageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResponsibleConsumptionMessageResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'surface':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.surface = valueDes;
          break;
        case r'jurisdictionCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.jurisdictionCode = valueDes;
          break;
        case r'placement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.placement = valueDes;
          break;
        case r'messageContentKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.messageContentKey = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResponsibleConsumptionMessageResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResponsibleConsumptionMessageResponseBuilder();
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

