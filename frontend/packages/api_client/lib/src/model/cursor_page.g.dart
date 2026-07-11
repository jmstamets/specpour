// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CursorPage extends CursorPage {
  @override
  final BuiltList<JsonObject?> items;
  @override
  final String? nextCursor;

  factory _$CursorPage([void Function(CursorPageBuilder)? updates]) =>
      (CursorPageBuilder()..update(updates))._build();

  _$CursorPage._({required this.items, this.nextCursor}) : super._();
  @override
  CursorPage rebuild(void Function(CursorPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CursorPageBuilder toBuilder() => CursorPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CursorPage &&
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
    return (newBuiltValueToStringHelper(r'CursorPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class CursorPageBuilder implements Builder<CursorPage, CursorPageBuilder> {
  _$CursorPage? _$v;

  ListBuilder<JsonObject?>? _items;
  ListBuilder<JsonObject?> get items =>
      _$this._items ??= ListBuilder<JsonObject?>();
  set items(ListBuilder<JsonObject?>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  CursorPageBuilder() {
    CursorPage._defaults(this);
  }

  CursorPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CursorPage other) {
    _$v = other as _$CursorPage;
  }

  @override
  void update(void Function(CursorPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CursorPage build() => _build();

  _$CursorPage _build() {
    _$CursorPage _$result;
    try {
      _$result = _$v ??
          _$CursorPage._(
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
            r'CursorPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
