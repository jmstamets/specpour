// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requirement.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Requirement extends Requirement {
  @override
  final String ingredientId;
  @override
  final String? ingredientName;
  @override
  final num quantity;
  @override
  final String unit;

  factory _$Requirement([void Function(RequirementBuilder)? updates]) =>
      (RequirementBuilder()..update(updates))._build();

  _$Requirement._(
      {required this.ingredientId,
      this.ingredientName,
      required this.quantity,
      required this.unit})
      : super._();
  @override
  Requirement rebuild(void Function(RequirementBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RequirementBuilder toBuilder() => RequirementBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Requirement &&
        ingredientId == other.ingredientId &&
        ingredientName == other.ingredientName &&
        quantity == other.quantity &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ingredientId.hashCode);
    _$hash = $jc(_$hash, ingredientName.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Requirement')
          ..add('ingredientId', ingredientId)
          ..add('ingredientName', ingredientName)
          ..add('quantity', quantity)
          ..add('unit', unit))
        .toString();
  }
}

class RequirementBuilder implements Builder<Requirement, RequirementBuilder> {
  _$Requirement? _$v;

  String? _ingredientId;
  String? get ingredientId => _$this._ingredientId;
  set ingredientId(String? ingredientId) => _$this._ingredientId = ingredientId;

  String? _ingredientName;
  String? get ingredientName => _$this._ingredientName;
  set ingredientName(String? ingredientName) =>
      _$this._ingredientName = ingredientName;

  num? _quantity;
  num? get quantity => _$this._quantity;
  set quantity(num? quantity) => _$this._quantity = quantity;

  String? _unit;
  String? get unit => _$this._unit;
  set unit(String? unit) => _$this._unit = unit;

  RequirementBuilder() {
    Requirement._defaults(this);
  }

  RequirementBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ingredientId = $v.ingredientId;
      _ingredientName = $v.ingredientName;
      _quantity = $v.quantity;
      _unit = $v.unit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Requirement other) {
    _$v = other as _$Requirement;
  }

  @override
  void update(void Function(RequirementBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Requirement build() => _build();

  _$Requirement _build() {
    final _$result = _$v ??
        _$Requirement._(
          ingredientId: BuiltValueNullFieldError.checkNotNull(
              ingredientId, r'Requirement', 'ingredientId'),
          ingredientName: ingredientName,
          quantity: BuiltValueNullFieldError.checkNotNull(
              quantity, r'Requirement', 'quantity'),
          unit: BuiltValueNullFieldError.checkNotNull(
              unit, r'Requirement', 'unit'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
