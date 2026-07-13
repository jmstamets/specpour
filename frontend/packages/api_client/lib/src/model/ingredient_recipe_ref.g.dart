// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_recipe_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IngredientRecipeRef extends IngredientRecipeRef {
  @override
  final String id;
  @override
  final String name;

  factory _$IngredientRecipeRef(
          [void Function(IngredientRecipeRefBuilder)? updates]) =>
      (IngredientRecipeRefBuilder()..update(updates))._build();

  _$IngredientRecipeRef._({required this.id, required this.name}) : super._();
  @override
  IngredientRecipeRef rebuild(
          void Function(IngredientRecipeRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IngredientRecipeRefBuilder toBuilder() =>
      IngredientRecipeRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IngredientRecipeRef && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IngredientRecipeRef')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class IngredientRecipeRefBuilder
    implements Builder<IngredientRecipeRef, IngredientRecipeRefBuilder> {
  _$IngredientRecipeRef? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  IngredientRecipeRefBuilder() {
    IngredientRecipeRef._defaults(this);
  }

  IngredientRecipeRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IngredientRecipeRef other) {
    _$v = other as _$IngredientRecipeRef;
  }

  @override
  void update(void Function(IngredientRecipeRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IngredientRecipeRef build() => _build();

  _$IngredientRecipeRef _build() {
    final _$result = _$v ??
        _$IngredientRecipeRef._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'IngredientRecipeRef', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'IngredientRecipeRef', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
