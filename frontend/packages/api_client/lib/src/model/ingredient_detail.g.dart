// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IngredientDetail extends IngredientDetail {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? parentId;
  @override
  final String? parentName;
  @override
  final BuiltList<String> sources;
  @override
  final String? description;
  @override
  final num? abvPercent;
  @override
  final BuiltList<String> allergens;
  @override
  final String? definingRecipeId;
  @override
  final String? definingRecipeName;
  @override
  final num? yieldQuantity;
  @override
  final String? yieldUnit;
  @override
  final String? shelfLife;
  @override
  final String? storageInstructions;

  factory _$IngredientDetail(
          [void Function(IngredientDetailBuilder)? updates]) =>
      (IngredientDetailBuilder()..update(updates))._build();

  _$IngredientDetail._(
      {required this.id,
      required this.name,
      this.parentId,
      this.parentName,
      required this.sources,
      this.description,
      this.abvPercent,
      required this.allergens,
      this.definingRecipeId,
      this.definingRecipeName,
      this.yieldQuantity,
      this.yieldUnit,
      this.shelfLife,
      this.storageInstructions})
      : super._();
  @override
  IngredientDetail rebuild(void Function(IngredientDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IngredientDetailBuilder toBuilder() =>
      IngredientDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IngredientDetail &&
        id == other.id &&
        name == other.name &&
        parentId == other.parentId &&
        parentName == other.parentName &&
        sources == other.sources &&
        description == other.description &&
        abvPercent == other.abvPercent &&
        allergens == other.allergens &&
        definingRecipeId == other.definingRecipeId &&
        definingRecipeName == other.definingRecipeName &&
        yieldQuantity == other.yieldQuantity &&
        yieldUnit == other.yieldUnit &&
        shelfLife == other.shelfLife &&
        storageInstructions == other.storageInstructions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, parentName.hashCode);
    _$hash = $jc(_$hash, sources.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, abvPercent.hashCode);
    _$hash = $jc(_$hash, allergens.hashCode);
    _$hash = $jc(_$hash, definingRecipeId.hashCode);
    _$hash = $jc(_$hash, definingRecipeName.hashCode);
    _$hash = $jc(_$hash, yieldQuantity.hashCode);
    _$hash = $jc(_$hash, yieldUnit.hashCode);
    _$hash = $jc(_$hash, shelfLife.hashCode);
    _$hash = $jc(_$hash, storageInstructions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IngredientDetail')
          ..add('id', id)
          ..add('name', name)
          ..add('parentId', parentId)
          ..add('parentName', parentName)
          ..add('sources', sources)
          ..add('description', description)
          ..add('abvPercent', abvPercent)
          ..add('allergens', allergens)
          ..add('definingRecipeId', definingRecipeId)
          ..add('definingRecipeName', definingRecipeName)
          ..add('yieldQuantity', yieldQuantity)
          ..add('yieldUnit', yieldUnit)
          ..add('shelfLife', shelfLife)
          ..add('storageInstructions', storageInstructions))
        .toString();
  }
}

class IngredientDetailBuilder
    implements Builder<IngredientDetail, IngredientDetailBuilder> {
  _$IngredientDetail? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _parentId;
  String? get parentId => _$this._parentId;
  set parentId(String? parentId) => _$this._parentId = parentId;

  String? _parentName;
  String? get parentName => _$this._parentName;
  set parentName(String? parentName) => _$this._parentName = parentName;

  ListBuilder<String>? _sources;
  ListBuilder<String> get sources => _$this._sources ??= ListBuilder<String>();
  set sources(ListBuilder<String>? sources) => _$this._sources = sources;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  num? _abvPercent;
  num? get abvPercent => _$this._abvPercent;
  set abvPercent(num? abvPercent) => _$this._abvPercent = abvPercent;

  ListBuilder<String>? _allergens;
  ListBuilder<String> get allergens =>
      _$this._allergens ??= ListBuilder<String>();
  set allergens(ListBuilder<String>? allergens) =>
      _$this._allergens = allergens;

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

  String? _shelfLife;
  String? get shelfLife => _$this._shelfLife;
  set shelfLife(String? shelfLife) => _$this._shelfLife = shelfLife;

  String? _storageInstructions;
  String? get storageInstructions => _$this._storageInstructions;
  set storageInstructions(String? storageInstructions) =>
      _$this._storageInstructions = storageInstructions;

  IngredientDetailBuilder() {
    IngredientDetail._defaults(this);
  }

  IngredientDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _parentId = $v.parentId;
      _parentName = $v.parentName;
      _sources = $v.sources.toBuilder();
      _description = $v.description;
      _abvPercent = $v.abvPercent;
      _allergens = $v.allergens.toBuilder();
      _definingRecipeId = $v.definingRecipeId;
      _definingRecipeName = $v.definingRecipeName;
      _yieldQuantity = $v.yieldQuantity;
      _yieldUnit = $v.yieldUnit;
      _shelfLife = $v.shelfLife;
      _storageInstructions = $v.storageInstructions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IngredientDetail other) {
    _$v = other as _$IngredientDetail;
  }

  @override
  void update(void Function(IngredientDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IngredientDetail build() => _build();

  _$IngredientDetail _build() {
    _$IngredientDetail _$result;
    try {
      _$result = _$v ??
          _$IngredientDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'IngredientDetail', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'IngredientDetail', 'name'),
            parentId: parentId,
            parentName: parentName,
            sources: sources.build(),
            description: description,
            abvPercent: abvPercent,
            allergens: allergens.build(),
            definingRecipeId: definingRecipeId,
            definingRecipeName: definingRecipeName,
            yieldQuantity: yieldQuantity,
            yieldUnit: yieldUnit,
            shelfLife: shelfLife,
            storageInstructions: storageInstructions,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sources';
        sources.build();

        _$failedField = 'allergens';
        allergens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'IngredientDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
