// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concept_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConceptPage extends ConceptPage {
  @override
  final BuiltList<ConceptSummary> items;
  @override
  final String? nextCursor;

  factory _$ConceptPage([void Function(ConceptPageBuilder)? updates]) =>
      (ConceptPageBuilder()..update(updates))._build();

  _$ConceptPage._({required this.items, this.nextCursor}) : super._();
  @override
  ConceptPage rebuild(void Function(ConceptPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConceptPageBuilder toBuilder() => ConceptPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConceptPage &&
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
    return (newBuiltValueToStringHelper(r'ConceptPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class ConceptPageBuilder implements Builder<ConceptPage, ConceptPageBuilder> {
  _$ConceptPage? _$v;

  ListBuilder<ConceptSummary>? _items;
  ListBuilder<ConceptSummary> get items =>
      _$this._items ??= ListBuilder<ConceptSummary>();
  set items(ListBuilder<ConceptSummary>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  ConceptPageBuilder() {
    ConceptPage._defaults(this);
  }

  ConceptPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConceptPage other) {
    _$v = other as _$ConceptPage;
  }

  @override
  void update(void Function(ConceptPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConceptPage build() => _build();

  _$ConceptPage _build() {
    _$ConceptPage _$result;
    try {
      _$result = _$v ??
          _$ConceptPage._(
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
            r'ConceptPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
