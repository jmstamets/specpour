// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchResultPage extends SearchResultPage {
  @override
  final BuiltList<SearchResult> items;
  @override
  final String? nextCursor;

  factory _$SearchResultPage(
          [void Function(SearchResultPageBuilder)? updates]) =>
      (SearchResultPageBuilder()..update(updates))._build();

  _$SearchResultPage._({required this.items, this.nextCursor}) : super._();
  @override
  SearchResultPage rebuild(void Function(SearchResultPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchResultPageBuilder toBuilder() =>
      SearchResultPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchResultPage &&
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
    return (newBuiltValueToStringHelper(r'SearchResultPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class SearchResultPageBuilder
    implements Builder<SearchResultPage, SearchResultPageBuilder> {
  _$SearchResultPage? _$v;

  ListBuilder<SearchResult>? _items;
  ListBuilder<SearchResult> get items =>
      _$this._items ??= ListBuilder<SearchResult>();
  set items(ListBuilder<SearchResult>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  SearchResultPageBuilder() {
    SearchResultPage._defaults(this);
  }

  SearchResultPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchResultPage other) {
    _$v = other as _$SearchResultPage;
  }

  @override
  void update(void Function(SearchResultPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchResultPage build() => _build();

  _$SearchResultPage _build() {
    _$SearchResultPage _$result;
    try {
      _$result = _$v ??
          _$SearchResultPage._(
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
            r'SearchResultPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
