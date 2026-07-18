// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_equipment_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateEquipmentRequest extends UpdateEquipmentRequest {
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
  final BuiltList<String>? typicalApplications;

  factory _$UpdateEquipmentRequest(
          [void Function(UpdateEquipmentRequestBuilder)? updates]) =>
      (UpdateEquipmentRequestBuilder()..update(updates))._build();

  _$UpdateEquipmentRequest._(
      {required this.name,
      required this.category,
      this.cost,
      this.description,
      this.usageGuidance,
      this.typicalApplications})
      : super._();
  @override
  UpdateEquipmentRequest rebuild(
          void Function(UpdateEquipmentRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateEquipmentRequestBuilder toBuilder() =>
      UpdateEquipmentRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateEquipmentRequest &&
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
    return (newBuiltValueToStringHelper(r'UpdateEquipmentRequest')
          ..add('name', name)
          ..add('category', category)
          ..add('cost', cost)
          ..add('description', description)
          ..add('usageGuidance', usageGuidance)
          ..add('typicalApplications', typicalApplications))
        .toString();
  }
}

class UpdateEquipmentRequestBuilder
    implements Builder<UpdateEquipmentRequest, UpdateEquipmentRequestBuilder> {
  _$UpdateEquipmentRequest? _$v;

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

  UpdateEquipmentRequestBuilder() {
    UpdateEquipmentRequest._defaults(this);
  }

  UpdateEquipmentRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _category = $v.category;
      _cost = $v.cost;
      _description = $v.description;
      _usageGuidance = $v.usageGuidance;
      _typicalApplications = $v.typicalApplications?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateEquipmentRequest other) {
    _$v = other as _$UpdateEquipmentRequest;
  }

  @override
  void update(void Function(UpdateEquipmentRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateEquipmentRequest build() => _build();

  _$UpdateEquipmentRequest _build() {
    _$UpdateEquipmentRequest _$result;
    try {
      _$result = _$v ??
          _$UpdateEquipmentRequest._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'UpdateEquipmentRequest', 'name'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'UpdateEquipmentRequest', 'category'),
            cost: cost,
            description: description,
            usageGuidance: usageGuidance,
            typicalApplications: _typicalApplications?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'typicalApplications';
        _typicalApplications?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdateEquipmentRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
