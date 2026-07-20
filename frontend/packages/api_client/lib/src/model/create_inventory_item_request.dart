//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_inventory_item_request.g.dart';

/// CreateInventoryItemRequest
///
/// Properties:
/// * [ingredientId] 
/// * [venueId] - Omit for the caller's personal inventory; provide to add to a venue's inventory the caller owns.
/// * [quantity] 
/// * [bottleSize] 
/// * [source_] 
@BuiltValue()
abstract class CreateInventoryItemRequest implements Built<CreateInventoryItemRequest, CreateInventoryItemRequestBuilder> {
  @BuiltValueField(wireName: r'ingredientId')
  String get ingredientId;

  /// Omit for the caller's personal inventory; provide to add to a venue's inventory the caller owns.
  @BuiltValueField(wireName: r'venueId')
  String? get venueId;

  @BuiltValueField(wireName: r'quantity')
  num? get quantity;

  @BuiltValueField(wireName: r'bottleSize')
  String? get bottleSize;

  @BuiltValueField(wireName: r'source')
  CreateInventoryItemRequestSource_Enum get source_;
  // enum source_Enum {  photo-recognition,  barcode,  manual,  prep,  };

  CreateInventoryItemRequest._();

  factory CreateInventoryItemRequest([void updates(CreateInventoryItemRequestBuilder b)]) = _$CreateInventoryItemRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateInventoryItemRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateInventoryItemRequest> get serializer => _$CreateInventoryItemRequestSerializer();
}

class _$CreateInventoryItemRequestSerializer implements PrimitiveSerializer<CreateInventoryItemRequest> {
  @override
  final Iterable<Type> types = const [CreateInventoryItemRequest, _$CreateInventoryItemRequest];

  @override
  final String wireName = r'CreateInventoryItemRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateInventoryItemRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ingredientId';
    yield serializers.serialize(
      object.ingredientId,
      specifiedType: const FullType(String),
    );
    if (object.venueId != null) {
      yield r'venueId';
      yield serializers.serialize(
        object.venueId,
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
      specifiedType: const FullType(CreateInventoryItemRequestSource_Enum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateInventoryItemRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateInventoryItemRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ingredientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ingredientId = valueDes;
          break;
        case r'venueId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.venueId = valueDes;
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
            specifiedType: const FullType(CreateInventoryItemRequestSource_Enum),
          ) as CreateInventoryItemRequestSource_Enum;
          result.source_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateInventoryItemRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateInventoryItemRequestBuilder();
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

class CreateInventoryItemRequestSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'photo-recognition')
  static const CreateInventoryItemRequestSource_Enum photoRecognition = _$createInventoryItemRequestSourceEnum_photoRecognition;
  @BuiltValueEnumConst(wireName: r'barcode')
  static const CreateInventoryItemRequestSource_Enum barcode = _$createInventoryItemRequestSourceEnum_barcode;
  @BuiltValueEnumConst(wireName: r'manual')
  static const CreateInventoryItemRequestSource_Enum manual = _$createInventoryItemRequestSourceEnum_manual;
  @BuiltValueEnumConst(wireName: r'prep')
  static const CreateInventoryItemRequestSource_Enum prep = _$createInventoryItemRequestSourceEnum_prep;

  static Serializer<CreateInventoryItemRequestSource_Enum> get serializer => _$createInventoryItemRequestSourceEnumSerializer;

  const CreateInventoryItemRequestSource_Enum._(String name): super(name);

  static BuiltSet<CreateInventoryItemRequestSource_Enum> get values => _$createInventoryItemRequestSourceEnumValues;
  static CreateInventoryItemRequestSource_Enum valueOf(String name) => _$createInventoryItemRequestSourceEnumValueOf(name);
}

