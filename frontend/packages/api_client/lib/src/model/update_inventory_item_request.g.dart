// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_inventory_item_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateInventoryItemRequest extends UpdateInventoryItemRequest {
  @override
  final num? quantity;
  @override
  final String? bottleSize;

  factory _$UpdateInventoryItemRequest(
          [void Function(UpdateInventoryItemRequestBuilder)? updates]) =>
      (UpdateInventoryItemRequestBuilder()..update(updates))._build();

  _$UpdateInventoryItemRequest._({this.quantity, this.bottleSize}) : super._();
  @override
  UpdateInventoryItemRequest rebuild(
          void Function(UpdateInventoryItemRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateInventoryItemRequestBuilder toBuilder() =>
      UpdateInventoryItemRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateInventoryItemRequest &&
        quantity == other.quantity &&
        bottleSize == other.bottleSize;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, bottleSize.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateInventoryItemRequest')
          ..add('quantity', quantity)
          ..add('bottleSize', bottleSize))
        .toString();
  }
}

class UpdateInventoryItemRequestBuilder
    implements
        Builder<UpdateInventoryItemRequest, UpdateInventoryItemRequestBuilder> {
  _$UpdateInventoryItemRequest? _$v;

  num? _quantity;
  num? get quantity => _$this._quantity;
  set quantity(num? quantity) => _$this._quantity = quantity;

  String? _bottleSize;
  String? get bottleSize => _$this._bottleSize;
  set bottleSize(String? bottleSize) => _$this._bottleSize = bottleSize;

  UpdateInventoryItemRequestBuilder() {
    UpdateInventoryItemRequest._defaults(this);
  }

  UpdateInventoryItemRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quantity = $v.quantity;
      _bottleSize = $v.bottleSize;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateInventoryItemRequest other) {
    _$v = other as _$UpdateInventoryItemRequest;
  }

  @override
  void update(void Function(UpdateInventoryItemRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateInventoryItemRequest build() => _build();

  _$UpdateInventoryItemRequest _build() {
    final _$result = _$v ??
        _$UpdateInventoryItemRequest._(
          quantity: quantity,
          bottleSize: bottleSize,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
