// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Venue extends Venue {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? address;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final BuiltList<String> externalReferences;
  @override
  final DateTime createdAt;

  factory _$Venue([void Function(VenueBuilder)? updates]) =>
      (VenueBuilder()..update(updates))._build();

  _$Venue._(
      {required this.id,
      required this.name,
      this.address,
      this.latitude,
      this.longitude,
      required this.externalReferences,
      required this.createdAt})
      : super._();
  @override
  Venue rebuild(void Function(VenueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VenueBuilder toBuilder() => VenueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Venue &&
        id == other.id &&
        name == other.name &&
        address == other.address &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        externalReferences == other.externalReferences &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, externalReferences.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Venue')
          ..add('id', id)
          ..add('name', name)
          ..add('address', address)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('externalReferences', externalReferences)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class VenueBuilder implements Builder<Venue, VenueBuilder> {
  _$Venue? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  VenueBuilder() {
    Venue._defaults(this);
  }

  VenueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _address = $v.address;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _externalReferences = $v.externalReferences.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Venue other) {
    _$v = other as _$Venue;
  }

  @override
  void update(void Function(VenueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Venue build() => _build();

  _$Venue _build() {
    _$Venue _$result;
    try {
      _$result = _$v ??
          _$Venue._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Venue', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(name, r'Venue', 'name'),
            address: address,
            latitude: latitude,
            longitude: longitude,
            externalReferences: externalReferences.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'Venue', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'externalReferences';
        externalReferences.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Venue', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
