// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recognize_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecognizeRequest extends RecognizeRequest {
  @override
  final String? photoUrl;

  factory _$RecognizeRequest(
          [void Function(RecognizeRequestBuilder)? updates]) =>
      (RecognizeRequestBuilder()..update(updates))._build();

  _$RecognizeRequest._({this.photoUrl}) : super._();
  @override
  RecognizeRequest rebuild(void Function(RecognizeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecognizeRequestBuilder toBuilder() =>
      RecognizeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecognizeRequest && photoUrl == other.photoUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, photoUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecognizeRequest')
          ..add('photoUrl', photoUrl))
        .toString();
  }
}

class RecognizeRequestBuilder
    implements Builder<RecognizeRequest, RecognizeRequestBuilder> {
  _$RecognizeRequest? _$v;

  String? _photoUrl;
  String? get photoUrl => _$this._photoUrl;
  set photoUrl(String? photoUrl) => _$this._photoUrl = photoUrl;

  RecognizeRequestBuilder() {
    RecognizeRequest._defaults(this);
  }

  RecognizeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _photoUrl = $v.photoUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecognizeRequest other) {
    _$v = other as _$RecognizeRequest;
  }

  @override
  void update(void Function(RecognizeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecognizeRequest build() => _build();

  _$RecognizeRequest _build() {
    final _$result = _$v ??
        _$RecognizeRequest._(
          photoUrl: photoUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
