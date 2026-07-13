// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EquipmentRef extends EquipmentRef {
  @override
  final String id;
  @override
  final String? name;

  factory _$EquipmentRef([void Function(EquipmentRefBuilder)? updates]) =>
      (EquipmentRefBuilder()..update(updates))._build();

  _$EquipmentRef._({required this.id, this.name}) : super._();
  @override
  EquipmentRef rebuild(void Function(EquipmentRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EquipmentRefBuilder toBuilder() => EquipmentRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EquipmentRef && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EquipmentRef')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class EquipmentRefBuilder
    implements Builder<EquipmentRef, EquipmentRefBuilder> {
  _$EquipmentRef? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  EquipmentRefBuilder() {
    EquipmentRef._defaults(this);
  }

  EquipmentRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EquipmentRef other) {
    _$v = other as _$EquipmentRef;
  }

  @override
  void update(void Function(EquipmentRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EquipmentRef build() => _build();

  _$EquipmentRef _build() {
    final _$result = _$v ??
        _$EquipmentRef._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'EquipmentRef', 'id'),
          name: name,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
