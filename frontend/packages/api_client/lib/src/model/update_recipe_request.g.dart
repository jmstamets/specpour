// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_recipe_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateRecipeRequest extends UpdateRecipeRequest {
  @override
  final String primaryName;
  @override
  final BuiltList<String>? alternateNames;
  @override
  final BuiltList<String>? instructions;
  @override
  final BuiltList<RecipeIngredientLineInput>? ingredientLines;
  @override
  final BuiltList<String>? categoryIds;
  @override
  final BuiltList<String>? tags;

  factory _$UpdateRecipeRequest(
          [void Function(UpdateRecipeRequestBuilder)? updates]) =>
      (UpdateRecipeRequestBuilder()..update(updates))._build();

  _$UpdateRecipeRequest._(
      {required this.primaryName,
      this.alternateNames,
      this.instructions,
      this.ingredientLines,
      this.categoryIds,
      this.tags})
      : super._();
  @override
  UpdateRecipeRequest rebuild(
          void Function(UpdateRecipeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateRecipeRequestBuilder toBuilder() =>
      UpdateRecipeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateRecipeRequest &&
        primaryName == other.primaryName &&
        alternateNames == other.alternateNames &&
        instructions == other.instructions &&
        ingredientLines == other.ingredientLines &&
        categoryIds == other.categoryIds &&
        tags == other.tags;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, primaryName.hashCode);
    _$hash = $jc(_$hash, alternateNames.hashCode);
    _$hash = $jc(_$hash, instructions.hashCode);
    _$hash = $jc(_$hash, ingredientLines.hashCode);
    _$hash = $jc(_$hash, categoryIds.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateRecipeRequest')
          ..add('primaryName', primaryName)
          ..add('alternateNames', alternateNames)
          ..add('instructions', instructions)
          ..add('ingredientLines', ingredientLines)
          ..add('categoryIds', categoryIds)
          ..add('tags', tags))
        .toString();
  }
}

class UpdateRecipeRequestBuilder
    implements Builder<UpdateRecipeRequest, UpdateRecipeRequestBuilder> {
  _$UpdateRecipeRequest? _$v;

  String? _primaryName;
  String? get primaryName => _$this._primaryName;
  set primaryName(String? primaryName) => _$this._primaryName = primaryName;

  ListBuilder<String>? _alternateNames;
  ListBuilder<String> get alternateNames =>
      _$this._alternateNames ??= ListBuilder<String>();
  set alternateNames(ListBuilder<String>? alternateNames) =>
      _$this._alternateNames = alternateNames;

  ListBuilder<String>? _instructions;
  ListBuilder<String> get instructions =>
      _$this._instructions ??= ListBuilder<String>();
  set instructions(ListBuilder<String>? instructions) =>
      _$this._instructions = instructions;

  ListBuilder<RecipeIngredientLineInput>? _ingredientLines;
  ListBuilder<RecipeIngredientLineInput> get ingredientLines =>
      _$this._ingredientLines ??= ListBuilder<RecipeIngredientLineInput>();
  set ingredientLines(
          ListBuilder<RecipeIngredientLineInput>? ingredientLines) =>
      _$this._ingredientLines = ingredientLines;

  ListBuilder<String>? _categoryIds;
  ListBuilder<String> get categoryIds =>
      _$this._categoryIds ??= ListBuilder<String>();
  set categoryIds(ListBuilder<String>? categoryIds) =>
      _$this._categoryIds = categoryIds;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  UpdateRecipeRequestBuilder() {
    UpdateRecipeRequest._defaults(this);
  }

  UpdateRecipeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _primaryName = $v.primaryName;
      _alternateNames = $v.alternateNames?.toBuilder();
      _instructions = $v.instructions?.toBuilder();
      _ingredientLines = $v.ingredientLines?.toBuilder();
      _categoryIds = $v.categoryIds?.toBuilder();
      _tags = $v.tags?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateRecipeRequest other) {
    _$v = other as _$UpdateRecipeRequest;
  }

  @override
  void update(void Function(UpdateRecipeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateRecipeRequest build() => _build();

  _$UpdateRecipeRequest _build() {
    _$UpdateRecipeRequest _$result;
    try {
      _$result = _$v ??
          _$UpdateRecipeRequest._(
            primaryName: BuiltValueNullFieldError.checkNotNull(
                primaryName, r'UpdateRecipeRequest', 'primaryName'),
            alternateNames: _alternateNames?.build(),
            instructions: _instructions?.build(),
            ingredientLines: _ingredientLines?.build(),
            categoryIds: _categoryIds?.build(),
            tags: _tags?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'alternateNames';
        _alternateNames?.build();
        _$failedField = 'instructions';
        _instructions?.build();
        _$failedField = 'ingredientLines';
        _ingredientLines?.build();
        _$failedField = 'categoryIds';
        _categoryIds?.build();
        _$failedField = 'tags';
        _tags?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdateRecipeRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
