// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_term_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GlossaryTermSummary extends GlossaryTermSummary {
  @override
  final String id;
  @override
  final String term;

  factory _$GlossaryTermSummary(
          [void Function(GlossaryTermSummaryBuilder)? updates]) =>
      (GlossaryTermSummaryBuilder()..update(updates))._build();

  _$GlossaryTermSummary._({required this.id, required this.term}) : super._();
  @override
  GlossaryTermSummary rebuild(
          void Function(GlossaryTermSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GlossaryTermSummaryBuilder toBuilder() =>
      GlossaryTermSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GlossaryTermSummary && id == other.id && term == other.term;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, term.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GlossaryTermSummary')
          ..add('id', id)
          ..add('term', term))
        .toString();
  }
}

class GlossaryTermSummaryBuilder
    implements Builder<GlossaryTermSummary, GlossaryTermSummaryBuilder> {
  _$GlossaryTermSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _term;
  String? get term => _$this._term;
  set term(String? term) => _$this._term = term;

  GlossaryTermSummaryBuilder() {
    GlossaryTermSummary._defaults(this);
  }

  GlossaryTermSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _term = $v.term;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GlossaryTermSummary other) {
    _$v = other as _$GlossaryTermSummary;
  }

  @override
  void update(void Function(GlossaryTermSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GlossaryTermSummary build() => _build();

  _$GlossaryTermSummary _build() {
    final _$result = _$v ??
        _$GlossaryTermSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'GlossaryTermSummary', 'id'),
          term: BuiltValueNullFieldError.checkNotNull(
              term, r'GlossaryTermSummary', 'term'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
