// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_resource_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportResourceResponse extends SupportResourceResponse {
  @override
  final String name;
  @override
  final String link;
  @override
  final int displayOrder;

  factory _$SupportResourceResponse(
          [void Function(SupportResourceResponseBuilder)? updates]) =>
      (SupportResourceResponseBuilder()..update(updates))._build();

  _$SupportResourceResponse._(
      {required this.name, required this.link, required this.displayOrder})
      : super._();
  @override
  SupportResourceResponse rebuild(
          void Function(SupportResourceResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportResourceResponseBuilder toBuilder() =>
      SupportResourceResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportResourceResponse &&
        name == other.name &&
        link == other.link &&
        displayOrder == other.displayOrder;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, link.hashCode);
    _$hash = $jc(_$hash, displayOrder.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportResourceResponse')
          ..add('name', name)
          ..add('link', link)
          ..add('displayOrder', displayOrder))
        .toString();
  }
}

class SupportResourceResponseBuilder
    implements
        Builder<SupportResourceResponse, SupportResourceResponseBuilder> {
  _$SupportResourceResponse? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _link;
  String? get link => _$this._link;
  set link(String? link) => _$this._link = link;

  int? _displayOrder;
  int? get displayOrder => _$this._displayOrder;
  set displayOrder(int? displayOrder) => _$this._displayOrder = displayOrder;

  SupportResourceResponseBuilder() {
    SupportResourceResponse._defaults(this);
  }

  SupportResourceResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _link = $v.link;
      _displayOrder = $v.displayOrder;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportResourceResponse other) {
    _$v = other as _$SupportResourceResponse;
  }

  @override
  void update(void Function(SupportResourceResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportResourceResponse build() => _build();

  _$SupportResourceResponse _build() {
    final _$result = _$v ??
        _$SupportResourceResponse._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'SupportResourceResponse', 'name'),
          link: BuiltValueNullFieldError.checkNotNull(
              link, r'SupportResourceResponse', 'link'),
          displayOrder: BuiltValueNullFieldError.checkNotNull(
              displayOrder, r'SupportResourceResponse', 'displayOrder'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
