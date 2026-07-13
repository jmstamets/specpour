// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RegisterRequestUnitPreferenceEnum
    _$registerRequestUnitPreferenceEnum_milliliters =
    const RegisterRequestUnitPreferenceEnum._('milliliters');
const RegisterRequestUnitPreferenceEnum
    _$registerRequestUnitPreferenceEnum_ounces =
    const RegisterRequestUnitPreferenceEnum._('ounces');
const RegisterRequestUnitPreferenceEnum
    _$registerRequestUnitPreferenceEnum_centiliters =
    const RegisterRequestUnitPreferenceEnum._('centiliters');

RegisterRequestUnitPreferenceEnum _$registerRequestUnitPreferenceEnumValueOf(
    String name) {
  switch (name) {
    case 'milliliters':
      return _$registerRequestUnitPreferenceEnum_milliliters;
    case 'ounces':
      return _$registerRequestUnitPreferenceEnum_ounces;
    case 'centiliters':
      return _$registerRequestUnitPreferenceEnum_centiliters;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RegisterRequestUnitPreferenceEnum>
    _$registerRequestUnitPreferenceEnumValues = BuiltSet<
        RegisterRequestUnitPreferenceEnum>(const <RegisterRequestUnitPreferenceEnum>[
  _$registerRequestUnitPreferenceEnum_milliliters,
  _$registerRequestUnitPreferenceEnum_ounces,
  _$registerRequestUnitPreferenceEnum_centiliters,
]);

Serializer<RegisterRequestUnitPreferenceEnum>
    _$registerRequestUnitPreferenceEnumSerializer =
    _$RegisterRequestUnitPreferenceEnumSerializer();

class _$RegisterRequestUnitPreferenceEnumSerializer
    implements PrimitiveSerializer<RegisterRequestUnitPreferenceEnum> {
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
  final Iterable<Type> types = const <Type>[RegisterRequestUnitPreferenceEnum];
  @override
  final String wireName = 'RegisterRequestUnitPreferenceEnum';

  @override
  Object serialize(
          Serializers serializers, RegisterRequestUnitPreferenceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegisterRequestUnitPreferenceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegisterRequestUnitPreferenceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegisterRequest extends RegisterRequest {
  @override
  final String email;
  @override
  final String password;
  @override
  final String displayName;
  @override
  final Date dateOfBirth;
  @override
  final RegisterRequestUnitPreferenceEnum? unitPreference;
  @override
  final String? locale;

  factory _$RegisterRequest([void Function(RegisterRequestBuilder)? updates]) =>
      (RegisterRequestBuilder()..update(updates))._build();

  _$RegisterRequest._(
      {required this.email,
      required this.password,
      required this.displayName,
      required this.dateOfBirth,
      this.unitPreference,
      this.locale})
      : super._();
  @override
  RegisterRequest rebuild(void Function(RegisterRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterRequestBuilder toBuilder() => RegisterRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterRequest &&
        email == other.email &&
        password == other.password &&
        displayName == other.displayName &&
        dateOfBirth == other.dateOfBirth &&
        unitPreference == other.unitPreference &&
        locale == other.locale;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, dateOfBirth.hashCode);
    _$hash = $jc(_$hash, unitPreference.hashCode);
    _$hash = $jc(_$hash, locale.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterRequest')
          ..add('email', email)
          ..add('password', password)
          ..add('displayName', displayName)
          ..add('dateOfBirth', dateOfBirth)
          ..add('unitPreference', unitPreference)
          ..add('locale', locale))
        .toString();
  }
}

class RegisterRequestBuilder
    implements Builder<RegisterRequest, RegisterRequestBuilder> {
  _$RegisterRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  Date? _dateOfBirth;
  Date? get dateOfBirth => _$this._dateOfBirth;
  set dateOfBirth(Date? dateOfBirth) => _$this._dateOfBirth = dateOfBirth;

  RegisterRequestUnitPreferenceEnum? _unitPreference;
  RegisterRequestUnitPreferenceEnum? get unitPreference =>
      _$this._unitPreference;
  set unitPreference(RegisterRequestUnitPreferenceEnum? unitPreference) =>
      _$this._unitPreference = unitPreference;

  String? _locale;
  String? get locale => _$this._locale;
  set locale(String? locale) => _$this._locale = locale;

  RegisterRequestBuilder() {
    RegisterRequest._defaults(this);
  }

  RegisterRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _password = $v.password;
      _displayName = $v.displayName;
      _dateOfBirth = $v.dateOfBirth;
      _unitPreference = $v.unitPreference;
      _locale = $v.locale;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterRequest other) {
    _$v = other as _$RegisterRequest;
  }

  @override
  void update(void Function(RegisterRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterRequest build() => _build();

  _$RegisterRequest _build() {
    final _$result = _$v ??
        _$RegisterRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'RegisterRequest', 'email'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'RegisterRequest', 'password'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'RegisterRequest', 'displayName'),
          dateOfBirth: BuiltValueNullFieldError.checkNotNull(
              dateOfBirth, r'RegisterRequest', 'dateOfBirth'),
          unitPreference: unitPreference,
          locale: locale,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
