// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_recipes.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IngredientRecipes extends IngredientRecipes {
  @override
  final BuiltList<IngredientRecipeRef> items;

  factory _$IngredientRecipes(
          [void Function(IngredientRecipesBuilder)? updates]) =>
      (IngredientRecipesBuilder()..update(updates))._build();

  _$IngredientRecipes._({required this.items}) : super._();
  @override
  IngredientRecipes rebuild(void Function(IngredientRecipesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IngredientRecipesBuilder toBuilder() =>
      IngredientRecipesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IngredientRecipes && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IngredientRecipes')
          ..add('items', items))
        .toString();
  }
}

class IngredientRecipesBuilder
    implements Builder<IngredientRecipes, IngredientRecipesBuilder> {
  _$IngredientRecipes? _$v;

  ListBuilder<IngredientRecipeRef>? _items;
  ListBuilder<IngredientRecipeRef> get items =>
      _$this._items ??= ListBuilder<IngredientRecipeRef>();
  set items(ListBuilder<IngredientRecipeRef>? items) => _$this._items = items;

  IngredientRecipesBuilder() {
    IngredientRecipes._defaults(this);
  }

  IngredientRecipesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IngredientRecipes other) {
    _$v = other as _$IngredientRecipes;
  }

  @override
  void update(void Function(IngredientRecipesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IngredientRecipes build() => _build();

  _$IngredientRecipes _build() {
    _$IngredientRecipes _$result;
    try {
      _$result = _$v ??
          _$IngredientRecipes._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'IngredientRecipes', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
