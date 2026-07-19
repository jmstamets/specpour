// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_ingredient_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateIngredientRequest extends UpdateIngredientRequest {
  @override
  final String name;
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

  factory _$UpdateIngredientRequest(
          [void Function(UpdateIngredientRequestBuilder)? updates]) =>
      (UpdateIngredientRequestBuilder()..update(updates))._build();

  _$UpdateIngredientRequest._(
      {required this.name,
      this.categoryId,
      this.parentId,
      this.abvPercent,
      this.sources,
      this.description,
      this.houseMade})
      : super._();
  @override
  UpdateIngredientRequest rebuild(
          void Function(UpdateIngredientRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateIngredientRequestBuilder toBuilder() =>
      UpdateIngredientRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateIngredientRequest &&
        name == other.name &&
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
    return (newBuiltValueToStringHelper(r'UpdateIngredientRequest')
          ..add('name', name)
          ..add('categoryId', categoryId)
          ..add('parentId', parentId)
          ..add('abvPercent', abvPercent)
          ..add('sources', sources)
          ..add('description', description)
          ..add('houseMade', houseMade))
        .toString();
  }
}

class UpdateIngredientRequestBuilder
    implements
        Builder<UpdateIngredientRequest, UpdateIngredientRequestBuilder> {
  _$UpdateIngredientRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

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

  UpdateIngredientRequestBuilder() {
    UpdateIngredientRequest._defaults(this);
  }

  UpdateIngredientRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
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
  void replace(UpdateIngredientRequest other) {
    _$v = other as _$UpdateIngredientRequest;
  }

  @override
  void update(void Function(UpdateIngredientRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateIngredientRequest build() => _build();

  _$UpdateIngredientRequest _build() {
    _$UpdateIngredientRequest _$result;
    try {
      _$result = _$v ??
          _$UpdateIngredientRequest._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'UpdateIngredientRequest', 'name'),
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
            r'UpdateIngredientRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
