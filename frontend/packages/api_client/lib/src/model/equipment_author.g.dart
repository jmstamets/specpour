// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_author.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EquipmentAuthorLibraryScopeEnum
    _$equipmentAuthorLibraryScopeEnum_personal =
    const EquipmentAuthorLibraryScopeEnum._('personal');
const EquipmentAuthorLibraryScopeEnum _$equipmentAuthorLibraryScopeEnum_bar =
    const EquipmentAuthorLibraryScopeEnum._('bar');

EquipmentAuthorLibraryScopeEnum _$equipmentAuthorLibraryScopeEnumValueOf(
    String name) {
  switch (name) {
    case 'personal':
      return _$equipmentAuthorLibraryScopeEnum_personal;
    case 'bar':
      return _$equipmentAuthorLibraryScopeEnum_bar;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EquipmentAuthorLibraryScopeEnum>
    _$equipmentAuthorLibraryScopeEnumValues = BuiltSet<
        EquipmentAuthorLibraryScopeEnum>(const <EquipmentAuthorLibraryScopeEnum>[
  _$equipmentAuthorLibraryScopeEnum_personal,
  _$equipmentAuthorLibraryScopeEnum_bar,
]);

const EquipmentAuthorVisibilityEnum _$equipmentAuthorVisibilityEnum_private =
    const EquipmentAuthorVisibilityEnum._('private');
const EquipmentAuthorVisibilityEnum _$equipmentAuthorVisibilityEnum_public =
    const EquipmentAuthorVisibilityEnum._('public');

EquipmentAuthorVisibilityEnum _$equipmentAuthorVisibilityEnumValueOf(
    String name) {
  switch (name) {
    case 'private':
      return _$equipmentAuthorVisibilityEnum_private;
    case 'public':
      return _$equipmentAuthorVisibilityEnum_public;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EquipmentAuthorVisibilityEnum>
    _$equipmentAuthorVisibilityEnumValues = BuiltSet<
        EquipmentAuthorVisibilityEnum>(const <EquipmentAuthorVisibilityEnum>[
  _$equipmentAuthorVisibilityEnum_private,
  _$equipmentAuthorVisibilityEnum_public,
]);

Serializer<EquipmentAuthorLibraryScopeEnum>
    _$equipmentAuthorLibraryScopeEnumSerializer =
    _$EquipmentAuthorLibraryScopeEnumSerializer();
Serializer<EquipmentAuthorVisibilityEnum>
    _$equipmentAuthorVisibilityEnumSerializer =
    _$EquipmentAuthorVisibilityEnumSerializer();

class _$EquipmentAuthorLibraryScopeEnumSerializer
    implements PrimitiveSerializer<EquipmentAuthorLibraryScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'personal': 'personal',
    'bar': 'bar',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'personal': 'personal',
    'bar': 'bar',
  };

  @override
  final Iterable<Type> types = const <Type>[EquipmentAuthorLibraryScopeEnum];
  @override
  final String wireName = 'EquipmentAuthorLibraryScopeEnum';

  @override
  Object serialize(
          Serializers serializers, EquipmentAuthorLibraryScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EquipmentAuthorLibraryScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EquipmentAuthorLibraryScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EquipmentAuthorVisibilityEnumSerializer
    implements PrimitiveSerializer<EquipmentAuthorVisibilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'private': 'private',
    'public': 'public',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'private': 'private',
    'public': 'public',
  };

  @override
  final Iterable<Type> types = const <Type>[EquipmentAuthorVisibilityEnum];
  @override
  final String wireName = 'EquipmentAuthorVisibilityEnum';

  @override
  Object serialize(
          Serializers serializers, EquipmentAuthorVisibilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EquipmentAuthorVisibilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EquipmentAuthorVisibilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EquipmentAuthor extends EquipmentAuthor {
  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final EquipmentAuthorLibraryScopeEnum libraryScope;
  @override
  final String? venueId;
  @override
  final num? cost;
  @override
  final String? description;
  @override
  final String? usageGuidance;
  @override
  final BuiltList<String> typicalApplications;
  @override
  final EquipmentAuthorVisibilityEnum visibility;

  factory _$EquipmentAuthor([void Function(EquipmentAuthorBuilder)? updates]) =>
      (EquipmentAuthorBuilder()..update(updates))._build();

  _$EquipmentAuthor._(
      {required this.id,
      required this.name,
      required this.category,
      required this.libraryScope,
      this.venueId,
      this.cost,
      this.description,
      this.usageGuidance,
      required this.typicalApplications,
      required this.visibility})
      : super._();
  @override
  EquipmentAuthor rebuild(void Function(EquipmentAuthorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EquipmentAuthorBuilder toBuilder() => EquipmentAuthorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EquipmentAuthor &&
        id == other.id &&
        name == other.name &&
        category == other.category &&
        libraryScope == other.libraryScope &&
        venueId == other.venueId &&
        cost == other.cost &&
        description == other.description &&
        usageGuidance == other.usageGuidance &&
        typicalApplications == other.typicalApplications &&
        visibility == other.visibility;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, libraryScope.hashCode);
    _$hash = $jc(_$hash, venueId.hashCode);
    _$hash = $jc(_$hash, cost.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, usageGuidance.hashCode);
    _$hash = $jc(_$hash, typicalApplications.hashCode);
    _$hash = $jc(_$hash, visibility.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EquipmentAuthor')
          ..add('id', id)
          ..add('name', name)
          ..add('category', category)
          ..add('libraryScope', libraryScope)
          ..add('venueId', venueId)
          ..add('cost', cost)
          ..add('description', description)
          ..add('usageGuidance', usageGuidance)
          ..add('typicalApplications', typicalApplications)
          ..add('visibility', visibility))
        .toString();
  }
}

class EquipmentAuthorBuilder
    implements Builder<EquipmentAuthor, EquipmentAuthorBuilder> {
  _$EquipmentAuthor? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  EquipmentAuthorLibraryScopeEnum? _libraryScope;
  EquipmentAuthorLibraryScopeEnum? get libraryScope => _$this._libraryScope;
  set libraryScope(EquipmentAuthorLibraryScopeEnum? libraryScope) =>
      _$this._libraryScope = libraryScope;

  String? _venueId;
  String? get venueId => _$this._venueId;
  set venueId(String? venueId) => _$this._venueId = venueId;

  num? _cost;
  num? get cost => _$this._cost;
  set cost(num? cost) => _$this._cost = cost;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _usageGuidance;
  String? get usageGuidance => _$this._usageGuidance;
  set usageGuidance(String? usageGuidance) =>
      _$this._usageGuidance = usageGuidance;

  ListBuilder<String>? _typicalApplications;
  ListBuilder<String> get typicalApplications =>
      _$this._typicalApplications ??= ListBuilder<String>();
  set typicalApplications(ListBuilder<String>? typicalApplications) =>
      _$this._typicalApplications = typicalApplications;

  EquipmentAuthorVisibilityEnum? _visibility;
  EquipmentAuthorVisibilityEnum? get visibility => _$this._visibility;
  set visibility(EquipmentAuthorVisibilityEnum? visibility) =>
      _$this._visibility = visibility;

  EquipmentAuthorBuilder() {
    EquipmentAuthor._defaults(this);
  }

  EquipmentAuthorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _category = $v.category;
      _libraryScope = $v.libraryScope;
      _venueId = $v.venueId;
      _cost = $v.cost;
      _description = $v.description;
      _usageGuidance = $v.usageGuidance;
      _typicalApplications = $v.typicalApplications.toBuilder();
      _visibility = $v.visibility;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EquipmentAuthor other) {
    _$v = other as _$EquipmentAuthor;
  }

  @override
  void update(void Function(EquipmentAuthorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EquipmentAuthor build() => _build();

  _$EquipmentAuthor _build() {
    _$EquipmentAuthor _$result;
    try {
      _$result = _$v ??
          _$EquipmentAuthor._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'EquipmentAuthor', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'EquipmentAuthor', 'name'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'EquipmentAuthor', 'category'),
            libraryScope: BuiltValueNullFieldError.checkNotNull(
                libraryScope, r'EquipmentAuthor', 'libraryScope'),
            venueId: venueId,
            cost: cost,
            description: description,
            usageGuidance: usageGuidance,
            typicalApplications: typicalApplications.build(),
            visibility: BuiltValueNullFieldError.checkNotNull(
                visibility, r'EquipmentAuthor', 'visibility'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'typicalApplications';
        typicalApplications.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'EquipmentAuthor', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
