// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_term_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GlossaryTermDetail extends GlossaryTermDetail {
  @override
  final String id;
  @override
  final String term;
  @override
  final BuiltList<String> definitions;

  factory _$GlossaryTermDetail(
          [void Function(GlossaryTermDetailBuilder)? updates]) =>
      (GlossaryTermDetailBuilder()..update(updates))._build();

  _$GlossaryTermDetail._(
      {required this.id, required this.term, required this.definitions})
      : super._();
  @override
  GlossaryTermDetail rebuild(
          void Function(GlossaryTermDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GlossaryTermDetailBuilder toBuilder() =>
      GlossaryTermDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GlossaryTermDetail &&
        id == other.id &&
        term == other.term &&
        definitions == other.definitions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, term.hashCode);
    _$hash = $jc(_$hash, definitions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GlossaryTermDetail')
          ..add('id', id)
          ..add('term', term)
          ..add('definitions', definitions))
        .toString();
  }
}

class GlossaryTermDetailBuilder
    implements Builder<GlossaryTermDetail, GlossaryTermDetailBuilder> {
  _$GlossaryTermDetail? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _term;
  String? get term => _$this._term;
  set term(String? term) => _$this._term = term;

  ListBuilder<String>? _definitions;
  ListBuilder<String> get definitions =>
      _$this._definitions ??= ListBuilder<String>();
  set definitions(ListBuilder<String>? definitions) =>
      _$this._definitions = definitions;

  GlossaryTermDetailBuilder() {
    GlossaryTermDetail._defaults(this);
  }

  GlossaryTermDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _term = $v.term;
      _definitions = $v.definitions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GlossaryTermDetail other) {
    _$v = other as _$GlossaryTermDetail;
  }

  @override
  void update(void Function(GlossaryTermDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GlossaryTermDetail build() => _build();

  _$GlossaryTermDetail _build() {
    _$GlossaryTermDetail _$result;
    try {
      _$result = _$v ??
          _$GlossaryTermDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'GlossaryTermDetail', 'id'),
            term: BuiltValueNullFieldError.checkNotNull(
                term, r'GlossaryTermDetail', 'term'),
            definitions: definitions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'definitions';
        definitions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GlossaryTermDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
