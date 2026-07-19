// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InventoryItemSource_Enum _$inventoryItemSourceEnum_photoRecognition =
    const InventoryItemSource_Enum._('photoRecognition');
const InventoryItemSource_Enum _$inventoryItemSourceEnum_barcode =
    const InventoryItemSource_Enum._('barcode');
const InventoryItemSource_Enum _$inventoryItemSourceEnum_manual =
    const InventoryItemSource_Enum._('manual');
const InventoryItemSource_Enum _$inventoryItemSourceEnum_prep =
    const InventoryItemSource_Enum._('prep');

InventoryItemSource_Enum _$inventoryItemSourceEnumValueOf(String name) {
  switch (name) {
    case 'photoRecognition':
      return _$inventoryItemSourceEnum_photoRecognition;
    case 'barcode':
      return _$inventoryItemSourceEnum_barcode;
    case 'manual':
      return _$inventoryItemSourceEnum_manual;
    case 'prep':
      return _$inventoryItemSourceEnum_prep;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InventoryItemSource_Enum> _$inventoryItemSourceEnumValues =
    BuiltSet<InventoryItemSource_Enum>(const <InventoryItemSource_Enum>[
  _$inventoryItemSourceEnum_photoRecognition,
  _$inventoryItemSourceEnum_barcode,
  _$inventoryItemSourceEnum_manual,
  _$inventoryItemSourceEnum_prep,
]);

Serializer<InventoryItemSource_Enum> _$inventoryItemSourceEnumSerializer =
    _$InventoryItemSource_EnumSerializer();

class _$InventoryItemSource_EnumSerializer
    implements PrimitiveSerializer<InventoryItemSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'photoRecognition': 'photo-recognition',
    'barcode': 'barcode',
    'manual': 'manual',
    'prep': 'prep',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'photo-recognition': 'photoRecognition',
    'barcode': 'barcode',
    'manual': 'manual',
    'prep': 'prep',
  };

  @override
  final Iterable<Type> types = const <Type>[InventoryItemSource_Enum];
  @override
  final String wireName = 'InventoryItemSource_Enum';

  @override
  Object serialize(Serializers serializers, InventoryItemSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InventoryItemSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InventoryItemSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InventoryItem extends InventoryItem {
  @override
  final String id;
  @override
  final String ingredientId;
  @override
  final String? ingredientName;
  @override
  final num? quantity;
  @override
  final String? bottleSize;
  @override
  final InventoryItemSource_Enum source_;
  @override
  final DateTime addedAt;

  factory _$InventoryItem([void Function(InventoryItemBuilder)? updates]) =>
      (InventoryItemBuilder()..update(updates))._build();

  _$InventoryItem._(
      {required this.id,
      required this.ingredientId,
      this.ingredientName,
      this.quantity,
      this.bottleSize,
      required this.source_,
      required this.addedAt})
      : super._();
  @override
  InventoryItem rebuild(void Function(InventoryItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryItemBuilder toBuilder() => InventoryItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryItem &&
        id == other.id &&
        ingredientId == other.ingredientId &&
        ingredientName == other.ingredientName &&
        quantity == other.quantity &&
        bottleSize == other.bottleSize &&
        source_ == other.source_ &&
        addedAt == other.addedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ingredientId.hashCode);
    _$hash = $jc(_$hash, ingredientName.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, bottleSize.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, addedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryItem')
          ..add('id', id)
          ..add('ingredientId', ingredientId)
          ..add('ingredientName', ingredientName)
          ..add('quantity', quantity)
          ..add('bottleSize', bottleSize)
          ..add('source_', source_)
          ..add('addedAt', addedAt))
        .toString();
  }
}

class InventoryItemBuilder
    implements Builder<InventoryItem, InventoryItemBuilder> {
  _$InventoryItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _ingredientId;
  String? get ingredientId => _$this._ingredientId;
  set ingredientId(String? ingredientId) => _$this._ingredientId = ingredientId;

  String? _ingredientName;
  String? get ingredientName => _$this._ingredientName;
  set ingredientName(String? ingredientName) =>
      _$this._ingredientName = ingredientName;

  num? _quantity;
  num? get quantity => _$this._quantity;
  set quantity(num? quantity) => _$this._quantity = quantity;

  String? _bottleSize;
  String? get bottleSize => _$this._bottleSize;
  set bottleSize(String? bottleSize) => _$this._bottleSize = bottleSize;

  InventoryItemSource_Enum? _source_;
  InventoryItemSource_Enum? get source_ => _$this._source_;
  set source_(InventoryItemSource_Enum? source_) => _$this._source_ = source_;

  DateTime? _addedAt;
  DateTime? get addedAt => _$this._addedAt;
  set addedAt(DateTime? addedAt) => _$this._addedAt = addedAt;

  InventoryItemBuilder() {
    InventoryItem._defaults(this);
  }

  InventoryItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _ingredientId = $v.ingredientId;
      _ingredientName = $v.ingredientName;
      _quantity = $v.quantity;
      _bottleSize = $v.bottleSize;
      _source_ = $v.source_;
      _addedAt = $v.addedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryItem other) {
    _$v = other as _$InventoryItem;
  }

  @override
  void update(void Function(InventoryItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryItem build() => _build();

  _$InventoryItem _build() {
    final _$result = _$v ??
        _$InventoryItem._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'InventoryItem', 'id'),
          ingredientId: BuiltValueNullFieldError.checkNotNull(
              ingredientId, r'InventoryItem', 'ingredientId'),
          ingredientName: ingredientName,
          quantity: quantity,
          bottleSize: bottleSize,
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'InventoryItem', 'source_'),
          addedAt: BuiltValueNullFieldError.checkNotNull(
              addedAt, r'InventoryItem', 'addedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
