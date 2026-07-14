// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_preferences_update_channels_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChannelPreferencesUpdateChannelsInnerChannelEnum
    _$channelPreferencesUpdateChannelsInnerChannelEnum_email =
    const ChannelPreferencesUpdateChannelsInnerChannelEnum._('email');
const ChannelPreferencesUpdateChannelsInnerChannelEnum
    _$channelPreferencesUpdateChannelsInnerChannelEnum_push =
    const ChannelPreferencesUpdateChannelsInnerChannelEnum._('push');

ChannelPreferencesUpdateChannelsInnerChannelEnum
    _$channelPreferencesUpdateChannelsInnerChannelEnumValueOf(String name) {
  switch (name) {
    case 'email':
      return _$channelPreferencesUpdateChannelsInnerChannelEnum_email;
    case 'push':
      return _$channelPreferencesUpdateChannelsInnerChannelEnum_push;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChannelPreferencesUpdateChannelsInnerChannelEnum>
    _$channelPreferencesUpdateChannelsInnerChannelEnumValues = BuiltSet<
        ChannelPreferencesUpdateChannelsInnerChannelEnum>(const <ChannelPreferencesUpdateChannelsInnerChannelEnum>[
  _$channelPreferencesUpdateChannelsInnerChannelEnum_email,
  _$channelPreferencesUpdateChannelsInnerChannelEnum_push,
]);

Serializer<ChannelPreferencesUpdateChannelsInnerChannelEnum>
    _$channelPreferencesUpdateChannelsInnerChannelEnumSerializer =
    _$ChannelPreferencesUpdateChannelsInnerChannelEnumSerializer();

class _$ChannelPreferencesUpdateChannelsInnerChannelEnumSerializer
    implements
        PrimitiveSerializer<ChannelPreferencesUpdateChannelsInnerChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'email': 'email',
    'push': 'push',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'email': 'email',
    'push': 'push',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ChannelPreferencesUpdateChannelsInnerChannelEnum
  ];
  @override
  final String wireName = 'ChannelPreferencesUpdateChannelsInnerChannelEnum';

  @override
  Object serialize(Serializers serializers,
          ChannelPreferencesUpdateChannelsInnerChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChannelPreferencesUpdateChannelsInnerChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChannelPreferencesUpdateChannelsInnerChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChannelPreferencesUpdateChannelsInner
    extends ChannelPreferencesUpdateChannelsInner {
  @override
  final ChannelPreferencesUpdateChannelsInnerChannelEnum channel;
  @override
  final bool optedIn;

  factory _$ChannelPreferencesUpdateChannelsInner(
          [void Function(ChannelPreferencesUpdateChannelsInnerBuilder)?
              updates]) =>
      (ChannelPreferencesUpdateChannelsInnerBuilder()..update(updates))
          ._build();

  _$ChannelPreferencesUpdateChannelsInner._(
      {required this.channel, required this.optedIn})
      : super._();
  @override
  ChannelPreferencesUpdateChannelsInner rebuild(
          void Function(ChannelPreferencesUpdateChannelsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChannelPreferencesUpdateChannelsInnerBuilder toBuilder() =>
      ChannelPreferencesUpdateChannelsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChannelPreferencesUpdateChannelsInner &&
        channel == other.channel &&
        optedIn == other.optedIn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, optedIn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ChannelPreferencesUpdateChannelsInner')
          ..add('channel', channel)
          ..add('optedIn', optedIn))
        .toString();
  }
}

class ChannelPreferencesUpdateChannelsInnerBuilder
    implements
        Builder<ChannelPreferencesUpdateChannelsInner,
            ChannelPreferencesUpdateChannelsInnerBuilder> {
  _$ChannelPreferencesUpdateChannelsInner? _$v;

  ChannelPreferencesUpdateChannelsInnerChannelEnum? _channel;
  ChannelPreferencesUpdateChannelsInnerChannelEnum? get channel =>
      _$this._channel;
  set channel(ChannelPreferencesUpdateChannelsInnerChannelEnum? channel) =>
      _$this._channel = channel;

  bool? _optedIn;
  bool? get optedIn => _$this._optedIn;
  set optedIn(bool? optedIn) => _$this._optedIn = optedIn;

  ChannelPreferencesUpdateChannelsInnerBuilder() {
    ChannelPreferencesUpdateChannelsInner._defaults(this);
  }

  ChannelPreferencesUpdateChannelsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channel = $v.channel;
      _optedIn = $v.optedIn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChannelPreferencesUpdateChannelsInner other) {
    _$v = other as _$ChannelPreferencesUpdateChannelsInner;
  }

  @override
  void update(
      void Function(ChannelPreferencesUpdateChannelsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChannelPreferencesUpdateChannelsInner build() => _build();

  _$ChannelPreferencesUpdateChannelsInner _build() {
    final _$result = _$v ??
        _$ChannelPreferencesUpdateChannelsInner._(
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'ChannelPreferencesUpdateChannelsInner', 'channel'),
          optedIn: BuiltValueNullFieldError.checkNotNull(
              optedIn, r'ChannelPreferencesUpdateChannelsInner', 'optedIn'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
