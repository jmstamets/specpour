// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginResult extends LoginResult {
  @override
  final bool requiresMfa;
  @override
  final String? userId;
  @override
  final String? email;
  @override
  final String? displayName;

  factory _$LoginResult([void Function(LoginResultBuilder)? updates]) =>
      (LoginResultBuilder()..update(updates))._build();

  _$LoginResult._(
      {required this.requiresMfa, this.userId, this.email, this.displayName})
      : super._();
  @override
  LoginResult rebuild(void Function(LoginResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginResultBuilder toBuilder() => LoginResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginResult &&
        requiresMfa == other.requiresMfa &&
        userId == other.userId &&
        email == other.email &&
        displayName == other.displayName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, requiresMfa.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginResult')
          ..add('requiresMfa', requiresMfa)
          ..add('userId', userId)
          ..add('email', email)
          ..add('displayName', displayName))
        .toString();
  }
}

class LoginResultBuilder implements Builder<LoginResult, LoginResultBuilder> {
  _$LoginResult? _$v;

  bool? _requiresMfa;
  bool? get requiresMfa => _$this._requiresMfa;
  set requiresMfa(bool? requiresMfa) => _$this._requiresMfa = requiresMfa;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  LoginResultBuilder() {
    LoginResult._defaults(this);
  }

  LoginResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _requiresMfa = $v.requiresMfa;
      _userId = $v.userId;
      _email = $v.email;
      _displayName = $v.displayName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginResult other) {
    _$v = other as _$LoginResult;
  }

  @override
  void update(void Function(LoginResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginResult build() => _build();

  _$LoginResult _build() {
    final _$result = _$v ??
        _$LoginResult._(
          requiresMfa: BuiltValueNullFieldError.checkNotNull(
              requiresMfa, r'LoginResult', 'requiresMfa'),
          userId: userId,
          email: email,
          displayName: displayName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
