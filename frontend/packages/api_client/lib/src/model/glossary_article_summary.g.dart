// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_article_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GlossaryArticleSummary extends GlossaryArticleSummary {
  @override
  final String id;
  @override
  final String title;

  factory _$GlossaryArticleSummary(
          [void Function(GlossaryArticleSummaryBuilder)? updates]) =>
      (GlossaryArticleSummaryBuilder()..update(updates))._build();

  _$GlossaryArticleSummary._({required this.id, required this.title})
      : super._();
  @override
  GlossaryArticleSummary rebuild(
          void Function(GlossaryArticleSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GlossaryArticleSummaryBuilder toBuilder() =>
      GlossaryArticleSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GlossaryArticleSummary &&
        id == other.id &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GlossaryArticleSummary')
          ..add('id', id)
          ..add('title', title))
        .toString();
  }
}

class GlossaryArticleSummaryBuilder
    implements Builder<GlossaryArticleSummary, GlossaryArticleSummaryBuilder> {
  _$GlossaryArticleSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  GlossaryArticleSummaryBuilder() {
    GlossaryArticleSummary._defaults(this);
  }

  GlossaryArticleSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GlossaryArticleSummary other) {
    _$v = other as _$GlossaryArticleSummary;
  }

  @override
  void update(void Function(GlossaryArticleSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GlossaryArticleSummary build() => _build();

  _$GlossaryArticleSummary _build() {
    final _$result = _$v ??
        _$GlossaryArticleSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'GlossaryArticleSummary', 'id'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'GlossaryArticleSummary', 'title'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
