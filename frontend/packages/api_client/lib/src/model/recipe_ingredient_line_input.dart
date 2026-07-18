//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_ingredient_line_input.g.dart';

/// RecipeIngredientLineInput
///
/// Properties:
/// * [ingredientId] 
/// * [quantity] 
/// * [unit] 
/// * [purpose] 
/// * [scalingRule] 
@BuiltValue()
abstract class RecipeIngredientLineInput implements Built<RecipeIngredientLineInput, RecipeIngredientLineInputBuilder> {
  @BuiltValueField(wireName: r'ingredientId')
  String get ingredientId;

  @BuiltValueField(wireName: r'quantity')
  num get quantity;

  @BuiltValueField(wireName: r'unit')
  String get unit;

  @BuiltValueField(wireName: r'purpose')
  String? get purpose;

  @BuiltValueField(wireName: r'scalingRule')
  RecipeIngredientLineInputScalingRuleEnum get scalingRule;
  // enum scalingRuleEnum {  Linear,  Stepwise,  OmitInBatch,  AddFreshAtService,  };

  RecipeIngredientLineInput._();

  factory RecipeIngredientLineInput([void updates(RecipeIngredientLineInputBuilder b)]) = _$RecipeIngredientLineInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeIngredientLineInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeIngredientLineInput> get serializer => _$RecipeIngredientLineInputSerializer();
}

class _$RecipeIngredientLineInputSerializer implements PrimitiveSerializer<RecipeIngredientLineInput> {
  @override
  final Iterable<Type> types = const [RecipeIngredientLineInput, _$RecipeIngredientLineInput];

  @override
  final String wireName = r'RecipeIngredientLineInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeIngredientLineInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ingredientId';
    yield serializers.serialize(
      object.ingredientId,
      specifiedType: const FullType(String),
    );
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
      specifiedType: const FullType(RecipeIngredientLineInputScalingRuleEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeIngredientLineInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecipeIngredientLineInputBuilder result,
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
            specifiedType: const FullType(RecipeIngredientLineInputScalingRuleEnum),
          ) as RecipeIngredientLineInputScalingRuleEnum;
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
  RecipeIngredientLineInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeIngredientLineInputBuilder();
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

class RecipeIngredientLineInputScalingRuleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Linear')
  static const RecipeIngredientLineInputScalingRuleEnum linear = _$recipeIngredientLineInputScalingRuleEnum_linear;
  @BuiltValueEnumConst(wireName: r'Stepwise')
  static const RecipeIngredientLineInputScalingRuleEnum stepwise = _$recipeIngredientLineInputScalingRuleEnum_stepwise;
  @BuiltValueEnumConst(wireName: r'OmitInBatch')
  static const RecipeIngredientLineInputScalingRuleEnum omitInBatch = _$recipeIngredientLineInputScalingRuleEnum_omitInBatch;
  @BuiltValueEnumConst(wireName: r'AddFreshAtService')
  static const RecipeIngredientLineInputScalingRuleEnum addFreshAtService = _$recipeIngredientLineInputScalingRuleEnum_addFreshAtService;

  static Serializer<RecipeIngredientLineInputScalingRuleEnum> get serializer => _$recipeIngredientLineInputScalingRuleEnumSerializer;

  const RecipeIngredientLineInputScalingRuleEnum._(String name): super(name);

  static BuiltSet<RecipeIngredientLineInputScalingRuleEnum> get values => _$recipeIngredientLineInputScalingRuleEnumValues;
  static RecipeIngredientLineInputScalingRuleEnum valueOf(String name) => _$recipeIngredientLineInputScalingRuleEnumValueOf(name);
}

