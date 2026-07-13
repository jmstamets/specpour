// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeDetail extends RecipeDetail {
  @override
  final String id;
  @override
  final String primaryName;
  @override
  final BuiltList<String> alternateNames;
  @override
  final String? familyKey;
  @override
  final BuiltList<String>? categoryKeys;
  @override
  final BuiltList<String>? flavorProfileKeys;
  @override
  final BuiltList<String>? tags;
  @override
  final BuiltList<RecipeIngredientLine> ingredientLines;
  @override
  final BuiltList<String> instructions;
  @override
  final BuiltList<String>? garnishes;
  @override
  final String iceSpec;
  @override
  final BuiltList<EquipmentRef> glassware;
  @override
  final BuiltList<EquipmentRef> equipment;
  @override
  final String? creatorAttribution;
  @override
  final String? history;
  @override
  final String? notes;
  @override
  final num abvPercent;
  @override
  final num standardDrinks;
  @override
  final BuiltList<String> allergens;

  factory _$RecipeDetail([void Function(RecipeDetailBuilder)? updates]) =>
      (RecipeDetailBuilder()..update(updates))._build();

  _$RecipeDetail._(
      {required this.id,
      required this.primaryName,
      required this.alternateNames,
      this.familyKey,
      this.categoryKeys,
      this.flavorProfileKeys,
      this.tags,
      required this.ingredientLines,
      required this.instructions,
      this.garnishes,
      required this.iceSpec,
      required this.glassware,
      required this.equipment,
      this.creatorAttribution,
      this.history,
      this.notes,
      required this.abvPercent,
      required this.standardDrinks,
      required this.allergens})
      : super._();
  @override
  RecipeDetail rebuild(void Function(RecipeDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeDetailBuilder toBuilder() => RecipeDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeDetail &&
        id == other.id &&
        primaryName == other.primaryName &&
        alternateNames == other.alternateNames &&
        familyKey == other.familyKey &&
        categoryKeys == other.categoryKeys &&
        flavorProfileKeys == other.flavorProfileKeys &&
        tags == other.tags &&
        ingredientLines == other.ingredientLines &&
        instructions == other.instructions &&
        garnishes == other.garnishes &&
        iceSpec == other.iceSpec &&
        glassware == other.glassware &&
        equipment == other.equipment &&
        creatorAttribution == other.creatorAttribution &&
        history == other.history &&
        notes == other.notes &&
        abvPercent == other.abvPercent &&
        standardDrinks == other.standardDrinks &&
        allergens == other.allergens;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, primaryName.hashCode);
    _$hash = $jc(_$hash, alternateNames.hashCode);
    _$hash = $jc(_$hash, familyKey.hashCode);
    _$hash = $jc(_$hash, categoryKeys.hashCode);
    _$hash = $jc(_$hash, flavorProfileKeys.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, ingredientLines.hashCode);
    _$hash = $jc(_$hash, instructions.hashCode);
    _$hash = $jc(_$hash, garnishes.hashCode);
    _$hash = $jc(_$hash, iceSpec.hashCode);
    _$hash = $jc(_$hash, glassware.hashCode);
    _$hash = $jc(_$hash, equipment.hashCode);
    _$hash = $jc(_$hash, creatorAttribution.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, abvPercent.hashCode);
    _$hash = $jc(_$hash, standardDrinks.hashCode);
    _$hash = $jc(_$hash, allergens.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeDetail')
          ..add('id', id)
          ..add('primaryName', primaryName)
          ..add('alternateNames', alternateNames)
          ..add('familyKey', familyKey)
          ..add('categoryKeys', categoryKeys)
          ..add('flavorProfileKeys', flavorProfileKeys)
          ..add('tags', tags)
          ..add('ingredientLines', ingredientLines)
          ..add('instructions', instructions)
          ..add('garnishes', garnishes)
          ..add('iceSpec', iceSpec)
          ..add('glassware', glassware)
          ..add('equipment', equipment)
          ..add('creatorAttribution', creatorAttribution)
          ..add('history', history)
          ..add('notes', notes)
          ..add('abvPercent', abvPercent)
          ..add('standardDrinks', standardDrinks)
          ..add('allergens', allergens))
        .toString();
  }
}

