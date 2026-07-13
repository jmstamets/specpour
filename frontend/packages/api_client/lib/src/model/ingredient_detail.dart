//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ingredient_detail.g.dart';

/// IngredientDetail
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [parentId] 
/// * [parentName] - Resolved parent-ingredient name (contract sweep).
/// * [sources] 
/// * [description] 
/// * [abvPercent] 
/// * [allergens] 
/// * [definingRecipeId] 
/// * [definingRecipeName] - Resolved defining-recipe name for house-made ingredients (contract sweep).
/// * [yieldQuantity] 
/// * [yieldUnit] 
/// * [shelfLife] - ISO 8601 duration, when this is a house-made ingredient.
/// * [storageInstructions] 
@BuiltValue()
abstract class IngredientDetail implements Built<IngredientDetail, IngredientDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'parentId')
  String? get parentId;

  /// Resolved parent-ingredient name (contract sweep).
  @BuiltValueField(wireName: r'parentName')
  String? get parentName;

  @BuiltValueField(wireName: r'sources')
  BuiltList<String> get sources;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'abvPercent')
  num? get abvPercent;

  @BuiltValueField(wireName: r'allergens')
  BuiltList<String> get allergens;

  @BuiltValueField(wireName: r'definingRecipeId')
  String? get definingRecipeId;

  /// Resolved defining-recipe name for house-made ingredients (contract sweep).
  @BuiltValueField(wireName: r'definingRecipeName')
  String? get definingRecipeName;

  @BuiltValueField(wireName: r'yieldQuantity')
  num? get yieldQuantity;

  @BuiltValueField(wireName: r'yieldUnit')
  String? get yieldUnit;

  /// ISO 8601 duration, when this is a house-made ingredient.
  @BuiltValueField(wireName: r'shelfLife')
  String? get shelfLife;

  @BuiltValueField(wireName: r'storageInstructions')
  String? get storageInstructions;

  IngredientDetail._();

  factory IngredientDetail([void updates(IngredientDetailBuilder b)]) = _$IngredientDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IngredientDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IngredientDetail> get serializer => _$IngredientDetailSerializer();
}

class _$IngredientDetailSerializer implements PrimitiveSerializer<IngredientDetail> {
  @override
  final Iterable<Type> types = const [IngredientDetail, _$IngredientDetail];

  @override
  final String wireName = r'IngredientDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IngredientDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.parentId != null) {
      yield r'parentId';
      yield serializers.serialize(
        object.parentId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.parentName != null) {
      yield r'parentName';
      yield serializers.serialize(
        object.parentName,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'sources';
    yield serializers.serialize(
      object.sources,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.abvPercent != null) {
      yield r'abvPercent';
      yield serializers.serialize(
        object.abvPercent,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'allergens';
    yield serializers.serialize(
      object.allergens,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.definingRecipeId != null) {
      yield r'definingRecipeId';
      yield serializers.serialize(
        object.definingRecipeId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.definingRecipeName != null) {
      yield r'definingRecipeName';
      yield serializers.serialize(
        object.definingRecipeName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.yieldQuantity != null) {
      yield r'yieldQuantity';
      yield serializers.serialize(
        object.yieldQuantity,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.yieldUnit != null) {
      yield r'yieldUnit';
      yield serializers.serialize(
        object.yieldUnit,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.shelfLife != null) {
      yield r'shelfLife';
      yield serializers.serialize(
        object.shelfLife,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.storageInstructions != null) {
      yield r'storageInstructions';
      yield serializers.serialize(
        object.storageInstructions,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    IngredientDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IngredientDetailBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'parentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        case r'parentName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parentName = valueDes;
          break;
        case r'sources':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.sources.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'abvPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.abvPercent = valueDes;
          break;
        case r'allergens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.allergens.replace(valueDes);
          break;
        case r'definingRecipeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.yieldQuantity = valueDes;
          break;
        case r'yieldUnit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.yieldUnit = valueDes;
          break;
        case r'shelfLife':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.shelfLife = valueDes;
          break;
        case r'storageInstructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  IngredientDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IngredientDetailBuilder();
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

