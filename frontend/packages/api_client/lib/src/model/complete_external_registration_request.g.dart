// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_external_registration_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CompleteExternalRegistrationRequestUnitPreferenceEnum
    _$completeExternalRegistrationRequestUnitPreferenceEnum_milliliters =
    const CompleteExternalRegistrationRequestUnitPreferenceEnum._(
        'milliliters');
const CompleteExternalRegistrationRequestUnitPreferenceEnum
    _$completeExternalRegistrationRequestUnitPreferenceEnum_ounces =
    const CompleteExternalRegistrationRequestUnitPreferenceEnum._('ounces');
const CompleteExternalRegistrationRequestUnitPreferenceEnum
    _$completeExternalRegistrationRequestUnitPreferenceEnum_centiliters =
    const CompleteExternalRegistrationRequestUnitPreferenceEnum._(
        'centiliters');

CompleteExternalRegistrationRequestUnitPreferenceEnum
    _$completeExternalRegistrationRequestUnitPreferenceEnumValueOf(
        String name) {
  switch (name) {
    case 'milliliters':
      return _$completeExternalRegistrationRequestUnitPreferenceEnum_milliliters;
    case 'ounces':
      return _$completeExternalRegistrationRequestUnitPreferenceEnum_ounces;
    case 'centiliters':
      return _$completeExternalRegistrationRequestUnitPreferenceEnum_centiliters;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CompleteExternalRegistrationRequestUnitPreferenceEnum>
    _$completeExternalRegistrationRequestUnitPreferenceEnumValues = BuiltSet<
        CompleteExternalRegistrationRequestUnitPreferenceEnum>(const <CompleteExternalRegistrationRequestUnitPreferenceEnum>[
  _$completeExternalRegistrationRequestUnitPreferenceEnum_milliliters,
  _$completeExternalRegistrationRequestUnitPreferenceEnum_ounces,
  _$completeExternalRegistrationRequestUnitPreferenceEnum_centiliters,
]);

Serializer<CompleteExternalRegistrationRequestUnitPreferenceEnum>
    _$completeExternalRegistrationRequestUnitPreferenceEnumSerializer =
    _$CompleteExternalRegistrationRequestUnitPreferenceEnumSerializer();

class _$CompleteExternalRegistrationRequestUnitPreferenceEnumSerializer
    implements
        PrimitiveSerializer<
            CompleteExternalRegistrationRequestUnitPreferenceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'milliliters': 'Milliliters',
    'ounces': 'Ounces',
    'centiliters': 'Centiliters',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Milliliters': 'milliliters',
    'Ounces': 'ounces',
    'Centiliters': 'centiliters',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CompleteExternalRegistrationRequestUnitPreferenceEnum
  ];
  @override
  final String wireName =
      'CompleteExternalRegistrationRequestUnitPreferenceEnum';

  @override
  Object serialize(Serializers serializers,
          CompleteExternalRegistrationRequestUnitPreferenceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CompleteExternalRegistrationRequestUnitPreferenceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CompleteExternalRegistrationRequestUnitPreferenceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CompleteExternalRegistrationRequest
    extends CompleteExternalRegistrationRequest {
  @override
  final Date dateOfBirth;
  @override
  final String displayName;
  @override
  final CompleteExternalRegistrationRequestUnitPreferenceEnum? unitPreference;
  @override
  final String? locale;

  factory _$CompleteExternalRegistrationRequest(
          [void Function(CompleteExternalRegistrationRequestBuilder)?
              updates]) =>
      (CompleteExternalRegistrationRequestBuilder()..update(updates))._build();

  _$CompleteExternalRegistrationRequest._(
      {required this.dateOfBirth,
      required this.displayName,
      this.unitPreference,
      this.locale})
      : super._();
  @override
  CompleteExternalRegistrationRequest rebuild(
          void Function(CompleteExternalRegistrationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompleteExternalRegistrationRequestBuilder toBuilder() =>
      CompleteExternalRegistrationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompleteExternalRegistrationRequest &&
        dateOfBirth == other.dateOfBirth &&
        displayName == other.displayName &&
        unitPreference == other.unitPreference &&
        locale == other.locale;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dateOfBirth.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, unitPreference.hashCode);
    _$hash = $jc(_$hash, locale.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompleteExternalRegistrationRequest')
          ..add('dateOfBirth', dateOfBirth)
          ..add('displayName', displayName)
          ..add('unitPreference', unitPreference)
          ..add('locale', locale))
        .toString();
  }
}

class CompleteExternalRegistrationRequestBuilder
    implements
        Builder<CompleteExternalRegistrationRequest,
            CompleteExternalRegistrationRequestBuilder> {
  _$CompleteExternalRegistrationRequest? _$v;

  Date? _dateOfBirth;
  Date? get dateOfBirth => _$this._dateOfBirth;
  set dateOfBirth(Date? dateOfBirth) => _$this._dateOfBirth = dateOfBirth;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  CompleteExternalRegistrationRequestUnitPreferenceEnum? _unitPreference;
  CompleteExternalRegistrationRequestUnitPreferenceEnum? get unitPreference =>
      _$this._unitPreference;
  set unitPreference(
          CompleteExternalRegistrationRequestUnitPreferenceEnum?
              unitPreference) =>
      _$this._unitPreference = unitPreference;

  String? _locale;
  String? get locale => _$this._locale;
  set locale(String? locale) => _$this._locale = locale;

  CompleteExternalRegistrationRequestBuilder() {
    CompleteExternalRegistrationRequest._defaults(this);
  }

  CompleteExternalRegistrationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dateOfBirth = $v.dateOfBirth;
      _displayName = $v.displayName;
      _unitPreference = $v.unitPreference;
      _locale = $v.locale;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompleteExternalRegistrationRequest other) {
    _$v = other as _$CompleteExternalRegistrationRequest;
  }

  @override
  void update(
      void Function(CompleteExternalRegistrationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompleteExternalRegistrationRequest build() => _build();

  _$CompleteExternalRegistrationRequest _build() {
    final _$result = _$v ??
        _$CompleteExternalRegistrationRequest._(
          dateOfBirth: BuiltValueNullFieldError.checkNotNull(dateOfBirth,
              r'CompleteExternalRegistrationRequest', 'dateOfBirth'),
          displayName: BuiltValueNullFieldError.checkNotNull(displayName,
              r'CompleteExternalRegistrationRequest', 'displayName'),
          unitPreference: unitPreference,
          locale: locale,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
