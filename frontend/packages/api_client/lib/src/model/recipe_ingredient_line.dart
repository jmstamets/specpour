//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_ingredient_line.g.dart';

/// RecipeIngredientLine
///
/// Properties:
/// * [position] 
/// * [ingredientId] 
/// * [ingredientName] - Resolved for display (FR-020); null only if the referenced ingredient can no longer be resolved.
/// * [quantity] 
/// * [unit] 
/// * [purpose] 
/// * [scalingRule] 
@BuiltValue()
abstract class RecipeIngredientLine implements Built<RecipeIngredientLine, RecipeIngredientLineBuilder> {
  @BuiltValueField(wireName: r'position')
  int get position;

  @BuiltValueField(wireName: r'ingredientId')
  String get ingredientId;

  /// Resolved for display (FR-020); null only if the referenced ingredient can no longer be resolved.
  @BuiltValueField(wireName: r'ingredientName')
  String? get ingredientName;

  @BuiltValueField(wireName: r'quantity')
  num get quantity;

  @BuiltValueField(wireName: r'unit')
  String get unit;

  @BuiltValueField(wireName: r'purpose')
  String? get purpose;

  @BuiltValueField(wireName: r'scalingRule')
  RecipeIngredientLineScalingRuleEnum get scalingRule;
  // enum scalingRuleEnum {  Linear,  Stepwise,  OmitInBatch,  AddFreshAtService,  };

  RecipeIngredientLine._();

  factory RecipeIngredientLine([void updates(RecipeIngredientLineBuilder b)]) = _$RecipeIngredientLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeIngredientLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeIngredientLine> get serializer => _$RecipeIngredientLineSerializer();
}

class _$RecipeIngredientLineSerializer implements PrimitiveSerializer<RecipeIngredientLine> {
  @override
  final Iterable<Type> types = const [RecipeIngredientLine, _$RecipeIngredientLine];

  @override
  final String wireName = r'RecipeIngredientLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeIngredientLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(int),
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
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(num),
    );
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(String),
    );
    if (object.purpose != null) {
      yield r'purpose';
      yield serializers.serialize(
        object.purpose,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'scalingRule';
    yield serializers.serialize(
      object.scalingRule,
      specifiedType: const FullType(RecipeIngredientLineScalingRuleEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeIngredientLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecipeIngredientLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.position = valueDes;
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
            specifiedType: const FullType(num),
          ) as num;
          result.quantity = valueDes;
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unit = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.purpose = valueDes;
          break;
        case r'scalingRule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RecipeIngredientLineScalingRuleEnum),
          ) as RecipeIngredientLineScalingRuleEnum;
          result.scalingRule = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeIngredientLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeIngredientLineBuilder();
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

class RecipeIngredientLineScalingRuleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Linear')
  static const RecipeIngredientLineScalingRuleEnum linear = _$recipeIngredientLineScalingRuleEnum_linear;
  @BuiltValueEnumConst(wireName: r'Stepwise')
  static const RecipeIngredientLineScalingRuleEnum stepwise = _$recipeIngredientLineScalingRuleEnum_stepwise;
  @BuiltValueEnumConst(wireName: r'OmitInBatch')
  static const RecipeIngredientLineScalingRuleEnum omitInBatch = _$recipeIngredientLineScalingRuleEnum_omitInBatch;
  @BuiltValueEnumConst(wireName: r'AddFreshAtService')
  static const RecipeIngredientLineScalingRuleEnum addFreshAtService = _$recipeIngredientLineScalingRuleEnum_addFreshAtService;

  static Serializer<RecipeIngredientLineScalingRuleEnum> get serializer => _$recipeIngredientLineScalingRuleEnumSerializer;

  const RecipeIngredientLineScalingRuleEnum._(String name): super(name);

  static BuiltSet<RecipeIngredientLineScalingRuleEnum> get values => _$recipeIngredientLineScalingRuleEnumValues;
  static RecipeIngredientLineScalingRuleEnum valueOf(String name) => _$recipeIngredientLineScalingRuleEnumValueOf(name);
}

