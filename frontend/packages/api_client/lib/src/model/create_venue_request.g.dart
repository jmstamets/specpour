// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_venue_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateVenueRequest extends CreateVenueRequest {
  @override
  final String name;
  @override
  final String? address;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final BuiltList<String>? externalReferences;

  factory _$CreateVenueRequest(
          [void Function(CreateVenueRequestBuilder)? updates]) =>
      (CreateVenueRequestBuilder()..update(updates))._build();

  _$CreateVenueRequest._(
      {required this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.externalReferences})
      : super._();
  @override
  CreateVenueRequest rebuild(
          void Function(CreateVenueRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateVenueRequestBuilder toBuilder() =>
      CreateVenueRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateVenueRequest &&
        name == other.name &&
        address == other.address &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        externalReferences == other.externalReferences;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, externalReferences.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateVenueRequest')
          ..add('name', name)
          ..add('address', address)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('externalReferences', externalReferences))
        .toString();
  }
}

class CreateVenueRequestBuilder
    implements Builder<CreateVenueRequest, CreateVenueRequestBuilder> {
  _$CreateVenueRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  ListBuilder<String>? _externalReferences;
  ListBuilder<String> get externalReferences =>
      _$this._externalReferences ??= ListBuilder<String>();
  set externalReferences(ListBuilder<String>? externalReferences) =>
      _$this._externalReferences = externalReferences;

  CreateVenueRequestBuilder() {
    CreateVenueRequest._defaults(this);
  }

  CreateVenueRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _address = $v.address;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _externalReferences = $v.externalReferences?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateVenueRequest other) {
    _$v = other as _$CreateVenueRequest;
  }

  @override
  void update(void Function(CreateVenueRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateVenueRequest build() => _build();

  _$CreateVenueRequest _build() {
    _$CreateVenueRequest _$result;
    try {
      _$result = _$v ??
          _$CreateVenueRequest._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CreateVenueRequest', 'name'),
            address: address,
            latitude: latitude,
            longitude: longitude,
            externalReferences: _externalReferences?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'externalReferences';
        _externalReferences?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreateVenueRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
