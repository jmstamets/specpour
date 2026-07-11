// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_article_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GlossaryArticleDetail extends GlossaryArticleDetail {
  @override
  final String id;
  @override
  final String title;
  @override
  final String body;

  factory _$GlossaryArticleDetail(
          [void Function(GlossaryArticleDetailBuilder)? updates]) =>
      (GlossaryArticleDetailBuilder()..update(updates))._build();

  _$GlossaryArticleDetail._(
      {required this.id, required this.title, required this.body})
      : super._();
  @override
  GlossaryArticleDetail rebuild(
          void Function(GlossaryArticleDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GlossaryArticleDetailBuilder toBuilder() =>
      GlossaryArticleDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GlossaryArticleDetail &&
        id == other.id &&
        title == other.title &&
        body == other.body;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GlossaryArticleDetail')
          ..add('id', id)
          ..add('title', title)
          ..add('body', body))
        .toString();
  }
}

class GlossaryArticleDetailBuilder
    implements Builder<GlossaryArticleDetail, GlossaryArticleDetailBuilder> {
  _$GlossaryArticleDetail? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  GlossaryArticleDetailBuilder() {
    GlossaryArticleDetail._defaults(this);
  }

  GlossaryArticleDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _body = $v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GlossaryArticleDetail other) {
    _$v = other as _$GlossaryArticleDetail;
  }

  @override
  void update(void Function(GlossaryArticleDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GlossaryArticleDetail build() => _build();

  _$GlossaryArticleDetail _build() {
    final _$result = _$v ??
        _$GlossaryArticleDetail._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'GlossaryArticleDetail', 'id'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'GlossaryArticleDetail', 'title'),
          body: BuiltValueNullFieldError.checkNotNull(
              body, r'GlossaryArticleDetail', 'body'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
