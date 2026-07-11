// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_ingredient_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RecipeIngredientLineScalingRuleEnum
    _$recipeIngredientLineScalingRuleEnum_linear =
    const RecipeIngredientLineScalingRuleEnum._('linear');
const RecipeIngredientLineScalingRuleEnum
    _$recipeIngredientLineScalingRuleEnum_stepwise =
    const RecipeIngredientLineScalingRuleEnum._('stepwise');
const RecipeIngredientLineScalingRuleEnum
    _$recipeIngredientLineScalingRuleEnum_omitInBatch =
    const RecipeIngredientLineScalingRuleEnum._('omitInBatch');
const RecipeIngredientLineScalingRuleEnum
    _$recipeIngredientLineScalingRuleEnum_addFreshAtService =
    const RecipeIngredientLineScalingRuleEnum._('addFreshAtService');

RecipeIngredientLineScalingRuleEnum
    _$recipeIngredientLineScalingRuleEnumValueOf(String name) {
  switch (name) {
    case 'linear':
      return _$recipeIngredientLineScalingRuleEnum_linear;
    case 'stepwise':
      return _$recipeIngredientLineScalingRuleEnum_stepwise;
    case 'omitInBatch':
      return _$recipeIngredientLineScalingRuleEnum_omitInBatch;
    case 'addFreshAtService':
      return _$recipeIngredientLineScalingRuleEnum_addFreshAtService;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RecipeIngredientLineScalingRuleEnum>
    _$recipeIngredientLineScalingRuleEnumValues = BuiltSet<
        RecipeIngredientLineScalingRuleEnum>(const <RecipeIngredientLineScalingRuleEnum>[
  _$recipeIngredientLineScalingRuleEnum_linear,
  _$recipeIngredientLineScalingRuleEnum_stepwise,
  _$recipeIngredientLineScalingRuleEnum_omitInBatch,
  _$recipeIngredientLineScalingRuleEnum_addFreshAtService,
]);

Serializer<RecipeIngredientLineScalingRuleEnum>
    _$recipeIngredientLineScalingRuleEnumSerializer =
    _$RecipeIngredientLineScalingRuleEnumSerializer();

class _$RecipeIngredientLineScalingRuleEnumSerializer
    implements PrimitiveSerializer<RecipeIngredientLineScalingRuleEnum> {
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
    RecipeIngredientLineScalingRuleEnum
  ];
  @override
  final String wireName = 'RecipeIngredientLineScalingRuleEnum';

  @override
  Object serialize(
          Serializers serializers, RecipeIngredientLineScalingRuleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RecipeIngredientLineScalingRuleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RecipeIngredientLineScalingRuleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RecipeIngredientLine extends RecipeIngredientLine {
  @override
  final int position;
  @override
  final String ingredientId;
  @override
  final num quantity;
  @override
  final String unit;
  @override
  final String? purpose;
  @override
  final RecipeIngredientLineScalingRuleEnum scalingRule;

  factory _$RecipeIngredientLine(
          [void Function(RecipeIngredientLineBuilder)? updates]) =>
      (RecipeIngredientLineBuilder()..update(updates))._build();

  _$RecipeIngredientLine._(
      {required this.position,
      required this.ingredientId,
      required this.quantity,
      required this.unit,
      this.purpose,
      required this.scalingRule})
      : super._();
  @override
  RecipeIngredientLine rebuild(
          void Function(RecipeIngredientLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeIngredientLineBuilder toBuilder() =>
      RecipeIngredientLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeIngredientLine &&
        position == other.position &&
        ingredientId == other.ingredientId &&
        quantity == other.quantity &&
        unit == other.unit &&
        purpose == other.purpose &&
        scalingRule == other.scalingRule;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, position.hashCode);
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
    return (newBuiltValueToStringHelper(r'RecipeIngredientLine')
          ..add('position', position)
          ..add('ingredientId', ingredientId)
          ..add('quantity', quantity)
          ..add('unit', unit)
          ..add('purpose', purpose)
          ..add('scalingRule', scalingRule))
        .toString();
  }
}

class RecipeIngredientLineBuilder
    implements Builder<RecipeIngredientLine, RecipeIngredientLineBuilder> {
  _$RecipeIngredientLine? _$v;

  int? _position;
  int? get position => _$this._position;
  set position(int? position) => _$this._position = position;

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

  RecipeIngredientLineScalingRuleEnum? _scalingRule;
  RecipeIngredientLineScalingRuleEnum? get scalingRule => _$this._scalingRule;
  set scalingRule(RecipeIngredientLineScalingRuleEnum? scalingRule) =>
      _$this._scalingRule = scalingRule;

  RecipeIngredientLineBuilder() {
    RecipeIngredientLine._defaults(this);
  }

  RecipeIngredientLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _position = $v.position;
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
  void replace(RecipeIngredientLine other) {
    _$v = other as _$RecipeIngredientLine;
  }

  @override
  void update(void Function(RecipeIngredientLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeIngredientLine build() => _build();

  _$RecipeIngredientLine _build() {
    final _$result = _$v ??
        _$RecipeIngredientLine._(
          position: BuiltValueNullFieldError.checkNotNull(
              position, r'RecipeIngredientLine', 'position'),
          ingredientId: BuiltValueNullFieldError.checkNotNull(
              ingredientId, r'RecipeIngredientLine', 'ingredientId'),
          quantity: BuiltValueNullFieldError.checkNotNull(
              quantity, r'RecipeIngredientLine', 'quantity'),
          unit: BuiltValueNullFieldError.checkNotNull(
              unit, r'RecipeIngredientLine', 'unit'),
          purpose: purpose,
          scalingRule: BuiltValueNullFieldError.checkNotNull(
              scalingRule, r'RecipeIngredientLine', 'scalingRule'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
