// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'near_miss_recipe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NearMissRecipe extends NearMissRecipe {
  @override
  final String recipeId;
  @override
  final String recipeName;
  @override
  final BuiltList<MakeabilityLine> lines;

  factory _$NearMissRecipe([void Function(NearMissRecipeBuilder)? updates]) =>
      (NearMissRecipeBuilder()..update(updates))._build();

  _$NearMissRecipe._(
      {required this.recipeId, required this.recipeName, required this.lines})
      : super._();
  @override
  NearMissRecipe rebuild(void Function(NearMissRecipeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NearMissRecipeBuilder toBuilder() => NearMissRecipeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NearMissRecipe &&
        recipeId == other.recipeId &&
        recipeName == other.recipeName &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recipeId.hashCode);
    _$hash = $jc(_$hash, recipeName.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NearMissRecipe')
          ..add('recipeId', recipeId)
          ..add('recipeName', recipeName)
          ..add('lines', lines))
        .toString();
  }
}

class NearMissRecipeBuilder
    implements Builder<NearMissRecipe, NearMissRecipeBuilder> {
  _$NearMissRecipe? _$v;

  String? _recipeId;
  String? get recipeId => _$this._recipeId;
  set recipeId(String? recipeId) => _$this._recipeId = recipeId;

  String? _recipeName;
  String? get recipeName => _$this._recipeName;
  set recipeName(String? recipeName) => _$this._recipeName = recipeName;

  ListBuilder<MakeabilityLine>? _lines;
  ListBuilder<MakeabilityLine> get lines =>
      _$this._lines ??= ListBuilder<MakeabilityLine>();
  set lines(ListBuilder<MakeabilityLine>? lines) => _$this._lines = lines;

  NearMissRecipeBuilder() {
    NearMissRecipe._defaults(this);
  }

  NearMissRecipeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recipeId = $v.recipeId;
      _recipeName = $v.recipeName;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NearMissRecipe other) {
    _$v = other as _$NearMissRecipe;
  }

  @override
  void update(void Function(NearMissRecipeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NearMissRecipe build() => _build();

  _$NearMissRecipe _build() {
    _$NearMissRecipe _$result;
    try {
      _$result = _$v ??
          _$NearMissRecipe._(
            recipeId: BuiltValueNullFieldError.checkNotNull(
                recipeId, r'NearMissRecipe', 'recipeId'),
            recipeName: BuiltValueNullFieldError.checkNotNull(
                recipeName, r'NearMissRecipe', 'recipeName'),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'NearMissRecipe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
