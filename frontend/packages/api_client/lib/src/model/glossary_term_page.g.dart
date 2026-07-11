// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_term_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GlossaryTermPage extends GlossaryTermPage {
  @override
  final BuiltList<GlossaryTermSummary> items;
  @override
  final String? nextCursor;

  factory _$GlossaryTermPage(
          [void Function(GlossaryTermPageBuilder)? updates]) =>
      (GlossaryTermPageBuilder()..update(updates))._build();

  _$GlossaryTermPage._({required this.items, this.nextCursor}) : super._();
  @override
  GlossaryTermPage rebuild(void Function(GlossaryTermPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GlossaryTermPageBuilder toBuilder() =>
      GlossaryTermPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GlossaryTermPage &&
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
    return (newBuiltValueToStringHelper(r'GlossaryTermPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class GlossaryTermPageBuilder
    implements Builder<GlossaryTermPage, GlossaryTermPageBuilder> {
  _$GlossaryTermPage? _$v;

  ListBuilder<GlossaryTermSummary>? _items;
  ListBuilder<GlossaryTermSummary> get items =>
      _$this._items ??= ListBuilder<GlossaryTermSummary>();
  set items(ListBuilder<GlossaryTermSummary>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  GlossaryTermPageBuilder() {
    GlossaryTermPage._defaults(this);
  }

  GlossaryTermPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GlossaryTermPage other) {
    _$v = other as _$GlossaryTermPage;
  }

  @override
  void update(void Function(GlossaryTermPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GlossaryTermPage build() => _build();

  _$GlossaryTermPage _build() {
    _$GlossaryTermPage _$result;
    try {
      _$result = _$v ??
          _$GlossaryTermPage._(
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
            r'GlossaryTermPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
