// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'makeable_recipe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MakeableRecipe extends MakeableRecipe {
  @override
  final String recipeId;
  @override
  final String recipeName;
  @override
  final MatchQuality matchQuality;
  @override
  final BuiltList<MakeabilityLine> lines;

  factory _$MakeableRecipe([void Function(MakeableRecipeBuilder)? updates]) =>
      (MakeableRecipeBuilder()..update(updates))._build();

  _$MakeableRecipe._(
      {required this.recipeId,
      required this.recipeName,
      required this.matchQuality,
      required this.lines})
      : super._();
  @override
  MakeableRecipe rebuild(void Function(MakeableRecipeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MakeableRecipeBuilder toBuilder() => MakeableRecipeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MakeableRecipe &&
        recipeId == other.recipeId &&
        recipeName == other.recipeName &&
        matchQuality == other.matchQuality &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recipeId.hashCode);
    _$hash = $jc(_$hash, recipeName.hashCode);
    _$hash = $jc(_$hash, matchQuality.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MakeableRecipe')
          ..add('recipeId', recipeId)
          ..add('recipeName', recipeName)
          ..add('matchQuality', matchQuality)
          ..add('lines', lines))
        .toString();
  }
}

class MakeableRecipeBuilder
    implements Builder<MakeableRecipe, MakeableRecipeBuilder> {
  _$MakeableRecipe? _$v;

  String? _recipeId;
  String? get recipeId => _$this._recipeId;
  set recipeId(String? recipeId) => _$this._recipeId = recipeId;

  String? _recipeName;
  String? get recipeName => _$this._recipeName;
  set recipeName(String? recipeName) => _$this._recipeName = recipeName;

  MatchQuality? _matchQuality;
  MatchQuality? get matchQuality => _$this._matchQuality;
  set matchQuality(MatchQuality? matchQuality) =>
      _$this._matchQuality = matchQuality;

  ListBuilder<MakeabilityLine>? _lines;
  ListBuilder<MakeabilityLine> get lines =>
      _$this._lines ??= ListBuilder<MakeabilityLine>();
  set lines(ListBuilder<MakeabilityLine>? lines) => _$this._lines = lines;

  MakeableRecipeBuilder() {
    MakeableRecipe._defaults(this);
  }

  MakeableRecipeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recipeId = $v.recipeId;
      _recipeName = $v.recipeName;
      _matchQuality = $v.matchQuality;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MakeableRecipe other) {
    _$v = other as _$MakeableRecipe;
  }

  @override
  void update(void Function(MakeableRecipeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MakeableRecipe build() => _build();

  _$MakeableRecipe _build() {
    _$MakeableRecipe _$result;
    try {
      _$result = _$v ??
          _$MakeableRecipe._(
            recipeId: BuiltValueNullFieldError.checkNotNull(
                recipeId, r'MakeableRecipe', 'recipeId'),
            recipeName: BuiltValueNullFieldError.checkNotNull(
                recipeName, r'MakeableRecipe', 'recipeName'),
            matchQuality: BuiltValueNullFieldError.checkNotNull(
                matchQuality, r'MakeableRecipe', 'matchQuality'),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MakeableRecipe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
