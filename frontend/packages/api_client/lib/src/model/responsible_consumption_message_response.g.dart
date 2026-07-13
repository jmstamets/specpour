// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responsible_consumption_message_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResponsibleConsumptionMessageResponse
    extends ResponsibleConsumptionMessageResponse {
  @override
  final String surface;
  @override
  final String jurisdictionCode;
  @override
  final String placement;
  @override
  final String messageContentKey;

  factory _$ResponsibleConsumptionMessageResponse(
          [void Function(ResponsibleConsumptionMessageResponseBuilder)?
              updates]) =>
      (ResponsibleConsumptionMessageResponseBuilder()..update(updates))
          ._build();

  _$ResponsibleConsumptionMessageResponse._(
      {required this.surface,
      required this.jurisdictionCode,
      required this.placement,
      required this.messageContentKey})
      : super._();
  @override
  ResponsibleConsumptionMessageResponse rebuild(
          void Function(ResponsibleConsumptionMessageResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResponsibleConsumptionMessageResponseBuilder toBuilder() =>
      ResponsibleConsumptionMessageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResponsibleConsumptionMessageResponse &&
        surface == other.surface &&
        jurisdictionCode == other.jurisdictionCode &&
        placement == other.placement &&
        messageContentKey == other.messageContentKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, surface.hashCode);
    _$hash = $jc(_$hash, jurisdictionCode.hashCode);
    _$hash = $jc(_$hash, placement.hashCode);
    _$hash = $jc(_$hash, messageContentKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ResponsibleConsumptionMessageResponse')
          ..add('surface', surface)
          ..add('jurisdictionCode', jurisdictionCode)
          ..add('placement', placement)
          ..add('messageContentKey', messageContentKey))
        .toString();
  }
}

class ResponsibleConsumptionMessageResponseBuilder
    implements
        Builder<ResponsibleConsumptionMessageResponse,
            ResponsibleConsumptionMessageResponseBuilder> {
  _$ResponsibleConsumptionMessageResponse? _$v;

  String? _surface;
  String? get surface => _$this._surface;
  set surface(String? surface) => _$this._surface = surface;

  String? _jurisdictionCode;
  String? get jurisdictionCode => _$this._jurisdictionCode;
  set jurisdictionCode(String? jurisdictionCode) =>
      _$this._jurisdictionCode = jurisdictionCode;

  String? _placement;
  String? get placement => _$this._placement;
  set placement(String? placement) => _$this._placement = placement;

  String? _messageContentKey;
  String? get messageContentKey => _$this._messageContentKey;
  set messageContentKey(String? messageContentKey) =>
      _$this._messageContentKey = messageContentKey;

  ResponsibleConsumptionMessageResponseBuilder() {
    ResponsibleConsumptionMessageResponse._defaults(this);
  }

  ResponsibleConsumptionMessageResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _surface = $v.surface;
      _jurisdictionCode = $v.jurisdictionCode;
      _placement = $v.placement;
      _messageContentKey = $v.messageContentKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResponsibleConsumptionMessageResponse other) {
    _$v = other as _$ResponsibleConsumptionMessageResponse;
  }

  @override
  void update(
      void Function(ResponsibleConsumptionMessageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResponsibleConsumptionMessageResponse build() => _build();

  _$ResponsibleConsumptionMessageResponse _build() {
    final _$result = _$v ??
        _$ResponsibleConsumptionMessageResponse._(
          surface: BuiltValueNullFieldError.checkNotNull(
              surface, r'ResponsibleConsumptionMessageResponse', 'surface'),
          jurisdictionCode: BuiltValueNullFieldError.checkNotNull(
              jurisdictionCode,
              r'ResponsibleConsumptionMessageResponse',
              'jurisdictionCode'),
          placement: BuiltValueNullFieldError.checkNotNull(
              placement, r'ResponsibleConsumptionMessageResponse', 'placement'),
          messageContentKey: BuiltValueNullFieldError.checkNotNull(
              messageContentKey,
              r'ResponsibleConsumptionMessageResponse',
              'messageContentKey'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
