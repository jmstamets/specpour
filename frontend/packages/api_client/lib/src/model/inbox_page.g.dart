// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InboxPage extends InboxPage {
  @override
  final BuiltList<InboxMessage> items;
  @override
  final String? nextCursor;

  factory _$InboxPage([void Function(InboxPageBuilder)? updates]) =>
      (InboxPageBuilder()..update(updates))._build();

  _$InboxPage._({required this.items, this.nextCursor}) : super._();
  @override
  InboxPage rebuild(void Function(InboxPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InboxPageBuilder toBuilder() => InboxPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InboxPage &&
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
    return (newBuiltValueToStringHelper(r'InboxPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class InboxPageBuilder implements Builder<InboxPage, InboxPageBuilder> {
  _$InboxPage? _$v;

  ListBuilder<InboxMessage>? _items;
  ListBuilder<InboxMessage> get items =>
      _$this._items ??= ListBuilder<InboxMessage>();
  set items(ListBuilder<InboxMessage>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  InboxPageBuilder() {
    InboxPage._defaults(this);
  }

  InboxPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InboxPage other) {
    _$v = other as _$InboxPage;
  }

  @override
  void update(void Function(InboxPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InboxPage build() => _build();

  _$InboxPage _build() {
    _$InboxPage _$result;
    try {
      _$result = _$v ??
          _$InboxPage._(
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
            r'InboxPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
