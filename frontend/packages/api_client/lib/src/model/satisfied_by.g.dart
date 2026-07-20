// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'satisfied_by.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SatisfiedBy extends SatisfiedBy {
  @override
  final String inventoryItemId;
  @override
  final String ingredientId;
  @override
  final String? ingredientName;

  factory _$SatisfiedBy([void Function(SatisfiedByBuilder)? updates]) =>
      (SatisfiedByBuilder()..update(updates))._build();

  _$SatisfiedBy._(
      {required this.inventoryItemId,
      required this.ingredientId,
      this.ingredientName})
      : super._();
  @override
  SatisfiedBy rebuild(void Function(SatisfiedByBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SatisfiedByBuilder toBuilder() => SatisfiedByBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SatisfiedBy &&
        inventoryItemId == other.inventoryItemId &&
        ingredientId == other.ingredientId &&
        ingredientName == other.ingredientName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, inventoryItemId.hashCode);
    _$hash = $jc(_$hash, ingredientId.hashCode);
    _$hash = $jc(_$hash, ingredientName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SatisfiedBy')
          ..add('inventoryItemId', inventoryItemId)
          ..add('ingredientId', ingredientId)
          ..add('ingredientName', ingredientName))
        .toString();
  }
}

class SatisfiedByBuilder implements Builder<SatisfiedBy, SatisfiedByBuilder> {
  _$SatisfiedBy? _$v;

  String? _inventoryItemId;
  String? get inventoryItemId => _$this._inventoryItemId;
  set inventoryItemId(String? inventoryItemId) =>
      _$this._inventoryItemId = inventoryItemId;

  String? _ingredientId;
  String? get ingredientId => _$this._ingredientId;
  set ingredientId(String? ingredientId) => _$this._ingredientId = ingredientId;

  String? _ingredientName;
  String? get ingredientName => _$this._ingredientName;
  set ingredientName(String? ingredientName) =>
      _$this._ingredientName = ingredientName;

  SatisfiedByBuilder() {
    SatisfiedBy._defaults(this);
  }

  SatisfiedByBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _inventoryItemId = $v.inventoryItemId;
      _ingredientId = $v.ingredientId;
      _ingredientName = $v.ingredientName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SatisfiedBy other) {
    _$v = other as _$SatisfiedBy;
  }

  @override
  void update(void Function(SatisfiedByBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SatisfiedBy build() => _build();

  _$SatisfiedBy _build() {
    final _$result = _$v ??
        _$SatisfiedBy._(
          inventoryItemId: BuiltValueNullFieldError.checkNotNull(
              inventoryItemId, r'SatisfiedBy', 'inventoryItemId'),
          ingredientId: BuiltValueNullFieldError.checkNotNull(
              ingredientId, r'SatisfiedBy', 'ingredientId'),
          ingredientName: ingredientName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
