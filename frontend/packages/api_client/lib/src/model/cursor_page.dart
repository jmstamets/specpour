//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cursor_page.g.dart';

/// Generic cursor-paginated envelope documenting the pagination convention. Per-endpoint response schemas MIRROR this shape as their own named schema with a concrete `items` type (e.g. notifications.yaml's InboxPage) rather than allOf-composing this one: the open `items: {}` here maps to built_value JsonObject in the dart-dio generator, and allOf-merging it into a typed page produces synthesized models with missing imports (broken generated code).
///
/// Properties:
/// * [items] 
/// * [nextCursor] - Pass as `cursor` to fetch the next page; null when no further pages exist.
@BuiltValue()
abstract class CursorPage implements Built<CursorPage, CursorPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<JsonObject?> get items;

  /// Pass as `cursor` to fetch the next page; null when no further pages exist.
  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  CursorPage._();

  factory CursorPage([void updates(CursorPageBuilder b)]) = _$CursorPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CursorPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CursorPage> get serializer => _$CursorPageSerializer();
}

class _$CursorPageSerializer implements PrimitiveSerializer<CursorPage> {
  @override
  final Iterable<Type> types = const [CursorPage, _$CursorPage];

  @override
  final String wireName = r'CursorPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CursorPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType.nullable(JsonObject)]),
    );
    if (object.nextCursor != null) {
      yield r'nextCursor';
      yield serializers.serialize(
        object.nextCursor,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CursorPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CursorPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(JsonObject)]),
          ) as BuiltList<JsonObject?>;
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
  CursorPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CursorPageBuilder();
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

