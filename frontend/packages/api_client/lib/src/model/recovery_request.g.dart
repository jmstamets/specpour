// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecoveryRequest extends RecoveryRequest {
  @override
  final String email;

  factory _$RecoveryRequest([void Function(RecoveryRequestBuilder)? updates]) =>
      (RecoveryRequestBuilder()..update(updates))._build();

  _$RecoveryRequest._({required this.email}) : super._();
  @override
  RecoveryRequest rebuild(void Function(RecoveryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecoveryRequestBuilder toBuilder() => RecoveryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecoveryRequest && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecoveryRequest')
          ..add('email', email))
        .toString();
  }
}

class RecoveryRequestBuilder
    implements Builder<RecoveryRequest, RecoveryRequestBuilder> {
  _$RecoveryRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  RecoveryRequestBuilder() {
    RecoveryRequest._defaults(this);
  }

  RecoveryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecoveryRequest other) {
    _$v = other as _$RecoveryRequest;
  }

  @override
  void update(void Function(RecoveryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecoveryRequest build() => _build();

  _$RecoveryRequest _build() {
    final _$result = _$v ??
        _$RecoveryRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'RecoveryRequest', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
