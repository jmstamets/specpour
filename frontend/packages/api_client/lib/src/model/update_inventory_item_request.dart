//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_inventory_item_request.g.dart';

/// UpdateInventoryItemRequest
///
/// Properties:
/// * [quantity] 
/// * [bottleSize] 
@BuiltValue()
abstract class UpdateInventoryItemRequest implements Built<UpdateInventoryItemRequest, UpdateInventoryItemRequestBuilder> {
  @BuiltValueField(wireName: r'quantity')
  num? get quantity;

  @BuiltValueField(wireName: r'bottleSize')
  String? get bottleSize;

  UpdateInventoryItemRequest._();

  factory UpdateInventoryItemRequest([void updates(UpdateInventoryItemRequestBuilder b)]) = _$UpdateInventoryItemRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateInventoryItemRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateInventoryItemRequest> get serializer => _$UpdateInventoryItemRequestSerializer();
}

class _$UpdateInventoryItemRequestSerializer implements PrimitiveSerializer<UpdateInventoryItemRequest> {
  @override
  final Iterable<Type> types = const [UpdateInventoryItemRequest, _$UpdateInventoryItemRequest];

  @override
  final String wireName = r'UpdateInventoryItemRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateInventoryItemRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateInventoryItemRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateInventoryItemRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateInventoryItemRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateInventoryItemRequestBuilder();
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

