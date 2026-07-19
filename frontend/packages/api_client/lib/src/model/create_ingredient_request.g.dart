// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_ingredient_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateIngredientRequestLibraryScopeEnum
    _$createIngredientRequestLibraryScopeEnum_personal =
    const CreateIngredientRequestLibraryScopeEnum._('personal');
const CreateIngredientRequestLibraryScopeEnum
    _$createIngredientRequestLibraryScopeEnum_bar =
    const CreateIngredientRequestLibraryScopeEnum._('bar');

CreateIngredientRequestLibraryScopeEnum
    _$createIngredientRequestLibraryScopeEnumValueOf(String name) {
  switch (name) {
    case 'personal':
      return _$createIngredientRequestLibraryScopeEnum_personal;
    case 'bar':
      return _$createIngredientRequestLibraryScopeEnum_bar;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateIngredientRequestLibraryScopeEnum>
    _$createIngredientRequestLibraryScopeEnumValues = BuiltSet<
        CreateIngredientRequestLibraryScopeEnum>(const <CreateIngredientRequestLibraryScopeEnum>[
  _$createIngredientRequestLibraryScopeEnum_personal,
  _$createIngredientRequestLibraryScopeEnum_bar,
]);

Serializer<CreateIngredientRequestLibraryScopeEnum>
    _$createIngredientRequestLibraryScopeEnumSerializer =
    _$CreateIngredientRequestLibraryScopeEnumSerializer();

class _$CreateIngredientRequestLibraryScopeEnumSerializer
    implements PrimitiveSerializer<CreateIngredientRequestLibraryScopeEnum> {
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
    CreateIngredientRequestLibraryScopeEnum
  ];
  @override
  final String wireName = 'CreateIngredientRequestLibraryScopeEnum';

  @override
  Object serialize(Serializers serializers,
          CreateIngredientRequestLibraryScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateIngredientRequestLibraryScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateIngredientRequestLibraryScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateIngredientRequest extends CreateIngredientRequest {
  @override
  final String name;
  @override
  final CreateIngredientRequestLibraryScopeEnum libraryScope;
  @override
  final String? venueId;
  @override
  final String? categoryId;
  @override
  final String? parentId;
  @override
  final num? abvPercent;
  @override
  final BuiltList<String>? sources;
  @override
  final String? description;
  @override
  final CreateHouseMadeRequest? houseMade;

  factory _$CreateIngredientRequest(
          [void Function(CreateIngredientRequestBuilder)? updates]) =>
      (CreateIngredientRequestBuilder()..update(updates))._build();

  _$CreateIngredientRequest._(
      {required this.name,
      required this.libraryScope,
      this.venueId,
      this.categoryId,
      this.parentId,
      this.abvPercent,
      this.sources,
      this.description,
      this.houseMade})
      : super._();
  @override
  CreateIngredientRequest rebuild(
          void Function(CreateIngredientRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateIngredientRequestBuilder toBuilder() =>
      CreateIngredientRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateIngredientRequest &&
        name == other.name &&
        libraryScope == other.libraryScope &&
        venueId == other.venueId &&
        categoryId == other.categoryId &&
        parentId == other.parentId &&
        abvPercent == other.abvPercent &&
        sources == other.sources &&
        description == other.description &&
        houseMade == other.houseMade;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, libraryScope.hashCode);
    _$hash = $jc(_$hash, venueId.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, abvPercent.hashCode);
    _$hash = $jc(_$hash, sources.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, houseMade.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateIngredientRequest')
          ..add('name', name)
          ..add('libraryScope', libraryScope)
          ..add('venueId', venueId)
          ..add('categoryId', categoryId)
          ..add('parentId', parentId)
          ..add('abvPercent', abvPercent)
          ..add('sources', sources)
          ..add('description', description)
          ..add('houseMade', houseMade))
        .toString();
  }
}

class CreateIngredientRequestBuilder
    implements
        Builder<CreateIngredientRequest, CreateIngredientRequestBuilder> {
  _$CreateIngredientRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CreateIngredientRequestLibraryScopeEnum? _libraryScope;
  CreateIngredientRequestLibraryScopeEnum? get libraryScope =>
      _$this._libraryScope;
  set libraryScope(CreateIngredientRequestLibraryScopeEnum? libraryScope) =>
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

  CreateHouseMadeRequestBuilder? _houseMade;
  CreateHouseMadeRequestBuilder get houseMade =>
      _$this._houseMade ??= CreateHouseMadeRequestBuilder();
  set houseMade(CreateHouseMadeRequestBuilder? houseMade) =>
      _$this._houseMade = houseMade;

  CreateIngredientRequestBuilder() {
    CreateIngredientRequest._defaults(this);
  }

  CreateIngredientRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _libraryScope = $v.libraryScope;
      _venueId = $v.venueId;
      _categoryId = $v.categoryId;
      _parentId = $v.parentId;
      _abvPercent = $v.abvPercent;
      _sources = $v.sources?.toBuilder();
      _description = $v.description;
      _houseMade = $v.houseMade?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateIngredientRequest other) {
    _$v = other as _$CreateIngredientRequest;
  }

  @override
  void update(void Function(CreateIngredientRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateIngredientRequest build() => _build();

  _$CreateIngredientRequest _build() {
    _$CreateIngredientRequest _$result;
    try {
      _$result = _$v ??
          _$CreateIngredientRequest._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CreateIngredientRequest', 'name'),
            libraryScope: BuiltValueNullFieldError.checkNotNull(
                libraryScope, r'CreateIngredientRequest', 'libraryScope'),
            venueId: venueId,
            categoryId: categoryId,
            parentId: parentId,
            abvPercent: abvPercent,
            sources: _sources?.build(),
            description: description,
            houseMade: _houseMade?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sources';
        _sources?.build();

        _$failedField = 'houseMade';
        _houseMade?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreateIngredientRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
