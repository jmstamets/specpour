// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EquipmentSummary extends EquipmentSummary {
  @override
  final String id;
  @override
  final String name;
  @override
  final String category;

  factory _$EquipmentSummary(
          [void Function(EquipmentSummaryBuilder)? updates]) =>
      (EquipmentSummaryBuilder()..update(updates))._build();

  _$EquipmentSummary._(
      {required this.id, required this.name, required this.category})
      : super._();
  @override
  EquipmentSummary rebuild(void Function(EquipmentSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EquipmentSummaryBuilder toBuilder() =>
      EquipmentSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EquipmentSummary &&
        id == other.id &&
        name == other.name &&
        category == other.category;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EquipmentSummary')
          ..add('id', id)
          ..add('name', name)
          ..add('category', category))
        .toString();
  }
}

class EquipmentSummaryBuilder
    implements Builder<EquipmentSummary, EquipmentSummaryBuilder> {
  _$EquipmentSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  EquipmentSummaryBuilder() {
    EquipmentSummary._defaults(this);
  }

  EquipmentSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _category = $v.category;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EquipmentSummary other) {
    _$v = other as _$EquipmentSummary;
  }

  @override
  void update(void Function(EquipmentSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EquipmentSummary build() => _build();

  _$EquipmentSummary _build() {
    final _$result = _$v ??
        _$EquipmentSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'EquipmentSummary', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'EquipmentSummary', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'EquipmentSummary', 'category'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
