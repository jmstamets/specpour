// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_recipe_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateRecipeRequestLibraryScopeEnum
    _$createRecipeRequestLibraryScopeEnum_personal =
    const CreateRecipeRequestLibraryScopeEnum._('personal');
const CreateRecipeRequestLibraryScopeEnum
    _$createRecipeRequestLibraryScopeEnum_bar =
    const CreateRecipeRequestLibraryScopeEnum._('bar');

CreateRecipeRequestLibraryScopeEnum
    _$createRecipeRequestLibraryScopeEnumValueOf(String name) {
  switch (name) {
    case 'personal':
      return _$createRecipeRequestLibraryScopeEnum_personal;
    case 'bar':
      return _$createRecipeRequestLibraryScopeEnum_bar;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateRecipeRequestLibraryScopeEnum>
    _$createRecipeRequestLibraryScopeEnumValues = BuiltSet<
        CreateRecipeRequestLibraryScopeEnum>(const <CreateRecipeRequestLibraryScopeEnum>[
  _$createRecipeRequestLibraryScopeEnum_personal,
  _$createRecipeRequestLibraryScopeEnum_bar,
]);

Serializer<CreateRecipeRequestLibraryScopeEnum>
    _$createRecipeRequestLibraryScopeEnumSerializer =
    _$CreateRecipeRequestLibraryScopeEnumSerializer();

class _$CreateRecipeRequestLibraryScopeEnumSerializer
    implements PrimitiveSerializer<CreateRecipeRequestLibraryScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'personal': 'personal',
    'bar': 'bar',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'personal': 'personal',
    'bar': 'bar',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CreateRecipeRequestLibraryScopeEnum
  ];
  @override
  final String wireName = 'CreateRecipeRequestLibraryScopeEnum';

  @override
  Object serialize(
          Serializers serializers, CreateRecipeRequestLibraryScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateRecipeRequestLibraryScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateRecipeRequestLibraryScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateRecipeRequest extends CreateRecipeRequest {
  @override
  final String primaryName;
  @override
  final BuiltList<String>? alternateNames;
  @override
  final CreateRecipeRequestLibraryScopeEnum libraryScope;
  @override
  final String? venueId;
  @override
  final BuiltList<String>? instructions;
  @override
  final BuiltList<RecipeIngredientLineInput>? ingredientLines;
  @override
  final BuiltList<String>? categoryIds;
  @override
  final BuiltList<String>? tags;

  factory _$CreateRecipeRequest(
          [void Function(CreateRecipeRequestBuilder)? updates]) =>
      (CreateRecipeRequestBuilder()..update(updates))._build();

  _$CreateRecipeRequest._(
      {required this.primaryName,
      this.alternateNames,
      required this.libraryScope,
      this.venueId,
      this.instructions,
      this.ingredientLines,
      this.categoryIds,
      this.tags})
      : super._();
  @override
  CreateRecipeRequest rebuild(
          void Function(CreateRecipeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateRecipeRequestBuilder toBuilder() =>
      CreateRecipeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateRecipeRequest &&
        primaryName == other.primaryName &&
        alternateNames == other.alternateNames &&
        libraryScope == other.libraryScope &&
        venueId == other.venueId &&
        instructions == other.instructions &&
        ingredientLines == other.ingredientLines &&
        categoryIds == other.categoryIds &&
        tags == other.tags;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, primaryName.hashCode);
    _$hash = $jc(_$hash, alternateNames.hashCode);
    _$hash = $jc(_$hash, libraryScope.hashCode);
    _$hash = $jc(_$hash, venueId.hashCode);
    _$hash = $jc(_$hash, instructions.hashCode);
    _$hash = $jc(_$hash, ingredientLines.hashCode);
    _$hash = $jc(_$hash, categoryIds.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateRecipeRequest')
          ..add('primaryName', primaryName)
          ..add('alternateNames', alternateNames)
          ..add('libraryScope', libraryScope)
          ..add('venueId', venueId)
          ..add('instructions', instructions)
          ..add('ingredientLines', ingredientLines)
          ..add('categoryIds', categoryIds)
          ..add('tags', tags))
        .toString();
  }
}

class CreateRecipeRequestBuilder
    implements Builder<CreateRecipeRequest, CreateRecipeRequestBuilder> {
  _$CreateRecipeRequest? _$v;

  String? _primaryName;
  String? get primaryName => _$this._primaryName;
  set primaryName(String? primaryName) => _$this._primaryName = primaryName;

  ListBuilder<String>? _alternateNames;
  ListBuilder<String> get alternateNames =>
      _$this._alternateNames ??= ListBuilder<String>();
  set alternateNames(ListBuilder<String>? alternateNames) =>
      _$this._alternateNames = alternateNames;

  CreateRecipeRequestLibraryScopeEnum? _libraryScope;
  CreateRecipeRequestLibraryScopeEnum? get libraryScope => _$this._libraryScope;
  set libraryScope(CreateRecipeRequestLibraryScopeEnum? libraryScope) =>
      _$this._libraryScope = libraryScope;

  String? _venueId;
  String? get venueId => _$this._venueId;
  set venueId(String? venueId) => _$this._venueId = venueId;

  ListBuilder<String>? _instructions;
  ListBuilder<String> get instructions =>
      _$this._instructions ??= ListBuilder<String>();
  set instructions(ListBuilder<String>? instructions) =>
      _$this._instructions = instructions;

  ListBuilder<RecipeIngredientLineInput>? _ingredientLines;
  ListBuilder<RecipeIngredientLineInput> get ingredientLines =>
      _$this._ingredientLines ??= ListBuilder<RecipeIngredientLineInput>();
  set ingredientLines(
          ListBuilder<RecipeIngredientLineInput>? ingredientLines) =>
      _$this._ingredientLines = ingredientLines;

  ListBuilder<String>? _categoryIds;
  ListBuilder<String> get categoryIds =>
      _$this._categoryIds ??= ListBuilder<String>();
  set categoryIds(ListBuilder<String>? categoryIds) =>
      _$this._categoryIds = categoryIds;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  CreateRecipeRequestBuilder() {
    CreateRecipeRequest._defaults(this);
  }

  CreateRecipeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _primaryName = $v.primaryName;
      _alternateNames = $v.alternateNames?.toBuilder();
      _libraryScope = $v.libraryScope;
      _venueId = $v.venueId;
      _instructions = $v.instructions?.toBuilder();
      _ingredientLines = $v.ingredientLines?.toBuilder();
      _categoryIds = $v.categoryIds?.toBuilder();
      _tags = $v.tags?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateRecipeRequest other) {
    _$v = other as _$CreateRecipeRequest;
  }

  @override
  void update(void Function(CreateRecipeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateRecipeRequest build() => _build();

  _$CreateRecipeRequest _build() {
    _$CreateRecipeRequest _$result;
    try {
      _$result = _$v ??
          _$CreateRecipeRequest._(
            primaryName: BuiltValueNullFieldError.checkNotNull(
                primaryName, r'CreateRecipeRequest', 'primaryName'),
            alternateNames: _alternateNames?.build(),
            libraryScope: BuiltValueNullFieldError.checkNotNull(
                libraryScope, r'CreateRecipeRequest', 'libraryScope'),
            venueId: venueId,
            instructions: _instructions?.build(),
            ingredientLines: _ingredientLines?.build(),
            categoryIds: _categoryIds?.build(),
            tags: _tags?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'alternateNames';
        _alternateNames?.build();

        _$failedField = 'instructions';
        _instructions?.build();
        _$failedField = 'ingredientLines';
        _ingredientLines?.build();
        _$failedField = 'categoryIds';
        _categoryIds?.build();
        _$failedField = 'tags';
        _tags?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreateRecipeRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
