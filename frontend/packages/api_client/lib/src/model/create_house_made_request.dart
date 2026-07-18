//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_house_made_request.g.dart';

/// FR-017 — a house-made ingredient's defining recipe, yield, shelf life, and storage instructions.
///
/// Properties:
/// * [definingRecipeId] 
/// * [yieldQuantity] 
/// * [yieldUnit] 
/// * [shelfLifeDays] 
/// * [storageInstructions] 
@BuiltValue()
abstract class CreateHouseMadeRequest implements Built<CreateHouseMadeRequest, CreateHouseMadeRequestBuilder> {
  @BuiltValueField(wireName: r'definingRecipeId')
  String get definingRecipeId;

  @BuiltValueField(wireName: r'yieldQuantity')
  num get yieldQuantity;

  @BuiltValueField(wireName: r'yieldUnit')
  String get yieldUnit;

  @BuiltValueField(wireName: r'shelfLifeDays')
  int get shelfLifeDays;

  @BuiltValueField(wireName: r'storageInstructions')
  String get storageInstructions;

  CreateHouseMadeRequest._();

  factory CreateHouseMadeRequest([void updates(CreateHouseMadeRequestBuilder b)]) = _$CreateHouseMadeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateHouseMadeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateHouseMadeRequest> get serializer => _$CreateHouseMadeRequestSerializer();
}

class _$CreateHouseMadeRequestSerializer implements PrimitiveSerializer<CreateHouseMadeRequest> {
  @override
  final Iterable<Type> types = const [CreateHouseMadeRequest, _$CreateHouseMadeRequest];

  @override
  final String wireName = r'CreateHouseMadeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateHouseMadeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'definingRecipeId';
    yield serializers.serialize(
      object.definingRecipeId,
      specifiedType: const FullType(String),
    );
    yield r'yieldQuantity';
    yield serializers.serialize(
      object.yieldQuantity,
      specifiedType: const FullType(num),
    );
    yield r'yieldUnit';
    yield serializers.serialize(
      object.yieldUnit,
      specifiedType: const FullType(String),
    );
    yield r'shelfLifeDays';
    yield serializers.serialize(
      object.shelfLifeDays,
      specifiedType: const FullType(int),
    );
    yield r'storageInstructions';
    yield serializers.serialize(
      object.storageInstructions,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateHouseMadeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateHouseMadeRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'definingRecipeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.definingRecipeId = valueDes;
          break;
        case r'yieldQuantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.yieldQuantity = valueDes;
          break;
        case r'yieldUnit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.yieldUnit = valueDes;
          break;
        case r'shelfLifeDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.shelfLifeDays = valueDes;
          break;
        case r'storageInstructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storageInstructions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateHouseMadeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateHouseMadeRequestBuilder();
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

