// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_ingredient_line_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RecipeIngredientLineInputScalingRuleEnum
    _$recipeIngredientLineInputScalingRuleEnum_linear =
    const RecipeIngredientLineInputScalingRuleEnum._('linear');
const RecipeIngredientLineInputScalingRuleEnum
    _$recipeIngredientLineInputScalingRuleEnum_stepwise =
    const RecipeIngredientLineInputScalingRuleEnum._('stepwise');
const RecipeIngredientLineInputScalingRuleEnum
    _$recipeIngredientLineInputScalingRuleEnum_omitInBatch =
    const RecipeIngredientLineInputScalingRuleEnum._('omitInBatch');
const RecipeIngredientLineInputScalingRuleEnum
    _$recipeIngredientLineInputScalingRuleEnum_addFreshAtService =
    const RecipeIngredientLineInputScalingRuleEnum._('addFreshAtService');

RecipeIngredientLineInputScalingRuleEnum
    _$recipeIngredientLineInputScalingRuleEnumValueOf(String name) {
  switch (name) {
    case 'linear':
      return _$recipeIngredientLineInputScalingRuleEnum_linear;
    case 'stepwise':
      return _$recipeIngredientLineInputScalingRuleEnum_stepwise;
    case 'omitInBatch':
      return _$recipeIngredientLineInputScalingRuleEnum_omitInBatch;
    case 'addFreshAtService':
      return _$recipeIngredientLineInputScalingRuleEnum_addFreshAtService;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RecipeIngredientLineInputScalingRuleEnum>
    _$recipeIngredientLineInputScalingRuleEnumValues = BuiltSet<
        RecipeIngredientLineInputScalingRuleEnum>(const <RecipeIngredientLineInputScalingRuleEnum>[
  _$recipeIngredientLineInputScalingRuleEnum_linear,
  _$recipeIngredientLineInputScalingRuleEnum_stepwise,
  _$recipeIngredientLineInputScalingRuleEnum_omitInBatch,
  _$recipeIngredientLineInputScalingRuleEnum_addFreshAtService,
]);

Serializer<RecipeIngredientLineInputScalingRuleEnum>
    _$recipeIngredientLineInputScalingRuleEnumSerializer =
    _$RecipeIngredientLineInputScalingRuleEnumSerializer();

class _$RecipeIngredientLineInputScalingRuleEnumSerializer
    implements PrimitiveSerializer<RecipeIngredientLineInputScalingRuleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'linear': 'Linear',
    'stepwise': 'Stepwise',
    'omitInBatch': 'OmitInBatch',
    'addFreshAtService': 'AddFreshAtService',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Linear': 'linear',
    'Stepwise': 'stepwise',
    'OmitInBatch': 'omitInBatch',
    'AddFreshAtService': 'addFreshAtService',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RecipeIngredientLineInputScalingRuleEnum
  ];
  @override
  final String wireName = 'RecipeIngredientLineInputScalingRuleEnum';

  @override
  Object serialize(Serializers serializers,
          RecipeIngredientLineInputScalingRuleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RecipeIngredientLineInputScalingRuleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RecipeIngredientLineInputScalingRuleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RecipeIngredientLineInput extends RecipeIngredientLineInput {
  @override
  final String ingredientId;
  @override
  final num quantity;
  @override
  final String unit;
  @override
  final String? purpose;
  @override
  final RecipeIngredientLineInputScalingRuleEnum scalingRule;

  factory _$RecipeIngredientLineInput(
          [void Function(RecipeIngredientLineInputBuilder)? updates]) =>
      (RecipeIngredientLineInputBuilder()..update(updates))._build();

  _$RecipeIngredientLineInput._(
      {required this.ingredientId,
      required this.quantity,
      required this.unit,
      this.purpose,
      required this.scalingRule})
      : super._();
  @override
  RecipeIngredientLineInput rebuild(
          void Function(RecipeIngredientLineInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeIngredientLineInputBuilder toBuilder() =>
      RecipeIngredientLineInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeIngredientLineInput &&
        ingredientId == other.ingredientId &&
        quantity == other.quantity &&
        unit == other.unit &&
        purpose == other.purpose &&
        scalingRule == other.scalingRule;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ingredientId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, scalingRule.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeIngredientLineInput')
          ..add('ingredientId', ingredientId)
          ..add('quantity', quantity)
          ..add('unit', unit)
          ..add('purpose', purpose)
          ..add('scalingRule', scalingRule))
        .toString();
  }
}

class RecipeIngredientLineInputBuilder
    implements
        Builder<RecipeIngredientLineInput, RecipeIngredientLineInputBuilder> {
  _$RecipeIngredientLineInput? _$v;

  String? _ingredientId;
  String? get ingredientId => _$this._ingredientId;
  set ingredientId(String? ingredientId) => _$this._ingredientId = ingredientId;

  num? _quantity;
  num? get quantity => _$this._quantity;
  set quantity(num? quantity) => _$this._quantity = quantity;

  String? _unit;
  String? get unit => _$this._unit;
  set unit(String? unit) => _$this._unit = unit;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  RecipeIngredientLineInputScalingRuleEnum? _scalingRule;
  RecipeIngredientLineInputScalingRuleEnum? get scalingRule =>
      _$this._scalingRule;
  set scalingRule(RecipeIngredientLineInputScalingRuleEnum? scalingRule) =>
      _$this._scalingRule = scalingRule;

  RecipeIngredientLineInputBuilder() {
    RecipeIngredientLineInput._defaults(this);
  }

  RecipeIngredientLineInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ingredientId = $v.ingredientId;
      _quantity = $v.quantity;
      _unit = $v.unit;
      _purpose = $v.purpose;
      _scalingRule = $v.scalingRule;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeIngredientLineInput other) {
    _$v = other as _$RecipeIngredientLineInput;
  }

  @override
  void update(void Function(RecipeIngredientLineInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeIngredientLineInput build() => _build();

  _$RecipeIngredientLineInput _build() {
    final _$result = _$v ??
        _$RecipeIngredientLineInput._(
          ingredientId: BuiltValueNullFieldError.checkNotNull(
              ingredientId, r'RecipeIngredientLineInput', 'ingredientId'),
          quantity: BuiltValueNullFieldError.checkNotNull(
              quantity, r'RecipeIngredientLineInput', 'quantity'),
          unit: BuiltValueNullFieldError.checkNotNull(
              unit, r'RecipeIngredientLineInput', 'unit'),
          purpose: purpose,
          scalingRule: BuiltValueNullFieldError.checkNotNull(
              scalingRule, r'RecipeIngredientLineInput', 'scalingRule'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
