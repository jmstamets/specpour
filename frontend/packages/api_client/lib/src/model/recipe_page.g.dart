// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipePage extends RecipePage {
  @override
  final BuiltList<RecipeSummary> items;
  @override
  final String? nextCursor;

  factory _$RecipePage([void Function(RecipePageBuilder)? updates]) =>
      (RecipePageBuilder()..update(updates))._build();

  _$RecipePage._({required this.items, this.nextCursor}) : super._();
  @override
  RecipePage rebuild(void Function(RecipePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipePageBuilder toBuilder() => RecipePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipePage &&
        items == other.items &&
        nextCursor == other.nextCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipePage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class RecipePageBuilder implements Builder<RecipePage, RecipePageBuilder> {
  _$RecipePage? _$v;

  ListBuilder<RecipeSummary>? _items;
  ListBuilder<RecipeSummary> get items =>
      _$this._items ??= ListBuilder<RecipeSummary>();
  set items(ListBuilder<RecipeSummary>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  RecipePageBuilder() {
    RecipePage._defaults(this);
  }

  RecipePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipePage other) {
    _$v = other as _$RecipePage;
  }

  @override
  void update(void Function(RecipePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipePage build() => _build();

  _$RecipePage _build() {
    _$RecipePage _$result;
    try {
      _$result = _$v ??
          _$RecipePage._(
            items: items.build(),
            nextCursor: nextCursor,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RecipePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
