// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_resources_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportResourcesResponse extends SupportResourcesResponse {
  @override
  final BuiltList<SupportResourceResponse> items;

  factory _$SupportResourcesResponse(
          [void Function(SupportResourcesResponseBuilder)? updates]) =>
      (SupportResourcesResponseBuilder()..update(updates))._build();

  _$SupportResourcesResponse._({required this.items}) : super._();
  @override
  SupportResourcesResponse rebuild(
          void Function(SupportResourcesResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportResourcesResponseBuilder toBuilder() =>
      SupportResourcesResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportResourcesResponse && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportResourcesResponse')
          ..add('items', items))
        .toString();
  }
}

class SupportResourcesResponseBuilder
    implements
        Builder<SupportResourcesResponse, SupportResourcesResponseBuilder> {
  _$SupportResourcesResponse? _$v;

  ListBuilder<SupportResourceResponse>? _items;
  ListBuilder<SupportResourceResponse> get items =>
      _$this._items ??= ListBuilder<SupportResourceResponse>();
  set items(ListBuilder<SupportResourceResponse>? items) =>
      _$this._items = items;

  SupportResourcesResponseBuilder() {
    SupportResourcesResponse._defaults(this);
  }

  SupportResourcesResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportResourcesResponse other) {
    _$v = other as _$SupportResourcesResponse;
  }

  @override
  void update(void Function(SupportResourcesResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportResourcesResponse build() => _build();

  _$SupportResourcesResponse _build() {
    _$SupportResourcesResponse _$result;
    try {
      _$result = _$v ??
          _$SupportResourcesResponse._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SupportResourcesResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
