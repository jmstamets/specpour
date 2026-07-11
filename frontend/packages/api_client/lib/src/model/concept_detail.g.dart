// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concept_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConceptDetail extends ConceptDetail {
  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final BuiltList<ConceptVariant> variants;

  factory _$ConceptDetail([void Function(ConceptDetailBuilder)? updates]) =>
      (ConceptDetailBuilder()..update(updates))._build();

  _$ConceptDetail._(
      {required this.id,
      required this.name,
      required this.description,
      required this.variants})
      : super._();
  @override
  ConceptDetail rebuild(void Function(ConceptDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConceptDetailBuilder toBuilder() => ConceptDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConceptDetail &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        variants == other.variants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConceptDetail')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('variants', variants))
        .toString();
  }
}

class ConceptDetailBuilder
    implements Builder<ConceptDetail, ConceptDetailBuilder> {
  _$ConceptDetail? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ListBuilder<ConceptVariant>? _variants;
  ListBuilder<ConceptVariant> get variants =>
      _$this._variants ??= ListBuilder<ConceptVariant>();
  set variants(ListBuilder<ConceptVariant>? variants) =>
      _$this._variants = variants;

  ConceptDetailBuilder() {
    ConceptDetail._defaults(this);
  }

  ConceptDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _variants = $v.variants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConceptDetail other) {
    _$v = other as _$ConceptDetail;
  }

  @override
  void update(void Function(ConceptDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConceptDetail build() => _build();

  _$ConceptDetail _build() {
    _$ConceptDetail _$result;
    try {
      _$result = _$v ??
          _$ConceptDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ConceptDetail', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ConceptDetail', 'name'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'ConceptDetail', 'description'),
            variants: variants.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'variants';
        variants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ConceptDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
