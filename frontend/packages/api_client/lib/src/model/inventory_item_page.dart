//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/inventory_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_item_page.g.dart';

/// InventoryItemPage
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class InventoryItemPage implements Built<InventoryItemPage, InventoryItemPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<InventoryItem> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  InventoryItemPage._();

  factory InventoryItemPage([void updates(InventoryItemPageBuilder b)]) = _$InventoryItemPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryItemPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryItemPage> get serializer => _$InventoryItemPageSerializer();
}

class _$InventoryItemPageSerializer implements PrimitiveSerializer<InventoryItemPage> {
  @override
  final Iterable<Type> types = const [InventoryItemPage, _$InventoryItemPage];

  @override
  final String wireName = r'InventoryItemPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryItemPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(InventoryItem)]),
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
    InventoryItemPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryItemPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InventoryItem)]),
          ) as BuiltList<InventoryItem>;
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
  InventoryItemPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryItemPageBuilder();
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

