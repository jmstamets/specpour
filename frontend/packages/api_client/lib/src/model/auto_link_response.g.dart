// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_link_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutoLinkResponse extends AutoLinkResponse {
  @override
  final BuiltList<AutoLinkMatch> matches;

  factory _$AutoLinkResponse(
          [void Function(AutoLinkResponseBuilder)? updates]) =>
      (AutoLinkResponseBuilder()..update(updates))._build();

  _$AutoLinkResponse._({required this.matches}) : super._();
  @override
  AutoLinkResponse rebuild(void Function(AutoLinkResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoLinkResponseBuilder toBuilder() =>
      AutoLinkResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoLinkResponse && matches == other.matches;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, matches.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoLinkResponse')
          ..add('matches', matches))
        .toString();
  }
}

class AutoLinkResponseBuilder
    implements Builder<AutoLinkResponse, AutoLinkResponseBuilder> {
  _$AutoLinkResponse? _$v;

  ListBuilder<AutoLinkMatch>? _matches;
  ListBuilder<AutoLinkMatch> get matches =>
      _$this._matches ??= ListBuilder<AutoLinkMatch>();
  set matches(ListBuilder<AutoLinkMatch>? matches) => _$this._matches = matches;

  AutoLinkResponseBuilder() {
    AutoLinkResponse._defaults(this);
  }

  AutoLinkResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _matches = $v.matches.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoLinkResponse other) {
    _$v = other as _$AutoLinkResponse;
  }

  @override
  void update(void Function(AutoLinkResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoLinkResponse build() => _build();

  _$AutoLinkResponse _build() {
    _$AutoLinkResponse _$result;
    try {
      _$result = _$v ??
          _$AutoLinkResponse._(
            matches: matches.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'matches';
        matches.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AutoLinkResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
