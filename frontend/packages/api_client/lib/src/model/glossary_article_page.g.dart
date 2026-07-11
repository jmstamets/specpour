// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_article_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GlossaryArticlePage extends GlossaryArticlePage {
  @override
  final BuiltList<GlossaryArticleSummary> items;
  @override
  final String? nextCursor;

  factory _$GlossaryArticlePage(
          [void Function(GlossaryArticlePageBuilder)? updates]) =>
      (GlossaryArticlePageBuilder()..update(updates))._build();

  _$GlossaryArticlePage._({required this.items, this.nextCursor}) : super._();
  @override
  GlossaryArticlePage rebuild(
          void Function(GlossaryArticlePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GlossaryArticlePageBuilder toBuilder() =>
      GlossaryArticlePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GlossaryArticlePage &&
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
    return (newBuiltValueToStringHelper(r'GlossaryArticlePage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class GlossaryArticlePageBuilder
    implements Builder<GlossaryArticlePage, GlossaryArticlePageBuilder> {
  _$GlossaryArticlePage? _$v;

  ListBuilder<GlossaryArticleSummary>? _items;
  ListBuilder<GlossaryArticleSummary> get items =>
      _$this._items ??= ListBuilder<GlossaryArticleSummary>();
  set items(ListBuilder<GlossaryArticleSummary>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  GlossaryArticlePageBuilder() {
    GlossaryArticlePage._defaults(this);
  }

  GlossaryArticlePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GlossaryArticlePage other) {
    _$v = other as _$GlossaryArticlePage;
  }

  @override
  void update(void Function(GlossaryArticlePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GlossaryArticlePage build() => _build();

  _$GlossaryArticlePage _build() {
    _$GlossaryArticlePage _$result;
    try {
      _$result = _$v ??
          _$GlossaryArticlePage._(
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
            r'GlossaryArticlePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
