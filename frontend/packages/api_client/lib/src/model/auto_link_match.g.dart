// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_link_match.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutoLinkMatch extends AutoLinkMatch {
  @override
  final int start;
  @override
  final int length;
  @override
  final String termId;
  @override
  final String term;

  factory _$AutoLinkMatch([void Function(AutoLinkMatchBuilder)? updates]) =>
      (AutoLinkMatchBuilder()..update(updates))._build();

  _$AutoLinkMatch._(
      {required this.start,
      required this.length,
      required this.termId,
      required this.term})
      : super._();
  @override
  AutoLinkMatch rebuild(void Function(AutoLinkMatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoLinkMatchBuilder toBuilder() => AutoLinkMatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoLinkMatch &&
        start == other.start &&
        length == other.length &&
        termId == other.termId &&
        term == other.term;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, start.hashCode);
    _$hash = $jc(_$hash, length.hashCode);
    _$hash = $jc(_$hash, termId.hashCode);
    _$hash = $jc(_$hash, term.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoLinkMatch')
          ..add('start', start)
          ..add('length', length)
          ..add('termId', termId)
          ..add('term', term))
        .toString();
  }
}

class AutoLinkMatchBuilder
    implements Builder<AutoLinkMatch, AutoLinkMatchBuilder> {
  _$AutoLinkMatch? _$v;

  int? _start;
  int? get start => _$this._start;
  set start(int? start) => _$this._start = start;

  int? _length;
  int? get length => _$this._length;
  set length(int? length) => _$this._length = length;

  String? _termId;
  String? get termId => _$this._termId;
  set termId(String? termId) => _$this._termId = termId;

  String? _term;
  String? get term => _$this._term;
  set term(String? term) => _$this._term = term;

  AutoLinkMatchBuilder() {
    AutoLinkMatch._defaults(this);
  }

  AutoLinkMatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _start = $v.start;
      _length = $v.length;
      _termId = $v.termId;
      _term = $v.term;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoLinkMatch other) {
    _$v = other as _$AutoLinkMatch;
  }

  @override
  void update(void Function(AutoLinkMatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoLinkMatch build() => _build();

  _$AutoLinkMatch _build() {
    final _$result = _$v ??
        _$AutoLinkMatch._(
          start: BuiltValueNullFieldError.checkNotNull(
              start, r'AutoLinkMatch', 'start'),
          length: BuiltValueNullFieldError.checkNotNull(
              length, r'AutoLinkMatch', 'length'),
          termId: BuiltValueNullFieldError.checkNotNull(
              termId, r'AutoLinkMatch', 'termId'),
          term: BuiltValueNullFieldError.checkNotNull(
              term, r'AutoLinkMatch', 'term'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
