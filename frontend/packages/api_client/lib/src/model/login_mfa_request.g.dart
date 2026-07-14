// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_mfa_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginMfaRequest extends LoginMfaRequest {
  @override
  final String code;

  factory _$LoginMfaRequest([void Function(LoginMfaRequestBuilder)? updates]) =>
      (LoginMfaRequestBuilder()..update(updates))._build();

  _$LoginMfaRequest._({required this.code}) : super._();
  @override
  LoginMfaRequest rebuild(void Function(LoginMfaRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginMfaRequestBuilder toBuilder() => LoginMfaRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginMfaRequest && code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginMfaRequest')..add('code', code))
        .toString();
  }
}

class LoginMfaRequestBuilder
    implements Builder<LoginMfaRequest, LoginMfaRequestBuilder> {
  _$LoginMfaRequest? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  LoginMfaRequestBuilder() {
    LoginMfaRequest._defaults(this);
  }

  LoginMfaRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginMfaRequest other) {
    _$v = other as _$LoginMfaRequest;
  }

  @override
  void update(void Function(LoginMfaRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginMfaRequest build() => _build();

  _$LoginMfaRequest _build() {
    final _$result = _$v ??
        _$LoginMfaRequest._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'LoginMfaRequest', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