class RecipeDetailBuilder
    implements Builder<RecipeDetail, RecipeDetailBuilder> {
  _$RecipeDetail? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _primaryName;
  String? get primaryName => _$this._primaryName;
  set primaryName(String? primaryName) => _$this._primaryName = primaryName;

  ListBuilder<String>? _alternateNames;
  ListBuilder<String> get alternateNames =>
      _$this._alternateNames ??= ListBuilder<String>();
  set alternateNames(ListBuilder<String>? alternateNames) =>
      _$this._alternateNames = alternateNames;

  String? _familyKey;
  String? get familyKey => _$this._familyKey;
  set familyKey(String? familyKey) => _$this._familyKey = familyKey;

  ListBuilder<String>? _categoryKeys;
  ListBuilder<String> get categoryKeys =>
      _$this._categoryKeys ??= ListBuilder<String>();
  set categoryKeys(ListBuilder<String>? categoryKeys) =>
      _$this._categoryKeys = categoryKeys;

  ListBuilder<String>? _flavorProfileKeys;
  ListBuilder<String> get flavorProfileKeys =>
      _$this._flavorProfileKeys ??= ListBuilder<String>();
  set flavorProfileKeys(ListBuilder<String>? flavorProfileKeys) =>
      _$this._flavorProfileKeys = flavorProfileKeys;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  ListBuilder<RecipeIngredientLine>? _ingredientLines;
  ListBuilder<RecipeIngredientLine> get ingredientLines =>
      _$this._ingredientLines ??= ListBuilder<RecipeIngredientLine>();
  set ingredientLines(ListBuilder<RecipeIngredientLine>? ingredientLines) =>
      _$this._ingredientLines = ingredientLines;

  ListBuilder<String>? _instructions;
  ListBuilder<String> get instructions =>
      _$this._instructions ??= ListBuilder<String>();
  set instructions(ListBuilder<String>? instructions) =>
      _$this._instructions = instructions;

  ListBuilder<String>? _garnishes;
  ListBuilder<String> get garnishes =>
      _$this._garnishes ??= ListBuilder<String>();
  set garnishes(ListBuilder<String>? garnishes) =>
      _$this._garnishes = garnishes;

  String? _iceSpec;
  String? get iceSpec => _$this._iceSpec;
  set iceSpec(String? iceSpec) => _$this._iceSpec = iceSpec;

  ListBuilder<EquipmentRef>? _glassware;
  ListBuilder<EquipmentRef> get glassware =>
      _$this._glassware ??= ListBuilder<EquipmentRef>();
  set glassware(ListBuilder<EquipmentRef>? glassware) =>
      _$this._glassware = glassware;

  ListBuilder<EquipmentRef>? _equipment;
  ListBuilder<EquipmentRef> get equipment =>
      _$this._equipment ??= ListBuilder<EquipmentRef>();
  set equipment(ListBuilder<EquipmentRef>? equipment) =>
      _$this._equipment = equipment;

  String? _creatorAttribution;
  String? get creatorAttribution => _$this._creatorAttribution;
  set creatorAttribution(String? creatorAttribution) =>
      _$this._creatorAttribution = creatorAttribution;

  String? _history;
  String? get history => _$this._history;
  set history(String? history) => _$this._history = history;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  num? _abvPercent;
  num? get abvPercent => _$this._abvPercent;
  set abvPercent(num? abvPercent) => _$this._abvPercent = abvPercent;

  num? _standardDrinks;
  num? get standardDrinks => _$this._standardDrinks;
  set standardDrinks(num? standardDrinks) =>
      _$this._standardDrinks = standardDrinks;

  ListBuilder<String>? _allergens;
  ListBuilder<String> get allergens =>
      _$this._allergens ??= ListBuilder<String>();
  set allergens(ListBuilder<String>? allergens) =>
      _$this._allergens = allergens;

  RecipeDetailBuilder() {
    RecipeDetail._defaults(this);
  }

  RecipeDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _primaryName = $v.primaryName;
      _alternateNames = $v.alternateNames.toBuilder();
      _familyKey = $v.familyKey;
      _categoryKeys = $v.categoryKeys?.toBuilder();
      _flavorProfileKeys = $v.flavorProfileKeys?.toBuilder();
      _tags = $v.tags?.toBuilder();
      _ingredientLines = $v.ingredientLines.toBuilder();
      _instructions = $v.instructions.toBuilder();
      _garnishes = $v.garnishes?.toBuilder();
      _iceSpec = $v.iceSpec;
      _glassware = $v.glassware.toBuilder();
      _equipment = $v.equipment.toBuilder();
      _creatorAttribution = $v.creatorAttribution;
      _history = $v.history;
      _notes = $v.notes;
      _abvPercent = $v.abvPercent;
      _standardDrinks = $v.standardDrinks;
      _allergens = $v.allergens.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeDetail other) {
    _$v = other as _$RecipeDetail;
  }

  @override
  void update(void Function(RecipeDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeDetail build() => _build();

  _$RecipeDetail _build() {
    _$RecipeDetail _$result;
    try {
      _$result = _$v ??
          _$RecipeDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'RecipeDetail', 'id'),
            primaryName: BuiltValueNullFieldError.checkNotNull(
                primaryName, r'RecipeDetail', 'primaryName'),
            alternateNames: alternateNames.build(),
            familyKey: familyKey,
            categoryKeys: _categoryKeys?.build(),
            flavorProfileKeys: _flavorProfileKeys?.build(),
            tags: _tags?.build(),
            ingredientLines: ingredientLines.build(),
            instructions: instructions.build(),
            garnishes: _garnishes?.build(),
            iceSpec: BuiltValueNullFieldError.checkNotNull(
                iceSpec, r'RecipeDetail', 'iceSpec'),
            glassware: glassware.build(),
            equipment: equipment.build(),
            creatorAttribution: creatorAttribution,
            history: history,
            notes: notes,
            abvPercent: BuiltValueNullFieldError.checkNotNull(
                abvPercent, r'RecipeDetail', 'abvPercent'),
            standardDrinks: BuiltValueNullFieldError.checkNotNull(
                standardDrinks, r'RecipeDetail', 'standardDrinks'),
            allergens: allergens.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'alternateNames';
        alternateNames.build();

        _$failedField = 'categoryKeys';
        _categoryKeys?.build();
        _$failedField = 'flavorProfileKeys';
        _flavorProfileKeys?.build();
        _$failedField = 'tags';
        _tags?.build();
        _$failedField = 'ingredientLines';
        ingredientLines.build();
        _$failedField = 'instructions';
        instructions.build();
        _$failedField = 'garnishes';
        _garnishes?.build();

        _$failedField = 'glassware';
        glassware.build();
        _$failedField = 'equipment';
        equipment.build();

        _$failedField = 'allergens';
        allergens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RecipeDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
