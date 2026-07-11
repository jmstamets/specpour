// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concept_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConceptSummary extends ConceptSummary {
  @override
  final String id;
  @override
  final String name;
  @override
  final String description;

  factory _$ConceptSummary([void Function(ConceptSummaryBuilder)? updates]) =>
      (ConceptSummaryBuilder()..update(updates))._build();

  _$ConceptSummary._(
      {required this.id, required this.name, required this.description})
      : super._();
  @override
  ConceptSummary rebuild(void Function(ConceptSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConceptSummaryBuilder toBuilder() => ConceptSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConceptSummary &&
        id == other.id &&
        name == other.name &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConceptSummary')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description))
        .toString();
  }
}

class ConceptSummaryBuilder
    implements Builder<ConceptSummary, ConceptSummaryBuilder> {
  _$ConceptSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ConceptSummaryBuilder() {
    ConceptSummary._defaults(this);
  }

  ConceptSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConceptSummary other) {
    _$v = other as _$ConceptSummary;
  }

  @override
  void update(void Function(ConceptSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConceptSummary build() => _build();

  _$ConceptSummary _build() {
    final _$result = _$v ??
        _$ConceptSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ConceptSummary', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ConceptSummary', 'name'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'ConceptSummary', 'description'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
