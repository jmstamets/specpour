//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'house_made.g.dart';

/// HouseMade
///
/// Properties:
/// * [definingRecipeId] 
/// * [definingRecipeName] 
/// * [yieldQuantity] 
/// * [yieldUnit] 
/// * [shelfLifeDays] 
/// * [storageInstructions] 
@BuiltValue()
abstract class HouseMade implements Built<HouseMade, HouseMadeBuilder> {
  @BuiltValueField(wireName: r'definingRecipeId')
  String get definingRecipeId;

  @BuiltValueField(wireName: r'definingRecipeName')
  String? get definingRecipeName;

  @BuiltValueField(wireName: r'yieldQuantity')
  num get yieldQuantity;

  @BuiltValueField(wireName: r'yieldUnit')
  String get yieldUnit;

  @BuiltValueField(wireName: r'shelfLifeDays')
  int get shelfLifeDays;

  @BuiltValueField(wireName: r'storageInstructions')
  String get storageInstructions;

  HouseMade._();

  factory HouseMade([void updates(HouseMadeBuilder b)]) = _$HouseMade;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HouseMadeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HouseMade> get serializer => _$HouseMadeSerializer();
}

class _$HouseMadeSerializer implements PrimitiveSerializer<HouseMade> {
  @override
  final Iterable<Type> types = const [HouseMade, _$HouseMade];

  @override
  final String wireName = r'HouseMade';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HouseMade object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'definingRecipeId';
    yield serializers.serialize(
      object.definingRecipeId,
      specifiedType: const FullType(String),
    );
    if (object.definingRecipeName != null) {
      yield r'definingRecipeName';
      yield serializers.serialize(
        object.definingRecipeName,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    HouseMade object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required HouseMadeBuilder result,
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
        case r'definingRecipeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.definingRecipeName = valueDes;
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
  HouseMade deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HouseMadeBuilder();
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

