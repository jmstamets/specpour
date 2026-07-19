//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_item.g.dart';

/// Owner-only from birth (FR-029) — no visibility/public variant exists for this type at all, unlike Recipe/Ingredient/Equipment.
///
/// Properties:
/// * [id] 
/// * [ingredientId] 
/// * [ingredientName] 
/// * [quantity] 
/// * [bottleSize] 
/// * [source_] 
/// * [addedAt] 
@BuiltValue()
abstract class InventoryItem implements Built<InventoryItem, InventoryItemBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'ingredientId')
  String get ingredientId;

  @BuiltValueField(wireName: r'ingredientName')
  String? get ingredientName;

  @BuiltValueField(wireName: r'quantity')
  num? get quantity;

  @BuiltValueField(wireName: r'bottleSize')
  String? get bottleSize;

  @BuiltValueField(wireName: r'source')
  InventoryItemSource_Enum get source_;
  // enum source_Enum {  photo-recognition,  barcode,  manual,  prep,  };

  @BuiltValueField(wireName: r'addedAt')
  DateTime get addedAt;

  InventoryItem._();

  factory InventoryItem([void updates(InventoryItemBuilder b)]) = _$InventoryItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryItem> get serializer => _$InventoryItemSerializer();
}

class _$InventoryItemSerializer implements PrimitiveSerializer<InventoryItem> {
  @override
  final Iterable<Type> types = const [InventoryItem, _$InventoryItem];

  @override
  final String wireName = r'InventoryItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'ingredientId';
    yield serializers.serialize(
      object.ingredientId,
      specifiedType: const FullType(String),
    );
    if (object.ingredientName != null) {
      yield r'ingredientName';
      yield serializers.serialize(
        object.ingredientName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.quantity != null) {
      yield r'quantity';
      yield serializers.serialize(
        object.quantity,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.bottleSize != null) {
      yield r'bottleSize';
      yield serializers.serialize(
        object.bottleSize,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(InventoryItemSource_Enum),
    );
    yield r'addedAt';
    yield serializers.serialize(
      object.addedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryItemBuilder result,
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
        case r'ingredientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ingredientId = valueDes;
          break;
        case r'ingredientName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ingredientName = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.quantity = valueDes;
          break;
        case r'bottleSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bottleSize = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventoryItemSource_Enum),
          ) as InventoryItemSource_Enum;
          result.source_ = valueDes;
          break;
        case r'addedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.addedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryItemBuilder();
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

class InventoryItemSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'photo-recognition')
  static const InventoryItemSource_Enum photoRecognition = _$inventoryItemSourceEnum_photoRecognition;
  @BuiltValueEnumConst(wireName: r'barcode')
  static const InventoryItemSource_Enum barcode = _$inventoryItemSourceEnum_barcode;
  @BuiltValueEnumConst(wireName: r'manual')
  static const InventoryItemSource_Enum manual = _$inventoryItemSourceEnum_manual;
  @BuiltValueEnumConst(wireName: r'prep')
  static const InventoryItemSource_Enum prep = _$inventoryItemSourceEnum_prep;

  static Serializer<InventoryItemSource_Enum> get serializer => _$inventoryItemSourceEnumSerializer;

  const InventoryItemSource_Enum._(String name): super(name);

  static BuiltSet<InventoryItemSource_Enum> get values => _$inventoryItemSourceEnumValues;
  static InventoryItemSource_Enum valueOf(String name) => _$inventoryItemSourceEnumValueOf(name);
}

