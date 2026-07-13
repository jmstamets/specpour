// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IngredientSummary extends IngredientSummary {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? parentId;
  @override
  final String? parentName;

  factory _$IngredientSummary(
          [void Function(IngredientSummaryBuilder)? updates]) =>
      (IngredientSummaryBuilder()..update(updates))._build();

  _$IngredientSummary._(
      {required this.id, required this.name, this.parentId, this.parentName})
      : super._();
  @override
  IngredientSummary rebuild(void Function(IngredientSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IngredientSummaryBuilder toBuilder() =>
      IngredientSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IngredientSummary &&
        id == other.id &&
        name == other.name &&
        parentId == other.parentId &&
        parentName == other.parentName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, parentName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IngredientSummary')
          ..add('id', id)
          ..add('name', name)
          ..add('parentId', parentId)
          ..add('parentName', parentName))
        .toString();
  }
}

class IngredientSummaryBuilder
    implements Builder<IngredientSummary, IngredientSummaryBuilder> {
  _$IngredientSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _parentId;
  String? get parentId => _$this._parentId;
  set parentId(String? parentId) => _$this._parentId = parentId;

  String? _parentName;
  String? get parentName => _$this._parentName;
  set parentName(String? parentName) => _$this._parentName = parentName;

  IngredientSummaryBuilder() {
    IngredientSummary._defaults(this);
  }

  IngredientSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _parentId = $v.parentId;
      _parentName = $v.parentName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IngredientSummary other) {
    _$v = other as _$IngredientSummary;
  }

  @override
  void update(void Function(IngredientSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IngredientSummary build() => _build();

  _$IngredientSummary _build() {
    final _$result = _$v ??
        _$IngredientSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'IngredientSummary', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'IngredientSummary', 'name'),
          parentId: parentId,
          parentName: parentName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
