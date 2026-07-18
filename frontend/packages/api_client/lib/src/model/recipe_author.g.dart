// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_author.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RecipeAuthorLibraryScopeEnum _$recipeAuthorLibraryScopeEnum_personal =
    const RecipeAuthorLibraryScopeEnum._('personal');
const RecipeAuthorLibraryScopeEnum _$recipeAuthorLibraryScopeEnum_bar =
    const RecipeAuthorLibraryScopeEnum._('bar');

RecipeAuthorLibraryScopeEnum _$recipeAuthorLibraryScopeEnumValueOf(
    String name) {
  switch (name) {
    case 'personal':
      return _$recipeAuthorLibraryScopeEnum_personal;
    case 'bar':
      return _$recipeAuthorLibraryScopeEnum_bar;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RecipeAuthorLibraryScopeEnum>
    _$recipeAuthorLibraryScopeEnumValues =
    BuiltSet<RecipeAuthorLibraryScopeEnum>(const <RecipeAuthorLibraryScopeEnum>[
  _$recipeAuthorLibraryScopeEnum_personal,
  _$recipeAuthorLibraryScopeEnum_bar,
]);

const RecipeAuthorVisibilityEnum _$recipeAuthorVisibilityEnum_private =
    const RecipeAuthorVisibilityEnum._('private');
const RecipeAuthorVisibilityEnum _$recipeAuthorVisibilityEnum_public =
    const RecipeAuthorVisibilityEnum._('public');

RecipeAuthorVisibilityEnum _$recipeAuthorVisibilityEnumValueOf(String name) {
  switch (name) {
    case 'private':
      return _$recipeAuthorVisibilityEnum_private;
    case 'public':
      return _$recipeAuthorVisibilityEnum_public;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RecipeAuthorVisibilityEnum> _$recipeAuthorVisibilityEnumValues =
    BuiltSet<RecipeAuthorVisibilityEnum>(const <RecipeAuthorVisibilityEnum>[
  _$recipeAuthorVisibilityEnum_private,
  _$recipeAuthorVisibilityEnum_public,
]);

Serializer<RecipeAuthorLibraryScopeEnum>
    _$recipeAuthorLibraryScopeEnumSerializer =
    _$RecipeAuthorLibraryScopeEnumSerializer();
Serializer<RecipeAuthorVisibilityEnum> _$recipeAuthorVisibilityEnumSerializer =
    _$RecipeAuthorVisibilityEnumSerializer();

class _$RecipeAuthorLibraryScopeEnumSerializer
    implements PrimitiveSerializer<RecipeAuthorLibraryScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'personal': 'personal',
    'bar': 'bar',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'personal': 'personal',
    'bar': 'bar',
  };

  @override
  final Iterable<Type> types = const <Type>[RecipeAuthorLibraryScopeEnum];
  @override
  final String wireName = 'RecipeAuthorLibraryScopeEnum';

  @override
  Object serialize(Serializers serializers, RecipeAuthorLibraryScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RecipeAuthorLibraryScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RecipeAuthorLibraryScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RecipeAuthorVisibilityEnumSerializer
    implements PrimitiveSerializer<RecipeAuthorVisibilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'private': 'private',
    'public': 'public',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'private': 'private',
    'public': 'public',
  };

  @override
  final Iterable<Type> types = const <Type>[RecipeAuthorVisibilityEnum];
  @override
  final String wireName = 'RecipeAuthorVisibilityEnum';

  @override
  Object serialize(Serializers serializers, RecipeAuthorVisibilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RecipeAuthorVisibilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RecipeAuthorVisibilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RecipeAuthor extends RecipeAuthor {
  @override
  final String id;
  @override
  final String primaryName;
  @override
  final BuiltList<String> alternateNames;
  @override
  final RecipeAuthorLibraryScopeEnum libraryScope;
  @override
  final String? venueId;
  @override
  final BuiltList<String> instructions;
  @override
  final BuiltList<RecipeIngredientLine> ingredientLines;
  @override
  final BuiltList<String> categoryIds;
  @override
  final BuiltList<String> tags;
  @override
  final RecipeAuthorVisibilityEnum visibility;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$RecipeAuthor([void Function(RecipeAuthorBuilder)? updates]) =>
      (RecipeAuthorBuilder()..update(updates))._build();

  _$RecipeAuthor._(
      {required this.id,
      required this.primaryName,
      required this.alternateNames,
      required this.libraryScope,
      this.venueId,
      required this.instructions,
      required this.ingredientLines,
      required this.categoryIds,
      required this.tags,
      required this.visibility,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  RecipeAuthor rebuild(void Function(RecipeAuthorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeAuthorBuilder toBuilder() => RecipeAuthorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeAuthor &&
        id == other.id &&
        primaryName == other.primaryName &&
        alternateNames == other.alternateNames &&
        libraryScope == other.libraryScope &&
        venueId == other.venueId &&
        instructions == other.instructions &&
        ingredientLines == other.ingredientLines &&
        categoryIds == other.categoryIds &&
        tags == other.tags &&
        visibility == other.visibility &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, primaryName.hashCode);
    _$hash = $jc(_$hash, alternateNames.hashCode);
    _$hash = $jc(_$hash, libraryScope.hashCode);
    _$hash = $jc(_$hash, venueId.hashCode);
    _$hash = $jc(_$hash, instructions.hashCode);
    _$hash = $jc(_$hash, ingredientLines.hashCode);
    _$hash = $jc(_$hash, categoryIds.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, visibility.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeAuthor')
          ..add('id', id)
          ..add('primaryName', primaryName)
          ..add('alternateNames', alternateNames)
          ..add('libraryScope', libraryScope)
          ..add('venueId', venueId)
          ..add('instructions', instructions)
          ..add('ingredientLines', ingredientLines)
          ..add('categoryIds', categoryIds)
          ..add('tags', tags)
          ..add('visibility', visibility)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class RecipeAuthorBuilder
    implements Builder<RecipeAuthor, RecipeAuthorBuilder> {
  _$RecipeAuthor? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _primaryName;
  String? get primaryName => _$this._primaryName;
  set primaryName(String? primaryName) => _$this._primaryName = primaryName;

  ListBuilder<String>? _alternateNames;
  ListBuilder<String> get alternateNames =>
      _$this._alternateNames ??= ListBuilder<String>();
  set alternateNames(ListBuilder<String>? alternateNames) =>
      _$this._alternateNames = alternateNames;

  RecipeAuthorLibraryScopeEnum? _libraryScope;
  RecipeAuthorLibraryScopeEnum? get libraryScope => _$this._libraryScope;
  set libraryScope(RecipeAuthorLibraryScopeEnum? libraryScope) =>
      _$this._libraryScope = libraryScope;

  String? _venueId;
  String? get venueId => _$this._venueId;
  set venueId(String? venueId) => _$this._venueId = venueId;

  ListBuilder<String>? _instructions;
  ListBuilder<String> get instructions =>
      _$this._instructions ??= ListBuilder<String>();
  set instructions(ListBuilder<String>? instructions) =>
      _$this._instructions = instructions;

  ListBuilder<RecipeIngredientLine>? _ingredientLines;
  ListBuilder<RecipeIngredientLine> get ingredientLines =>
      _$this._ingredientLines ??= ListBuilder<RecipeIngredientLine>();
  set ingredientLines(ListBuilder<RecipeIngredientLine>? ingredientLines) =>
      _$this._ingredientLines = ingredientLines;

  ListBuilder<String>? _categoryIds;
  ListBuilder<String> get categoryIds =>
      _$this._categoryIds ??= ListBuilder<String>();
  set categoryIds(ListBuilder<String>? categoryIds) =>
      _$this._categoryIds = categoryIds;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  RecipeAuthorVisibilityEnum? _visibility;
  RecipeAuthorVisibilityEnum? get visibility => _$this._visibility;
  set visibility(RecipeAuthorVisibilityEnum? visibility) =>
      _$this._visibility = visibility;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  RecipeAuthorBuilder() {
    RecipeAuthor._defaults(this);
  }

  RecipeAuthorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _primaryName = $v.primaryName;
      _alternateNames = $v.alternateNames.toBuilder();
      _libraryScope = $v.libraryScope;
      _venueId = $v.venueId;
      _instructions = $v.instructions.toBuilder();
      _ingredientLines = $v.ingredientLines.toBuilder();
      _categoryIds = $v.categoryIds.toBuilder();
      _tags = $v.tags.toBuilder();
      _visibility = $v.visibility;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeAuthor other) {
    _$v = other as _$RecipeAuthor;
  }

  @override
  void update(void Function(RecipeAuthorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeAuthor build() => _build();

  _$RecipeAuthor _build() {
    _$RecipeAuthor _$result;
    try {
      _$result = _$v ??
          _$RecipeAuthor._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'RecipeAuthor', 'id'),
            primaryName: BuiltValueNullFieldError.checkNotNull(
                primaryName, r'RecipeAuthor', 'primaryName'),
            alternateNames: alternateNames.build(),
            libraryScope: BuiltValueNullFieldError.checkNotNull(
                libraryScope, r'RecipeAuthor', 'libraryScope'),
            venueId: venueId,
            instructions: instructions.build(),
            ingredientLines: ingredientLines.build(),
            categoryIds: categoryIds.build(),
            tags: tags.build(),
            visibility: BuiltValueNullFieldError.checkNotNull(
                visibility, r'RecipeAuthor', 'visibility'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'RecipeAuthor', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'RecipeAuthor', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'alternateNames';
        alternateNames.build();

        _$failedField = 'instructions';
        instructions.build();
        _$failedField = 'ingredientLines';
        ingredientLines.build();
        _$failedField = 'categoryIds';
        categoryIds.build();
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RecipeAuthor', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
