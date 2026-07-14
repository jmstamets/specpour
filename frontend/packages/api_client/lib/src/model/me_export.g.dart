// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_export.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MeExportUnitPreferenceEnum _$meExportUnitPreferenceEnum_milliliters =
    const MeExportUnitPreferenceEnum._('milliliters');
const MeExportUnitPreferenceEnum _$meExportUnitPreferenceEnum_ounces =
    const MeExportUnitPreferenceEnum._('ounces');
const MeExportUnitPreferenceEnum _$meExportUnitPreferenceEnum_centiliters =
    const MeExportUnitPreferenceEnum._('centiliters');

MeExportUnitPreferenceEnum _$meExportUnitPreferenceEnumValueOf(String name) {
  switch (name) {
    case 'milliliters':
      return _$meExportUnitPreferenceEnum_milliliters;
    case 'ounces':
      return _$meExportUnitPreferenceEnum_ounces;
    case 'centiliters':
      return _$meExportUnitPreferenceEnum_centiliters;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MeExportUnitPreferenceEnum> _$meExportUnitPreferenceEnumValues =
    BuiltSet<MeExportUnitPreferenceEnum>(const <MeExportUnitPreferenceEnum>[
  _$meExportUnitPreferenceEnum_milliliters,
  _$meExportUnitPreferenceEnum_ounces,
  _$meExportUnitPreferenceEnum_centiliters,
]);

Serializer<MeExportUnitPreferenceEnum> _$meExportUnitPreferenceEnumSerializer =
    _$MeExportUnitPreferenceEnumSerializer();

class _$MeExportUnitPreferenceEnumSerializer
    implements PrimitiveSerializer<MeExportUnitPreferenceEnum> {
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
  final Iterable<Type> types = const <Type>[MeExportUnitPreferenceEnum];
  @override
  final String wireName = 'MeExportUnitPreferenceEnum';

  @override
  Object serialize(Serializers serializers, MeExportUnitPreferenceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MeExportUnitPreferenceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MeExportUnitPreferenceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MeExport extends MeExport {
  @override
  final String userId;
  @override
  final String email;
  @override
  final String displayName;
  @override
  final Date dateOfBirth;
  @override
  final MeExportUnitPreferenceEnum unitPreference;
  @override
  final String locale;
  @override
  final DateTime createdAt;
  @override
  final bool mfaEnabled;
  @override
  final BuiltList<Session> sessions;
  @override
  final BuiltList<String> externalLoginProviders;

  factory _$MeExport([void Function(MeExportBuilder)? updates]) =>
      (MeExportBuilder()..update(updates))._build();

  _$MeExport._(
      {required this.userId,
      required this.email,
      required this.displayName,
      required this.dateOfBirth,
      required this.unitPreference,
      required this.locale,
      required this.createdAt,
      required this.mfaEnabled,
      required this.sessions,
      required this.externalLoginProviders})
      : super._();
  @override
  MeExport rebuild(void Function(MeExportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeExportBuilder toBuilder() => MeExportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MeExport &&
        userId == other.userId &&
        email == other.email &&
        displayName == other.displayName &&
        dateOfBirth == other.dateOfBirth &&
        unitPreference == other.unitPreference &&
        locale == other.locale &&
        createdAt == other.createdAt &&
        mfaEnabled == other.mfaEnabled &&
        sessions == other.sessions &&
        externalLoginProviders == other.externalLoginProviders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, dateOfBirth.hashCode);
    _$hash = $jc(_$hash, unitPreference.hashCode);
    _$hash = $jc(_$hash, locale.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, mfaEnabled.hashCode);
    _$hash = $jc(_$hash, sessions.hashCode);
    _$hash = $jc(_$hash, externalLoginProviders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MeExport')
          ..add('userId', userId)
          ..add('email', email)
          ..add('displayName', displayName)
          ..add('dateOfBirth', dateOfBirth)
          ..add('unitPreference', unitPreference)
          ..add('locale', locale)
          ..add('createdAt', createdAt)
          ..add('mfaEnabled', mfaEnabled)
          ..add('sessions', sessions)
          ..add('externalLoginProviders', externalLoginProviders))
        .toString();
  }
}

class MeExportBuilder implements Builder<MeExport, MeExportBuilder> {
  _$MeExport? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  Date? _dateOfBirth;
  Date? get dateOfBirth => _$this._dateOfBirth;
  set dateOfBirth(Date? dateOfBirth) => _$this._dateOfBirth = dateOfBirth;

  MeExportUnitPreferenceEnum? _unitPreference;
  MeExportUnitPreferenceEnum? get unitPreference => _$this._unitPreference;
  set unitPreference(MeExportUnitPreferenceEnum? unitPreference) =>
      _$this._unitPreference = unitPreference;

  String? _locale;
  String? get locale => _$this._locale;
  set locale(String? locale) => _$this._locale = locale;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  bool? _mfaEnabled;
  bool? get mfaEnabled => _$this._mfaEnabled;
  set mfaEnabled(bool? mfaEnabled) => _$this._mfaEnabled = mfaEnabled;

  ListBuilder<Session>? _sessions;
  ListBuilder<Session> get sessions =>
      _$this._sessions ??= ListBuilder<Session>();
  set sessions(ListBuilder<Session>? sessions) => _$this._sessions = sessions;

  ListBuilder<String>? _externalLoginProviders;
  ListBuilder<String> get externalLoginProviders =>
      _$this._externalLoginProviders ??= ListBuilder<String>();
  set externalLoginProviders(ListBuilder<String>? externalLoginProviders) =>
      _$this._externalLoginProviders = externalLoginProviders;

  MeExportBuilder() {
    MeExport._defaults(this);
  }

  MeExportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _email = $v.email;
      _displayName = $v.displayName;
      _dateOfBirth = $v.dateOfBirth;
      _unitPreference = $v.unitPreference;
      _locale = $v.locale;
      _createdAt = $v.createdAt;
      _mfaEnabled = $v.mfaEnabled;
      _sessions = $v.sessions.toBuilder();
      _externalLoginProviders = $v.externalLoginProviders.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MeExport other) {
    _$v = other as _$MeExport;
  }

  @override
  void update(void Function(MeExportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MeExport build() => _build();

  _$MeExport _build() {
    _$MeExport _$result;
    try {
      _$result = _$v ??
          _$MeExport._(
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'MeExport', 'userId'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'MeExport', 'email'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'MeExport', 'displayName'),
            dateOfBirth: BuiltValueNullFieldError.checkNotNull(
                dateOfBirth, r'MeExport', 'dateOfBirth'),
            unitPreference: BuiltValueNullFieldError.checkNotNull(
                unitPreference, r'MeExport', 'unitPreference'),
            locale: BuiltValueNullFieldError.checkNotNull(
                locale, r'MeExport', 'locale'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'MeExport', 'createdAt'),
            mfaEnabled: BuiltValueNullFieldError.checkNotNull(
                mfaEnabled, r'MeExport', 'mfaEnabled'),
            sessions: sessions.build(),
            externalLoginProviders: externalLoginProviders.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sessions';
        sessions.build();
        _$failedField = 'externalLoginProviders';
        externalLoginProviders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MeExport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
