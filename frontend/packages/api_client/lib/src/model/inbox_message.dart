//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inbox_message.g.dart';

/// InboxMessage
///
/// Properties:
/// * [id] 
/// * [type] - Typed notification key (e.g. \"prep_expiry\", \"account_deactivation_warning\").
/// * [payload] - Type-specific structured payload.
/// * [createdAt] 
/// * [readAt] 
@BuiltValue()
abstract class InboxMessage implements Built<InboxMessage, InboxMessageBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Typed notification key (e.g. \"prep_expiry\", \"account_deactivation_warning\").
  @BuiltValueField(wireName: r'type')
  String get type;

  /// Type-specific structured payload.
  @BuiltValueField(wireName: r'payload')
  BuiltMap<String, JsonObject?> get payload;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'readAt')
  DateTime? get readAt;

  InboxMessage._();

  factory InboxMessage([void updates(InboxMessageBuilder b)]) = _$InboxMessage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InboxMessageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InboxMessage> get serializer => _$InboxMessageSerializer();
}

class _$InboxMessageSerializer implements PrimitiveSerializer<InboxMessage> {
  @override
  final Iterable<Type> types = const [InboxMessage, _$InboxMessage];

  @override
  final String wireName = r'InboxMessage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InboxMessage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'payload';
    yield serializers.serialize(
      object.payload,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'readAt';
    yield object.readAt == null ? null : serializers.serialize(
      object.readAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InboxMessage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InboxMessageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'payload':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.payload.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'readAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.readAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InboxMessage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InboxMessageBuilder();
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

