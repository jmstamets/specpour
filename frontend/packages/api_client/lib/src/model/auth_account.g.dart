// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_account.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthAccount extends AuthAccount {
  @override
  final String userId;
  @override
  final String email;
  @override
  final String displayName;

  factory _$AuthAccount([void Function(AuthAccountBuilder)? updates]) =>
      (AuthAccountBuilder()..update(updates))._build();

  _$AuthAccount._(
      {required this.userId, required this.email, required this.displayName})
      : super._();
  @override
  AuthAccount rebuild(void Function(AuthAccountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthAccountBuilder toBuilder() => AuthAccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthAccount &&
        userId == other.userId &&
        email == other.email &&
        displayName == other.displayName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthAccount')
          ..add('userId', userId)
          ..add('email', email)
          ..add('displayName', displayName))
        .toString();
  }
}

class AuthAccountBuilder implements Builder<AuthAccount, AuthAccountBuilder> {
  _$AuthAccount? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  AuthAccountBuilder() {
    AuthAccount._defaults(this);
  }

  AuthAccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _email = $v.email;
      _displayName = $v.displayName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthAccount other) {
    _$v = other as _$AuthAccount;
  }

  @override
  void update(void Function(AuthAccountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthAccount build() => _build();

  _$AuthAccount _build() {
    final _$result = _$v ??
        _$AuthAccount._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'AuthAccount', 'userId'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'AuthAccount', 'email'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'AuthAccount', 'displayName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
