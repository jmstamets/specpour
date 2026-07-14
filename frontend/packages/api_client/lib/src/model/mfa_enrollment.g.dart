// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_enrollment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaEnrollment extends MfaEnrollment {
  @override
  final bool enabled;
  @override
  final String? secret;
  @override
  final String? otpAuthUri;
  @override
  final BuiltList<String>? backupCodes;

  factory _$MfaEnrollment([void Function(MfaEnrollmentBuilder)? updates]) =>
      (MfaEnrollmentBuilder()..update(updates))._build();

  _$MfaEnrollment._(
      {required this.enabled, this.secret, this.otpAuthUri, this.backupCodes})
      : super._();
  @override
  MfaEnrollment rebuild(void Function(MfaEnrollmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaEnrollmentBuilder toBuilder() => MfaEnrollmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaEnrollment &&
        enabled == other.enabled &&
        secret == other.secret &&
        otpAuthUri == other.otpAuthUri &&
        backupCodes == other.backupCodes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, secret.hashCode);
    _$hash = $jc(_$hash, otpAuthUri.hashCode);
    _$hash = $jc(_$hash, backupCodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaEnrollment')
          ..add('enabled', enabled)
          ..add('secret', secret)
          ..add('otpAuthUri', otpAuthUri)
          ..add('backupCodes', backupCodes))
        .toString();
  }
}

class MfaEnrollmentBuilder
    implements Builder<MfaEnrollment, MfaEnrollmentBuilder> {
  _$MfaEnrollment? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  String? _secret;
  String? get secret => _$this._secret;
  set secret(String? secret) => _$this._secret = secret;

  String? _otpAuthUri;
  String? get otpAuthUri => _$this._otpAuthUri;
  set otpAuthUri(String? otpAuthUri) => _$this._otpAuthUri = otpAuthUri;

  ListBuilder<String>? _backupCodes;
  ListBuilder<String> get backupCodes =>
      _$this._backupCodes ??= ListBuilder<String>();
  set backupCodes(ListBuilder<String>? backupCodes) =>
      _$this._backupCodes = backupCodes;

  MfaEnrollmentBuilder() {
    MfaEnrollment._defaults(this);
  }

  MfaEnrollmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _secret = $v.secret;
      _otpAuthUri = $v.otpAuthUri;
      _backupCodes = $v.backupCodes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaEnrollment other) {
    _$v = other as _$MfaEnrollment;
  }

  @override
  void update(void Function(MfaEnrollmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaEnrollment build() => _build();

  _$MfaEnrollment _build() {
    _$MfaEnrollment _$result;
    try {
      _$result = _$v ??
          _$MfaEnrollment._(
            enabled: BuiltValueNullFieldError.checkNotNull(
                enabled, r'MfaEnrollment', 'enabled'),
            secret: secret,
            otpAuthUri: otpAuthUri,
            backupCodes: _backupCodes?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'backupCodes';
        _backupCodes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MfaEnrollment', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
