// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryItemPage extends InventoryItemPage {
  @override
  final BuiltList<InventoryItem> items;
  @override
  final String? nextCursor;

  factory _$InventoryItemPage(
          [void Function(InventoryItemPageBuilder)? updates]) =>
      (InventoryItemPageBuilder()..update(updates))._build();

  _$InventoryItemPage._({required this.items, this.nextCursor}) : super._();
  @override
  InventoryItemPage rebuild(void Function(InventoryItemPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryItemPageBuilder toBuilder() =>
      InventoryItemPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryItemPage &&
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
    return (newBuiltValueToStringHelper(r'InventoryItemPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class InventoryItemPageBuilder
    implements Builder<InventoryItemPage, InventoryItemPageBuilder> {
  _$InventoryItemPage? _$v;

  ListBuilder<InventoryItem>? _items;
  ListBuilder<InventoryItem> get items =>
      _$this._items ??= ListBuilder<InventoryItem>();
  set items(ListBuilder<InventoryItem>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  InventoryItemPageBuilder() {
    InventoryItemPage._defaults(this);
  }

  InventoryItemPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryItemPage other) {
    _$v = other as _$InventoryItemPage;
  }

  @override
  void update(void Function(InventoryItemPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryItemPage build() => _build();

  _$InventoryItemPage _build() {
    _$InventoryItemPage _$result;
    try {
      _$result = _$v ??
          _$InventoryItemPage._(
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
            r'InventoryItemPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
