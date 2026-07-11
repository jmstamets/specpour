// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EquipmentDetail extends EquipmentDetail {
  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final num? cost;
  @override
  final String? description;
  @override
  final String? usageGuidance;
  @override
  final BuiltList<String> typicalApplications;

  factory _$EquipmentDetail([void Function(EquipmentDetailBuilder)? updates]) =>
      (EquipmentDetailBuilder()..update(updates))._build();

  _$EquipmentDetail._(
      {required this.id,
      required this.name,
      required this.category,
      this.cost,
      this.description,
      this.usageGuidance,
      required this.typicalApplications})
      : super._();
  @override
  EquipmentDetail rebuild(void Function(EquipmentDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EquipmentDetailBuilder toBuilder() => EquipmentDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EquipmentDetail &&
        id == other.id &&
        name == other.name &&
        category == other.category &&
        cost == other.cost &&
        description == other.description &&
        usageGuidance == other.usageGuidance &&
        typicalApplications == other.typicalApplications;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, cost.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, usageGuidance.hashCode);
    _$hash = $jc(_$hash, typicalApplications.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EquipmentDetail')
          ..add('id', id)
          ..add('name', name)
          ..add('category', category)
          ..add('cost', cost)
          ..add('description', description)
          ..add('usageGuidance', usageGuidance)
          ..add('typicalApplications', typicalApplications))
        .toString();
  }
}

class EquipmentDetailBuilder
    implements Builder<EquipmentDetail, EquipmentDetailBuilder> {
  _$EquipmentDetail? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  num? _cost;
  num? get cost => _$this._cost;
  set cost(num? cost) => _$this._cost = cost;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _usageGuidance;
  String? get usageGuidance => _$this._usageGuidance;
  set usageGuidance(String? usageGuidance) =>
      _$this._usageGuidance = usageGuidance;

  ListBuilder<String>? _typicalApplications;
  ListBuilder<String> get typicalApplications =>
      _$this._typicalApplications ??= ListBuilder<String>();
  set typicalApplications(ListBuilder<String>? typicalApplications) =>
      _$this._typicalApplications = typicalApplications;

  EquipmentDetailBuilder() {
    EquipmentDetail._defaults(this);
  }

  EquipmentDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _category = $v.category;
      _cost = $v.cost;
      _description = $v.description;
      _usageGuidance = $v.usageGuidance;
      _typicalApplications = $v.typicalApplications.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EquipmentDetail other) {
    _$v = other as _$EquipmentDetail;
  }

  @override
  void update(void Function(EquipmentDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EquipmentDetail build() => _build();

  _$EquipmentDetail _build() {
    _$EquipmentDetail _$result;
    try {
      _$result = _$v ??
          _$EquipmentDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'EquipmentDetail', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'EquipmentDetail', 'name'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'EquipmentDetail', 'category'),
            cost: cost,
            description: description,
            usageGuidance: usageGuidance,
            typicalApplications: typicalApplications.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'typicalApplications';
        typicalApplications.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'EquipmentDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
