// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VenuePage extends VenuePage {
  @override
  final BuiltList<Venue> items;
  @override
  final String? nextCursor;

  factory _$VenuePage([void Function(VenuePageBuilder)? updates]) =>
      (VenuePageBuilder()..update(updates))._build();

  _$VenuePage._({required this.items, this.nextCursor}) : super._();
  @override
  VenuePage rebuild(void Function(VenuePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VenuePageBuilder toBuilder() => VenuePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VenuePage &&
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
    return (newBuiltValueToStringHelper(r'VenuePage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class VenuePageBuilder implements Builder<VenuePage, VenuePageBuilder> {
  _$VenuePage? _$v;

  ListBuilder<Venue>? _items;
  ListBuilder<Venue> get items => _$this._items ??= ListBuilder<Venue>();
  set items(ListBuilder<Venue>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  VenuePageBuilder() {
    VenuePage._defaults(this);
  }

  VenuePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VenuePage other) {
    _$v = other as _$VenuePage;
  }

  @override
  void update(void Function(VenuePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VenuePage build() => _build();

  _$VenuePage _build() {
    _$VenuePage _$result;
    try {
      _$result = _$v ??
          _$VenuePage._(
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
            r'VenuePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
