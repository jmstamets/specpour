//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/equipment_ref.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/recipe_ingredient_line.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_detail.g.dart';

/// RecipeDetail
///
/// Properties:
/// * [id] 
/// * [primaryName] 
/// * [alternateNames] 
/// * [familyKey] 
/// * [categoryKeys] 
/// * [flavorProfileKeys] 
/// * [tags] 
/// * [ingredientLines] 
/// * [instructions] 
/// * [garnishes] 
/// * [iceSpec] 
/// * [glassware] 
/// * [equipment] 
/// * [creatorAttribution] 
/// * [history] 
/// * [notes] 
/// * [abvPercent] - Derived — never stored, computed at read time from ingredient composition and method dilution (FR-022).
/// * [standardDrinks] 
/// * [allergens] - Rolled up from ingredient allergen attributes, conservative for uncertain (FR-055).
@BuiltValue()
abstract class RecipeDetail implements Built<RecipeDetail, RecipeDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'primaryName')
  String get primaryName;

  @BuiltValueField(wireName: r'alternateNames')
  BuiltList<String> get alternateNames;

  @BuiltValueField(wireName: r'familyKey')
  String? get familyKey;

  @BuiltValueField(wireName: r'categoryKeys')
  BuiltList<String>? get categoryKeys;

  @BuiltValueField(wireName: r'flavorProfileKeys')
  BuiltList<String>? get flavorProfileKeys;

  @BuiltValueField(wireName: r'tags')
  BuiltList<String>? get tags;

  @BuiltValueField(wireName: r'ingredientLines')
  BuiltList<RecipeIngredientLine> get ingredientLines;

  @BuiltValueField(wireName: r'instructions')
  BuiltList<String> get instructions;

  @BuiltValueField(wireName: r'garnishes')
  BuiltList<String>? get garnishes;

  @BuiltValueField(wireName: r'iceSpec')
  String get iceSpec;

  @BuiltValueField(wireName: r'glassware')
  BuiltList<EquipmentRef> get glassware;

  @BuiltValueField(wireName: r'equipment')
  BuiltList<EquipmentRef> get equipment;

  @BuiltValueField(wireName: r'creatorAttribution')
  String? get creatorAttribution;

  @BuiltValueField(wireName: r'history')
  String? get history;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  /// Derived — never stored, computed at read time from ingredient composition and method dilution (FR-022).
  @BuiltValueField(wireName: r'abvPercent')
  num get abvPercent;

  @BuiltValueField(wireName: r'standardDrinks')
  num get standardDrinks;

  /// Rolled up from ingredient allergen attributes, conservative for uncertain (FR-055).
  @BuiltValueField(wireName: r'allergens')
  BuiltList<String> get allergens;

  RecipeDetail._();

  factory RecipeDetail([void updates(RecipeDetailBuilder b)]) = _$RecipeDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeDetail> get serializer => _$RecipeDetailSerializer();
}

class _$RecipeDetailSerializer implements PrimitiveSerializer<RecipeDetail> {
  @override
  final Iterable<Type> types = const [RecipeDetail, _$RecipeDetail];

  @override
  final String wireName = r'RecipeDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'primaryName';
    yield serializers.serialize(
      object.primaryName,
      specifiedType: const FullType(String),
    );
    yield r'alternateNames';
    yield serializers.serialize(
      object.alternateNames,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.familyKey != null) {
      yield r'familyKey';
      yield serializers.serialize(
        object.familyKey,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.categoryKeys != null) {
      yield r'categoryKeys';
      yield serializers.serialize(
        object.categoryKeys,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.flavorProfileKeys != null) {
      yield r'flavorProfileKeys';
      yield serializers.serialize(
        object.flavorProfileKeys,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.tags != null) {
      yield r'tags';
      yield serializers.serialize(
        object.tags,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'ingredientLines';
    yield serializers.serialize(
      object.ingredientLines,
      specifiedType: const FullType(BuiltList, [FullType(RecipeIngredientLine)]),
    );
    yield r'instructions';
    yield serializers.serialize(
      object.instructions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.garnishes != null) {
      yield r'garnishes';
      yield serializers.serialize(
        object.garnishes,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'iceSpec';
    yield serializers.serialize(
      object.iceSpec,
      specifiedType: const FullType(String),
    );
    yield r'glassware';
    yield serializers.serialize(
      object.glassware,
      specifiedType: const FullType(BuiltList, [FullType(EquipmentRef)]),
    );
    yield r'equipment';
    yield serializers.serialize(
      object.equipment,
      specifiedType: const FullType(BuiltList, [FullType(EquipmentRef)]),
    );
    if (object.creatorAttribution != null) {
      yield r'creatorAttribution';
      yield serializers.serialize(
        object.creatorAttribution,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.history != null) {
      yield r'history';
      yield serializers.serialize(
        object.history,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'abvPercent';
    yield serializers.serialize(
      object.abvPercent,
      specifiedType: const FullType(num),
    );
    yield r'standardDrinks';
    yield serializers.serialize(
      object.standardDrinks,
      specifiedType: const FullType(num),
    );
    yield r'allergens';
    yield serializers.serialize(
      object.allergens,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecipeDetailBuilder result,
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
        case r'primaryName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.primaryName = valueDes;
          break;
        case r'alternateNames':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.alternateNames.replace(valueDes);
          break;
        case r'familyKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.familyKey = valueDes;
          break;
        case r'categoryKeys':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.categoryKeys.replace(valueDes);
          break;
        case r'flavorProfileKeys':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.flavorProfileKeys.replace(valueDes);
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.tags.replace(valueDes);
          break;
        case r'ingredientLines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RecipeIngredientLine)]),
          ) as BuiltList<RecipeIngredientLine>;
          result.ingredientLines.replace(valueDes);
          break;
        case r'instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.instructions.replace(valueDes);
          break;
        case r'garnishes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.garnishes.replace(valueDes);
          break;
        case r'iceSpec':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.iceSpec = valueDes;
          break;
        case r'glassware':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EquipmentRef)]),
          ) as BuiltList<EquipmentRef>;
          result.glassware.replace(valueDes);
          break;
        case r'equipment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EquipmentRef)]),
          ) as BuiltList<EquipmentRef>;
          result.equipment.replace(valueDes);
          break;
        case r'creatorAttribution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.creatorAttribution = valueDes;
          break;
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.history = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'abvPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.abvPercent = valueDes;
          break;
        case r'standardDrinks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.standardDrinks = valueDes;
          break;
        case r'allergens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.allergens.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeDetailBuilder();
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

