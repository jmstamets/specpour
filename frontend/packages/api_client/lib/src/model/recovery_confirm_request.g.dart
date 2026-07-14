// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_confirm_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecoveryConfirmRequest extends RecoveryConfirmRequest {
  @override
  final String email;
  @override
  final String token;
  @override
  final String newPassword;

  factory _$RecoveryConfirmRequest(
          [void Function(RecoveryConfirmRequestBuilder)? updates]) =>
      (RecoveryConfirmRequestBuilder()..update(updates))._build();

  _$RecoveryConfirmRequest._(
      {required this.email, required this.token, required this.newPassword})
      : super._();
  @override
  RecoveryConfirmRequest rebuild(
          void Function(RecoveryConfirmRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecoveryConfirmRequestBuilder toBuilder() =>
      RecoveryConfirmRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecoveryConfirmRequest &&
        email == other.email &&
        token == other.token &&
        newPassword == other.newPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, newPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecoveryConfirmRequest')
          ..add('email', email)
          ..add('token', token)
          ..add('newPassword', newPassword))
        .toString();
  }
}

class RecoveryConfirmRequestBuilder
    implements Builder<RecoveryConfirmRequest, RecoveryConfirmRequestBuilder> {
  _$RecoveryConfirmRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _newPassword;
  String? get newPassword => _$this._newPassword;
  set newPassword(String? newPassword) => _$this._newPassword = newPassword;

  RecoveryConfirmRequestBuilder() {
    RecoveryConfirmRequest._defaults(this);
  }

  RecoveryConfirmRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _token = $v.token;
      _newPassword = $v.newPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecoveryConfirmRequest other) {
    _$v = other as _$RecoveryConfirmRequest;
  }

  @override
  void update(void Function(RecoveryConfirmRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecoveryConfirmRequest build() => _build();

  _$RecoveryConfirmRequest _build() {
    final _$result = _$v ??
        _$RecoveryConfirmRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'RecoveryConfirmRequest', 'email'),
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'RecoveryConfirmRequest', 'token'),
          newPassword: BuiltValueNullFieldError.checkNotNull(
              newPassword, r'RecoveryConfirmRequest', 'newPassword'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
