// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IngredientPage extends IngredientPage {
  @override
  final BuiltList<IngredientSummary> items;
  @override
  final String? nextCursor;

  factory _$IngredientPage([void Function(IngredientPageBuilder)? updates]) =>
      (IngredientPageBuilder()..update(updates))._build();

  _$IngredientPage._({required this.items, this.nextCursor}) : super._();
  @override
  IngredientPage rebuild(void Function(IngredientPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IngredientPageBuilder toBuilder() => IngredientPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IngredientPage &&
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
    return (newBuiltValueToStringHelper(r'IngredientPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class IngredientPageBuilder
    implements Builder<IngredientPage, IngredientPageBuilder> {
  _$IngredientPage? _$v;

  ListBuilder<IngredientSummary>? _items;
  ListBuilder<IngredientSummary> get items =>
      _$this._items ??= ListBuilder<IngredientSummary>();
  set items(ListBuilder<IngredientSummary>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  IngredientPageBuilder() {
    IngredientPage._defaults(this);
  }

  IngredientPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IngredientPage other) {
    _$v = other as _$IngredientPage;
  }

  @override
  void update(void Function(IngredientPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IngredientPage build() => _build();

  _$IngredientPage _build() {
    _$IngredientPage _$result;
    try {
      _$result = _$v ??
          _$IngredientPage._(
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
            r'IngredientPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
