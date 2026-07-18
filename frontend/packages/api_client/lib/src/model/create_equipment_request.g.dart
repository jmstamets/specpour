// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_equipment_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateEquipmentRequestLibraryScopeEnum
    _$createEquipmentRequestLibraryScopeEnum_personal =
    const CreateEquipmentRequestLibraryScopeEnum._('personal');
const CreateEquipmentRequestLibraryScopeEnum
    _$createEquipmentRequestLibraryScopeEnum_bar =
    const CreateEquipmentRequestLibraryScopeEnum._('bar');

CreateEquipmentRequestLibraryScopeEnum
    _$createEquipmentRequestLibraryScopeEnumValueOf(String name) {
  switch (name) {
    case 'personal':
      return _$createEquipmentRequestLibraryScopeEnum_personal;
    case 'bar':
      return _$createEquipmentRequestLibraryScopeEnum_bar;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateEquipmentRequestLibraryScopeEnum>
    _$createEquipmentRequestLibraryScopeEnumValues = BuiltSet<
        CreateEquipmentRequestLibraryScopeEnum>(const <CreateEquipmentRequestLibraryScopeEnum>[
  _$createEquipmentRequestLibraryScopeEnum_personal,
  _$createEquipmentRequestLibraryScopeEnum_bar,
]);

Serializer<CreateEquipmentRequestLibraryScopeEnum>
    _$createEquipmentRequestLibraryScopeEnumSerializer =
    _$CreateEquipmentRequestLibraryScopeEnumSerializer();

class _$CreateEquipmentRequestLibraryScopeEnumSerializer
    implements PrimitiveSerializer<CreateEquipmentRequestLibraryScopeEnum> {
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
    CreateEquipmentRequestLibraryScopeEnum
  ];
  @override
  final String wireName = 'CreateEquipmentRequestLibraryScopeEnum';

  @override
  Object serialize(Serializers serializers,
          CreateEquipmentRequestLibraryScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateEquipmentRequestLibraryScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateEquipmentRequestLibraryScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateEquipmentRequest extends CreateEquipmentRequest {
  @override
  final String name;
  @override
  final String category;
  @override
  final CreateEquipmentRequestLibraryScopeEnum libraryScope;
  @override
  final String? venueId;
  @override
  final num? cost;
  @override
  final String? description;
  @override
  final String? usageGuidance;
  @override
  final BuiltList<String>? typicalApplications;

  factory _$CreateEquipmentRequest(
          [void Function(CreateEquipmentRequestBuilder)? updates]) =>
      (CreateEquipmentRequestBuilder()..update(updates))._build();

  _$CreateEquipmentRequest._(
      {required this.name,
      required this.category,
      required this.libraryScope,
      this.venueId,
      this.cost,
      this.description,
      this.usageGuidance,
      this.typicalApplications})
      : super._();
  @override
  CreateEquipmentRequest rebuild(
          void Function(CreateEquipmentRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateEquipmentRequestBuilder toBuilder() =>
      CreateEquipmentRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateEquipmentRequest &&
        name == other.name &&
        category == other.category &&
        libraryScope == other.libraryScope &&
        venueId == other.venueId &&
        cost == other.cost &&
        description == other.description &&
        usageGuidance == other.usageGuidance &&
        typicalApplications == other.typicalApplications;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, libraryScope.hashCode);
    _$hash = $jc(_$hash, venueId.hashCode);
    _$hash = $jc(_$hash, cost.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, usageGuidance.hashCode);
    _$hash = $jc(_$hash, typicalApplications.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateEquipmentRequest')
          ..add('name', name)
          ..add('category', category)
          ..add('libraryScope', libraryScope)
          ..add('venueId', venueId)
          ..add('cost', cost)
          ..add('description', description)
          ..add('usageGuidance', usageGuidance)
          ..add('typicalApplications', typicalApplications))
        .toString();
  }
}

class CreateEquipmentRequestBuilder
    implements Builder<CreateEquipmentRequest, CreateEquipmentRequestBuilder> {
  _$CreateEquipmentRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  CreateEquipmentRequestLibraryScopeEnum? _libraryScope;
  CreateEquipmentRequestLibraryScopeEnum? get libraryScope =>
      _$this._libraryScope;
  set libraryScope(CreateEquipmentRequestLibraryScopeEnum? libraryScope) =>
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

  CreateEquipmentRequestBuilder() {
    CreateEquipmentRequest._defaults(this);
  }

  CreateEquipmentRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _category = $v.category;
      _libraryScope = $v.libraryScope;
      _venueId = $v.venueId;
      _cost = $v.cost;
      _description = $v.description;
      _usageGuidance = $v.usageGuidance;
      _typicalApplications = $v.typicalApplications?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateEquipmentRequest other) {
    _$v = other as _$CreateEquipmentRequest;
  }

  @override
  void update(void Function(CreateEquipmentRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateEquipmentRequest build() => _build();

  _$CreateEquipmentRequest _build() {
    _$CreateEquipmentRequest _$result;
    try {
      _$result = _$v ??
          _$CreateEquipmentRequest._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CreateEquipmentRequest', 'name'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'CreateEquipmentRequest', 'category'),
            libraryScope: BuiltValueNullFieldError.checkNotNull(
                libraryScope, r'CreateEquipmentRequest', 'libraryScope'),
            venueId: venueId,
            cost: cost,
            description: description,
            usageGuidance: usageGuidance,
            typicalApplications: _typicalApplications?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'typicalApplications';
        _typicalApplications?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreateEquipmentRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
