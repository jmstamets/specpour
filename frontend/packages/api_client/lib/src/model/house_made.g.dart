// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house_made.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HouseMade extends HouseMade {
  @override
  final String definingRecipeId;
  @override
  final String? definingRecipeName;
  @override
  final num yieldQuantity;
  @override
  final String yieldUnit;
  @override
  final int shelfLifeDays;
  @override
  final String storageInstructions;

  factory _$HouseMade([void Function(HouseMadeBuilder)? updates]) =>
      (HouseMadeBuilder()..update(updates))._build();

  _$HouseMade._(
      {required this.definingRecipeId,
      this.definingRecipeName,
      required this.yieldQuantity,
      required this.yieldUnit,
      required this.shelfLifeDays,
      required this.storageInstructions})
      : super._();
  @override
  HouseMade rebuild(void Function(HouseMadeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HouseMadeBuilder toBuilder() => HouseMadeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HouseMade &&
        definingRecipeId == other.definingRecipeId &&
        definingRecipeName == other.definingRecipeName &&
        yieldQuantity == other.yieldQuantity &&
        yieldUnit == other.yieldUnit &&
        shelfLifeDays == other.shelfLifeDays &&
        storageInstructions == other.storageInstructions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, definingRecipeId.hashCode);
    _$hash = $jc(_$hash, definingRecipeName.hashCode);
    _$hash = $jc(_$hash, yieldQuantity.hashCode);
    _$hash = $jc(_$hash, yieldUnit.hashCode);
    _$hash = $jc(_$hash, shelfLifeDays.hashCode);
    _$hash = $jc(_$hash, storageInstructions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HouseMade')
          ..add('definingRecipeId', definingRecipeId)
          ..add('definingRecipeName', definingRecipeName)
          ..add('yieldQuantity', yieldQuantity)
          ..add('yieldUnit', yieldUnit)
          ..add('shelfLifeDays', shelfLifeDays)
          ..add('storageInstructions', storageInstructions))
        .toString();
  }
}

class HouseMadeBuilder implements Builder<HouseMade, HouseMadeBuilder> {
  _$HouseMade? _$v;

  String? _definingRecipeId;
  String? get definingRecipeId => _$this._definingRecipeId;
  set definingRecipeId(String? definingRecipeId) =>
      _$this._definingRecipeId = definingRecipeId;

  String? _definingRecipeName;
  String? get definingRecipeName => _$this._definingRecipeName;
  set definingRecipeName(String? definingRecipeName) =>
      _$this._definingRecipeName = definingRecipeName;

  num? _yieldQuantity;
  num? get yieldQuantity => _$this._yieldQuantity;
  set yieldQuantity(num? yieldQuantity) =>
      _$this._yieldQuantity = yieldQuantity;

  String? _yieldUnit;
  String? get yieldUnit => _$this._yieldUnit;
  set yieldUnit(String? yieldUnit) => _$this._yieldUnit = yieldUnit;

  int? _shelfLifeDays;
  int? get shelfLifeDays => _$this._shelfLifeDays;
  set shelfLifeDays(int? shelfLifeDays) =>
      _$this._shelfLifeDays = shelfLifeDays;

  String? _storageInstructions;
  String? get storageInstructions => _$this._storageInstructions;
  set storageInstructions(String? storageInstructions) =>
      _$this._storageInstructions = storageInstructions;

  HouseMadeBuilder() {
    HouseMade._defaults(this);
  }

  HouseMadeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _definingRecipeId = $v.definingRecipeId;
      _definingRecipeName = $v.definingRecipeName;
      _yieldQuantity = $v.yieldQuantity;
      _yieldUnit = $v.yieldUnit;
      _shelfLifeDays = $v.shelfLifeDays;
      _storageInstructions = $v.storageInstructions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HouseMade other) {
    _$v = other as _$HouseMade;
  }

  @override
  void update(void Function(HouseMadeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HouseMade build() => _build();

  _$HouseMade _build() {
    final _$result = _$v ??
        _$HouseMade._(
          definingRecipeId: BuiltValueNullFieldError.checkNotNull(
              definingRecipeId, r'HouseMade', 'definingRecipeId'),
          definingRecipeName: definingRecipeName,
          yieldQuantity: BuiltValueNullFieldError.checkNotNull(
              yieldQuantity, r'HouseMade', 'yieldQuantity'),
          yieldUnit: BuiltValueNullFieldError.checkNotNull(
              yieldUnit, r'HouseMade', 'yieldUnit'),
          shelfLifeDays: BuiltValueNullFieldError.checkNotNull(
              shelfLifeDays, r'HouseMade', 'shelfLifeDays'),
          storageInstructions: BuiltValueNullFieldError.checkNotNull(
              storageInstructions, r'HouseMade', 'storageInstructions'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
