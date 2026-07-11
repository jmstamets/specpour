// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EquipmentPage extends EquipmentPage {
  @override
  final BuiltList<EquipmentSummary> items;
  @override
  final String? nextCursor;

  factory _$EquipmentPage([void Function(EquipmentPageBuilder)? updates]) =>
      (EquipmentPageBuilder()..update(updates))._build();

  _$EquipmentPage._({required this.items, this.nextCursor}) : super._();
  @override
  EquipmentPage rebuild(void Function(EquipmentPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EquipmentPageBuilder toBuilder() => EquipmentPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EquipmentPage &&
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
    return (newBuiltValueToStringHelper(r'EquipmentPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class EquipmentPageBuilder
    implements Builder<EquipmentPage, EquipmentPageBuilder> {
  _$EquipmentPage? _$v;

  ListBuilder<EquipmentSummary>? _items;
  ListBuilder<EquipmentSummary> get items =>
      _$this._items ??= ListBuilder<EquipmentSummary>();
  set items(ListBuilder<EquipmentSummary>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  EquipmentPageBuilder() {
    EquipmentPage._defaults(this);
  }

  EquipmentPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EquipmentPage other) {
    _$v = other as _$EquipmentPage;
  }

  @override
  void update(void Function(EquipmentPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EquipmentPage build() => _build();

  _$EquipmentPage _build() {
    _$EquipmentPage _$result;
    try {
      _$result = _$v ??
          _$EquipmentPage._(
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
            r'EquipmentPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
