// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_inventory_item_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateInventoryItemRequestSource_Enum
    _$createInventoryItemRequestSourceEnum_photoRecognition =
    const CreateInventoryItemRequestSource_Enum._('photoRecognition');
const CreateInventoryItemRequestSource_Enum
    _$createInventoryItemRequestSourceEnum_barcode =
    const CreateInventoryItemRequestSource_Enum._('barcode');
const CreateInventoryItemRequestSource_Enum
    _$createInventoryItemRequestSourceEnum_manual =
    const CreateInventoryItemRequestSource_Enum._('manual');
const CreateInventoryItemRequestSource_Enum
    _$createInventoryItemRequestSourceEnum_prep =
    const CreateInventoryItemRequestSource_Enum._('prep');

CreateInventoryItemRequestSource_Enum
    _$createInventoryItemRequestSourceEnumValueOf(String name) {
  switch (name) {
    case 'photoRecognition':
      return _$createInventoryItemRequestSourceEnum_photoRecognition;
    case 'barcode':
      return _$createInventoryItemRequestSourceEnum_barcode;
    case 'manual':
      return _$createInventoryItemRequestSourceEnum_manual;
    case 'prep':
      return _$createInventoryItemRequestSourceEnum_prep;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateInventoryItemRequestSource_Enum>
    _$createInventoryItemRequestSourceEnumValues = BuiltSet<
        CreateInventoryItemRequestSource_Enum>(const <CreateInventoryItemRequestSource_Enum>[
  _$createInventoryItemRequestSourceEnum_photoRecognition,
  _$createInventoryItemRequestSourceEnum_barcode,
  _$createInventoryItemRequestSourceEnum_manual,
  _$createInventoryItemRequestSourceEnum_prep,
]);

Serializer<CreateInventoryItemRequestSource_Enum>
    _$createInventoryItemRequestSourceEnumSerializer =
    _$CreateInventoryItemRequestSource_EnumSerializer();

class _$CreateInventoryItemRequestSource_EnumSerializer
    implements PrimitiveSerializer<CreateInventoryItemRequestSource_Enum> {
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
  final Iterable<Type> types = const <Type>[
    CreateInventoryItemRequestSource_Enum
  ];
  @override
  final String wireName = 'CreateInventoryItemRequestSource_Enum';

  @override
  Object serialize(
          Serializers serializers, CreateInventoryItemRequestSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateInventoryItemRequestSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateInventoryItemRequestSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateInventoryItemRequest extends CreateInventoryItemRequest {
  @override
  final String ingredientId;
  @override
  final String? venueId;
  @override
  final num? quantity;
  @override
  final String? bottleSize;
  @override
  final CreateInventoryItemRequestSource_Enum source_;

  factory _$CreateInventoryItemRequest(
          [void Function(CreateInventoryItemRequestBuilder)? updates]) =>
      (CreateInventoryItemRequestBuilder()..update(updates))._build();

  _$CreateInventoryItemRequest._(
      {required this.ingredientId,
      this.venueId,
      this.quantity,
      this.bottleSize,
      required this.source_})
      : super._();
  @override
  CreateInventoryItemRequest rebuild(
          void Function(CreateInventoryItemRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateInventoryItemRequestBuilder toBuilder() =>
      CreateInventoryItemRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateInventoryItemRequest &&
        ingredientId == other.ingredientId &&
        venueId == other.venueId &&
        quantity == other.quantity &&
        bottleSize == other.bottleSize &&
        source_ == other.source_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ingredientId.hashCode);
    _$hash = $jc(_$hash, venueId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, bottleSize.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateInventoryItemRequest')
          ..add('ingredientId', ingredientId)
          ..add('venueId', venueId)
          ..add('quantity', quantity)
          ..add('bottleSize', bottleSize)
          ..add('source_', source_))
        .toString();
  }
}

class CreateInventoryItemRequestBuilder
    implements
        Builder<CreateInventoryItemRequest, CreateInventoryItemRequestBuilder> {
  _$CreateInventoryItemRequest? _$v;

  String? _ingredientId;
  String? get ingredientId => _$this._ingredientId;
  set ingredientId(String? ingredientId) => _$this._ingredientId = ingredientId;

  String? _venueId;
  String? get venueId => _$this._venueId;
  set venueId(String? venueId) => _$this._venueId = venueId;

  num? _quantity;
  num? get quantity => _$this._quantity;
  set quantity(num? quantity) => _$this._quantity = quantity;

  String? _bottleSize;
  String? get bottleSize => _$this._bottleSize;
  set bottleSize(String? bottleSize) => _$this._bottleSize = bottleSize;

  CreateInventoryItemRequestSource_Enum? _source_;
  CreateInventoryItemRequestSource_Enum? get source_ => _$this._source_;
  set source_(CreateInventoryItemRequestSource_Enum? source_) =>
      _$this._source_ = source_;

  CreateInventoryItemRequestBuilder() {
    CreateInventoryItemRequest._defaults(this);
  }

  CreateInventoryItemRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ingredientId = $v.ingredientId;
      _venueId = $v.venueId;
      _quantity = $v.quantity;
      _bottleSize = $v.bottleSize;
      _source_ = $v.source_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateInventoryItemRequest other) {
    _$v = other as _$CreateInventoryItemRequest;
  }

  @override
  void update(void Function(CreateInventoryItemRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateInventoryItemRequest build() => _build();

  _$CreateInventoryItemRequest _build() {
    final _$result = _$v ??
        _$CreateInventoryItemRequest._(
          ingredientId: BuiltValueNullFieldError.checkNotNull(
              ingredientId, r'CreateInventoryItemRequest', 'ingredientId'),
          venueId: venueId,
          quantity: quantity,
          bottleSize: bottleSize,
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'CreateInventoryItemRequest', 'source_'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
