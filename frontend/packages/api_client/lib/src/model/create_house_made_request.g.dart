// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_house_made_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateHouseMadeRequest extends CreateHouseMadeRequest {
  @override
  final String definingRecipeId;
  @override
  final num yieldQuantity;
  @override
  final String yieldUnit;
  @override
  final int shelfLifeDays;
  @override
  final String storageInstructions;

  factory _$CreateHouseMadeRequest(
          [void Function(CreateHouseMadeRequestBuilder)? updates]) =>
      (CreateHouseMadeRequestBuilder()..update(updates))._build();

  _$CreateHouseMadeRequest._(
      {required this.definingRecipeId,
      required this.yieldQuantity,
      required this.yieldUnit,
      required this.shelfLifeDays,
      required this.storageInstructions})
      : super._();
  @override
  CreateHouseMadeRequest rebuild(
          void Function(CreateHouseMadeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateHouseMadeRequestBuilder toBuilder() =>
      CreateHouseMadeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateHouseMadeRequest &&
        definingRecipeId == other.definingRecipeId &&
        yieldQuantity == other.yieldQuantity &&
        yieldUnit == other.yieldUnit &&
        shelfLifeDays == other.shelfLifeDays &&
        storageInstructions == other.storageInstructions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, definingRecipeId.hashCode);
    _$hash = $jc(_$hash, yieldQuantity.hashCode);
    _$hash = $jc(_$hash, yieldUnit.hashCode);
    _$hash = $jc(_$hash, shelfLifeDays.hashCode);
    _$hash = $jc(_$hash, storageInstructions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateHouseMadeRequest')
          ..add('definingRecipeId', definingRecipeId)
          ..add('yieldQuantity', yieldQuantity)
          ..add('yieldUnit', yieldUnit)
          ..add('shelfLifeDays', shelfLifeDays)
          ..add('storageInstructions', storageInstructions))
        .toString();
  }
}

class CreateHouseMadeRequestBuilder
    implements Builder<CreateHouseMadeRequest, CreateHouseMadeRequestBuilder> {
  _$CreateHouseMadeRequest? _$v;

  String? _definingRecipeId;
  String? get definingRecipeId => _$this._definingRecipeId;
  set definingRecipeId(String? definingRecipeId) =>
      _$this._definingRecipeId = definingRecipeId;

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

  CreateHouseMadeRequestBuilder() {
    CreateHouseMadeRequest._defaults(this);
  }

  CreateHouseMadeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _definingRecipeId = $v.definingRecipeId;
      _yieldQuantity = $v.yieldQuantity;
      _yieldUnit = $v.yieldUnit;
      _shelfLifeDays = $v.shelfLifeDays;
      _storageInstructions = $v.storageInstructions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateHouseMadeRequest other) {
    _$v = other as _$CreateHouseMadeRequest;
  }

  @override
  void update(void Function(CreateHouseMadeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateHouseMadeRequest build() => _build();

  _$CreateHouseMadeRequest _build() {
    final _$result = _$v ??
        _$CreateHouseMadeRequest._(
          definingRecipeId: BuiltValueNullFieldError.checkNotNull(
              definingRecipeId, r'CreateHouseMadeRequest', 'definingRecipeId'),
          yieldQuantity: BuiltValueNullFieldError.checkNotNull(
              yieldQuantity, r'CreateHouseMadeRequest', 'yieldQuantity'),
          yieldUnit: BuiltValueNullFieldError.checkNotNull(
              yieldUnit, r'CreateHouseMadeRequest', 'yieldUnit'),
          shelfLifeDays: BuiltValueNullFieldError.checkNotNull(
              shelfLifeDays, r'CreateHouseMadeRequest', 'shelfLifeDays'),
          storageInstructions: BuiltValueNullFieldError.checkNotNull(
              storageInstructions,
              r'CreateHouseMadeRequest',
              'storageInstructions'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
