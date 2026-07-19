// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_author.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const IngredientAuthorLibraryScopeEnum
    _$ingredientAuthorLibraryScopeEnum_personal =
    const IngredientAuthorLibraryScopeEnum._('personal');
const IngredientAuthorLibraryScopeEnum _$ingredientAuthorLibraryScopeEnum_bar =
    const IngredientAuthorLibraryScopeEnum._('bar');

IngredientAuthorLibraryScopeEnum _$ingredientAuthorLibraryScopeEnumValueOf(
    String name) {
  switch (name) {
    case 'personal':
      return _$ingredientAuthorLibraryScopeEnum_personal;
    case 'bar':
      return _$ingredientAuthorLibraryScopeEnum_bar;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<IngredientAuthorLibraryScopeEnum>
    _$ingredientAuthorLibraryScopeEnumValues = BuiltSet<
        IngredientAuthorLibraryScopeEnum>(const <IngredientAuthorLibraryScopeEnum>[
  _$ingredientAuthorLibraryScopeEnum_personal,
  _$ingredientAuthorLibraryScopeEnum_bar,
]);

const IngredientAuthorVisibilityEnum _$ingredientAuthorVisibilityEnum_private =
    const IngredientAuthorVisibilityEnum._('private');
const IngredientAuthorVisibilityEnum _$ingredientAuthorVisibilityEnum_public =
    const IngredientAuthorVisibilityEnum._('public');

IngredientAuthorVisibilityEnum _$ingredientAuthorVisibilityEnumValueOf(
    String name) {
  switch (name) {
    case 'private':
      return _$ingredientAuthorVisibilityEnum_private;
    case 'public':
      return _$ingredientAuthorVisibilityEnum_public;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<IngredientAuthorVisibilityEnum>
    _$ingredientAuthorVisibilityEnumValues = BuiltSet<
        IngredientAuthorVisibilityEnum>(const <IngredientAuthorVisibilityEnum>[
  _$ingredientAuthorVisibilityEnum_private,
  _$ingredientAuthorVisibilityEnum_public,
]);

Serializer<IngredientAuthorLibraryScopeEnum>
    _$ingredientAuthorLibraryScopeEnumSerializer =
    _$IngredientAuthorLibraryScopeEnumSerializer();
Serializer<IngredientAuthorVisibilityEnum>
    _$ingredientAuthorVisibilityEnumSerializer =
    _$IngredientAuthorVisibilityEnumSerializer();

class _$IngredientAuthorLibraryScopeEnumSerializer
    implements PrimitiveSerializer<IngredientAuthorLibraryScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'personal': 'personal',
    'bar': 'bar',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'personal': 'personal',
    'bar': 'bar',
  };

  @override
  final Iterable<Type> types = const <Type>[IngredientAuthorLibraryScopeEnum];
  @override
  final String wireName = 'IngredientAuthorLibraryScopeEnum';

  @override
  Object serialize(
          Serializers serializers, IngredientAuthorLibraryScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  IngredientAuthorLibraryScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      IngredientAuthorLibraryScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$IngredientAuthorVisibilityEnumSerializer
    implements PrimitiveSerializer<IngredientAuthorVisibilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'private': 'private',
    'public': 'public',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'private': 'private',
    'public': 'public',
  };

  @override
  final Iterable<Type> types = const <Type>[IngredientAuthorVisibilityEnum];
  @override
  final String wireName = 'IngredientAuthorVisibilityEnum';

  @override
  Object serialize(
          Serializers serializers, IngredientAuthorVisibilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  IngredientAuthorVisibilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      IngredientAuthorVisibilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$IngredientAuthor extends IngredientAuthor {
  @override
  final String id;
  @override
  final String name;
  @override
  final IngredientAuthorLibraryScopeEnum libraryScope;
  @override
  final String? venueId;
  @override
  final String categoryId;
  @override
  final String? parentId;
  @override
  final num? abvPercent;
  @override
  final BuiltList<String> sources;
  @override
  final String? description;
  @override
  final IngredientAuthorVisibilityEnum visibility;
  @override
  final HouseMade? houseMade;

  factory _$IngredientAuthor(
          [void Function(IngredientAuthorBuilder)? updates]) =>
      (IngredientAuthorBuilder()..update(updates))._build();

  _$IngredientAuthor._(
      {required this.id,
      required this.name,
      required this.libraryScope,
      this.venueId,
      required this.categoryId,
      this.parentId,
      this.abvPercent,
      required this.sources,
      this.description,
      required this.visibility,
      this.houseMade})
      : super._();
  @override
  IngredientAuthor rebuild(void Function(IngredientAuthorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IngredientAuthorBuilder toBuilder() =>
      IngredientAuthorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IngredientAuthor &&
        id == other.id &&
        name == other.name &&
        libraryScope == other.libraryScope &&
        venueId == other.venueId &&
        categoryId == other.categoryId &&
        parentId == other.parentId &&
        abvPercent == other.abvPercent &&
        sources == other.sources &&
        description == other.description &&
        visibility == other.visibility &&
        houseMade == other.houseMade;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, libraryScope.hashCode);
    _$hash = $jc(_$hash, venueId.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, abvPercent.hashCode);
    _$hash = $jc(_$hash, sources.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, visibility.hashCode);
    _$hash = $jc(_$hash, houseMade.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IngredientAuthor')
          ..add('id', id)
          ..add('name', name)
          ..add('libraryScope', libraryScope)
          ..add('venueId', venueId)
          ..add('categoryId', categoryId)
          ..add('parentId', parentId)
          ..add('abvPercent', abvPercent)
          ..add('sources', sources)
          ..add('description', description)
          ..add('visibility', visibility)
          ..add('houseMade', houseMade))
        .toString();
  }
}

class IngredientAuthorBuilder
    implements Builder<IngredientAuthor, IngredientAuthorBuilder> {
  _$IngredientAuthor? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  IngredientAuthorLibraryScopeEnum? _libraryScope;
  IngredientAuthorLibraryScopeEnum? get libraryScope => _$this._libraryScope;
  set libraryScope(IngredientAuthorLibraryScopeEnum? libraryScope) =>
      _$this._libraryScope = libraryScope;

  String? _venueId;
  String? get venueId => _$this._venueId;
  set venueId(String? venueId) => _$this._venueId = venueId;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _parentId;
  String? get parentId => _$this._parentId;
  set parentId(String? parentId) => _$this._parentId = parentId;

  num? _abvPercent;
  num? get abvPercent => _$this._abvPercent;
  set abvPercent(num? abvPercent) => _$this._abvPercent = abvPercent;

  ListBuilder<String>? _sources;
  ListBuilder<String> get sources => _$this._sources ??= ListBuilder<String>();
  set sources(ListBuilder<String>? sources) => _$this._sources = sources;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  IngredientAuthorVisibilityEnum? _visibility;
  IngredientAuthorVisibilityEnum? get visibility => _$this._visibility;
  set visibility(IngredientAuthorVisibilityEnum? visibility) =>
      _$this._visibility = visibility;

  HouseMadeBuilder? _houseMade;
  HouseMadeBuilder get houseMade => _$this._houseMade ??= HouseMadeBuilder();
  set houseMade(HouseMadeBuilder? houseMade) => _$this._houseMade = houseMade;

  IngredientAuthorBuilder() {
    IngredientAuthor._defaults(this);
  }

  IngredientAuthorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _libraryScope = $v.libraryScope;
      _venueId = $v.venueId;
      _categoryId = $v.categoryId;
      _parentId = $v.parentId;
      _abvPercent = $v.abvPercent;
      _sources = $v.sources.toBuilder();
      _description = $v.description;
      _visibility = $v.visibility;
      _houseMade = $v.houseMade?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IngredientAuthor other) {
    _$v = other as _$IngredientAuthor;
  }

  @override
  void update(void Function(IngredientAuthorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IngredientAuthor build() => _build();

  _$IngredientAuthor _build() {
    _$IngredientAuthor _$result;
    try {
      _$result = _$v ??
          _$IngredientAuthor._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'IngredientAuthor', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'IngredientAuthor', 'name'),
            libraryScope: BuiltValueNullFieldError.checkNotNull(
                libraryScope, r'IngredientAuthor', 'libraryScope'),
            venueId: venueId,
            categoryId: BuiltValueNullFieldError.checkNotNull(
                categoryId, r'IngredientAuthor', 'categoryId'),
            parentId: parentId,
            abvPercent: abvPercent,
            sources: sources.build(),
            description: description,
            visibility: BuiltValueNullFieldError.checkNotNull(
                visibility, r'IngredientAuthor', 'visibility'),
            houseMade: _houseMade?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sources';
        sources.build();

        _$failedField = 'houseMade';
        _houseMade?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'IngredientAuthor', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
