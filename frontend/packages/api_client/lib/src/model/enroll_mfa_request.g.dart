// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enroll_mfa_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EnrollMfaRequest extends EnrollMfaRequest {
  @override
  final String? code;

  factory _$EnrollMfaRequest(
          [void Function(EnrollMfaRequestBuilder)? updates]) =>
      (EnrollMfaRequestBuilder()..update(updates))._build();

  _$EnrollMfaRequest._({this.code}) : super._();
  @override
  EnrollMfaRequest rebuild(void Function(EnrollMfaRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnrollMfaRequestBuilder toBuilder() =>
      EnrollMfaRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnrollMfaRequest && code == other.code;
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
    return (newBuiltValueToStringHelper(r'EnrollMfaRequest')..add('code', code))
        .toString();
  }
}

class EnrollMfaRequestBuilder
    implements Builder<EnrollMfaRequest, EnrollMfaRequestBuilder> {
  _$EnrollMfaRequest? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  EnrollMfaRequestBuilder() {
    EnrollMfaRequest._defaults(this);
  }

  EnrollMfaRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnrollMfaRequest other) {
    _$v = other as _$EnrollMfaRequest;
  }

  @override
  void update(void Function(EnrollMfaRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnrollMfaRequest build() => _build();

  _$EnrollMfaRequest _build() {
    final _$result = _$v ??
        _$EnrollMfaRequest._(
          code: code,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
