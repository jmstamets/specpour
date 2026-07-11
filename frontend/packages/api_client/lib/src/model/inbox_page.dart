//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/inbox_message.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inbox_page.g.dart';

/// Cursor-paginated inbox page. Mirrors the CursorPage envelope convention (openapi.yaml) with a concrete item type — declared as its own named schema rather than allOf-composing CursorPage, per the envelope's usage note.
///
/// Properties:
/// * [items] 
/// * [nextCursor] - Pass as `cursor` to fetch the next page; null when no further pages exist.
@BuiltValue()
abstract class InboxPage implements Built<InboxPage, InboxPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<InboxMessage> get items;

  /// Pass as `cursor` to fetch the next page; null when no further pages exist.
  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  InboxPage._();

  factory InboxPage([void updates(InboxPageBuilder b)]) = _$InboxPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InboxPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InboxPage> get serializer => _$InboxPageSerializer();
}

class _$InboxPageSerializer implements PrimitiveSerializer<InboxPage> {
  @override
  final Iterable<Type> types = const [InboxPage, _$InboxPage];

  @override
  final String wireName = r'InboxPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InboxPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(InboxMessage)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InboxPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InboxPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InboxMessage)]),
          ) as BuiltList<InboxMessage>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InboxPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InboxPageBuilder();
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

