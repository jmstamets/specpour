//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/equipment_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'equipment_page.g.dart';

/// EquipmentPage
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class EquipmentPage implements Built<EquipmentPage, EquipmentPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<EquipmentSummary> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  EquipmentPage._();

  factory EquipmentPage([void updates(EquipmentPageBuilder b)]) = _$EquipmentPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EquipmentPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EquipmentPage> get serializer => _$EquipmentPageSerializer();
}

class _$EquipmentPageSerializer implements PrimitiveSerializer<EquipmentPage> {
  @override
  final Iterable<Type> types = const [EquipmentPage, _$EquipmentPage];

  @override
  final String wireName = r'EquipmentPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EquipmentPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(EquipmentSummary)]),
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
    EquipmentPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EquipmentPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EquipmentSummary)]),
          ) as BuiltList<EquipmentSummary>;
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
  EquipmentPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EquipmentPageBuilder();
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

