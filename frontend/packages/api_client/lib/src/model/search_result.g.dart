// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SearchResultEntityTypeEnum _$searchResultEntityTypeEnum_recipe =
    const SearchResultEntityTypeEnum._('recipe');
const SearchResultEntityTypeEnum _$searchResultEntityTypeEnum_ingredient =
    const SearchResultEntityTypeEnum._('ingredient');
const SearchResultEntityTypeEnum _$searchResultEntityTypeEnum_equipment =
    const SearchResultEntityTypeEnum._('equipment');
const SearchResultEntityTypeEnum _$searchResultEntityTypeEnum_glossaryTerm =
    const SearchResultEntityTypeEnum._('glossaryTerm');
const SearchResultEntityTypeEnum _$searchResultEntityTypeEnum_article =
    const SearchResultEntityTypeEnum._('article');

SearchResultEntityTypeEnum _$searchResultEntityTypeEnumValueOf(String name) {
  switch (name) {
    case 'recipe':
      return _$searchResultEntityTypeEnum_recipe;
    case 'ingredient':
      return _$searchResultEntityTypeEnum_ingredient;
    case 'equipment':
      return _$searchResultEntityTypeEnum_equipment;
    case 'glossaryTerm':
      return _$searchResultEntityTypeEnum_glossaryTerm;
    case 'article':
      return _$searchResultEntityTypeEnum_article;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchResultEntityTypeEnum> _$searchResultEntityTypeEnumValues =
    BuiltSet<SearchResultEntityTypeEnum>(const <SearchResultEntityTypeEnum>[
  _$searchResultEntityTypeEnum_recipe,
  _$searchResultEntityTypeEnum_ingredient,
  _$searchResultEntityTypeEnum_equipment,
  _$searchResultEntityTypeEnum_glossaryTerm,
  _$searchResultEntityTypeEnum_article,
]);

Serializer<SearchResultEntityTypeEnum> _$searchResultEntityTypeEnumSerializer =
    _$SearchResultEntityTypeEnumSerializer();

class _$SearchResultEntityTypeEnumSerializer
    implements PrimitiveSerializer<SearchResultEntityTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'recipe': 'recipe',
    'ingredient': 'ingredient',
    'equipment': 'equipment',
    'glossaryTerm': 'glossaryTerm',
    'article': 'article',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'recipe': 'recipe',
    'ingredient': 'ingredient',
    'equipment': 'equipment',
    'glossaryTerm': 'glossaryTerm',
    'article': 'article',
  };

  @override
  final Iterable<Type> types = const <Type>[SearchResultEntityTypeEnum];
  @override
  final String wireName = 'SearchResultEntityTypeEnum';

  @override
  Object serialize(Serializers serializers, SearchResultEntityTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchResultEntityTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchResultEntityTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchResult extends SearchResult {
  @override
  final SearchResultEntityTypeEnum entityType;
  @override
  final String entityId;
  @override
  final String title;
  @override
  final String? snippet;
  @override
  final num score;

  factory _$SearchResult([void Function(SearchResultBuilder)? updates]) =>
      (SearchResultBuilder()..update(updates))._build();

  _$SearchResult._(
      {required this.entityType,
      required this.entityId,
      required this.title,
      this.snippet,
      required this.score})
      : super._();
  @override
  SearchResult rebuild(void Function(SearchResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchResultBuilder toBuilder() => SearchResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchResult &&
        entityType == other.entityType &&
        entityId == other.entityId &&
        title == other.title &&
        snippet == other.snippet &&
        score == other.score;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entityType.hashCode);
    _$hash = $jc(_$hash, entityId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, snippet.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchResult')
          ..add('entityType', entityType)
          ..add('entityId', entityId)
          ..add('title', title)
          ..add('snippet', snippet)
          ..add('score', score))
        .toString();
  }
}

class SearchResultBuilder
    implements Builder<SearchResult, SearchResultBuilder> {
  _$SearchResult? _$v;

  SearchResultEntityTypeEnum? _entityType;
  SearchResultEntityTypeEnum? get entityType => _$this._entityType;
  set entityType(SearchResultEntityTypeEnum? entityType) =>
      _$this._entityType = entityType;

  String? _entityId;
  String? get entityId => _$this._entityId;
  set entityId(String? entityId) => _$this._entityId = entityId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _snippet;
  String? get snippet => _$this._snippet;
  set snippet(String? snippet) => _$this._snippet = snippet;

  num? _score;
  num? get score => _$this._score;
  set score(num? score) => _$this._score = score;

  SearchResultBuilder() {
    SearchResult._defaults(this);
  }

  SearchResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entityType = $v.entityType;
      _entityId = $v.entityId;
      _title = $v.title;
      _snippet = $v.snippet;
      _score = $v.score;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchResult other) {
    _$v = other as _$SearchResult;
  }

  @override
  void update(void Function(SearchResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchResult build() => _build();

  _$SearchResult _build() {
    final _$result = _$v ??
        _$SearchResult._(
          entityType: BuiltValueNullFieldError.checkNotNull(
              entityType, r'SearchResult', 'entityType'),
          entityId: BuiltValueNullFieldError.checkNotNull(
              entityId, r'SearchResult', 'entityId'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'SearchResult', 'title'),
          snippet: snippet,
          score: BuiltValueNullFieldError.checkNotNull(
              score, r'SearchResult', 'score'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
