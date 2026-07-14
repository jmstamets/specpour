// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_preference.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChannelPreferenceChannelEnum _$channelPreferenceChannelEnum_email =
    const ChannelPreferenceChannelEnum._('email');
const ChannelPreferenceChannelEnum _$channelPreferenceChannelEnum_push =
    const ChannelPreferenceChannelEnum._('push');

ChannelPreferenceChannelEnum _$channelPreferenceChannelEnumValueOf(
    String name) {
  switch (name) {
    case 'email':
      return _$channelPreferenceChannelEnum_email;
    case 'push':
      return _$channelPreferenceChannelEnum_push;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChannelPreferenceChannelEnum>
    _$channelPreferenceChannelEnumValues =
    BuiltSet<ChannelPreferenceChannelEnum>(const <ChannelPreferenceChannelEnum>[
  _$channelPreferenceChannelEnum_email,
  _$channelPreferenceChannelEnum_push,
]);

Serializer<ChannelPreferenceChannelEnum>
    _$channelPreferenceChannelEnumSerializer =
    _$ChannelPreferenceChannelEnumSerializer();

class _$ChannelPreferenceChannelEnumSerializer
    implements PrimitiveSerializer<ChannelPreferenceChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'email': 'email',
    'push': 'push',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'email': 'email',
    'push': 'push',
  };

  @override
  final Iterable<Type> types = const <Type>[ChannelPreferenceChannelEnum];
  @override
  final String wireName = 'ChannelPreferenceChannelEnum';

  @override
  Object serialize(Serializers serializers, ChannelPreferenceChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChannelPreferenceChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChannelPreferenceChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChannelPreference extends ChannelPreference {
  @override
  final ChannelPreferenceChannelEnum channel;
  @override
  final bool optedIn;
  @override
  final DateTime updatedAt;

  factory _$ChannelPreference(
          [void Function(ChannelPreferenceBuilder)? updates]) =>
      (ChannelPreferenceBuilder()..update(updates))._build();

  _$ChannelPreference._(
      {required this.channel, required this.optedIn, required this.updatedAt})
      : super._();
  @override
  ChannelPreference rebuild(void Function(ChannelPreferenceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChannelPreferenceBuilder toBuilder() =>
      ChannelPreferenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChannelPreference &&
        channel == other.channel &&
        optedIn == other.optedIn &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, optedIn.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChannelPreference')
          ..add('channel', channel)
          ..add('optedIn', optedIn)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ChannelPreferenceBuilder
    implements Builder<ChannelPreference, ChannelPreferenceBuilder> {
  _$ChannelPreference? _$v;

  ChannelPreferenceChannelEnum? _channel;
  ChannelPreferenceChannelEnum? get channel => _$this._channel;
  set channel(ChannelPreferenceChannelEnum? channel) =>
      _$this._channel = channel;

  bool? _optedIn;
  bool? get optedIn => _$this._optedIn;
  set optedIn(bool? optedIn) => _$this._optedIn = optedIn;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ChannelPreferenceBuilder() {
    ChannelPreference._defaults(this);
  }

  ChannelPreferenceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channel = $v.channel;
      _optedIn = $v.optedIn;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChannelPreference other) {
    _$v = other as _$ChannelPreference;
  }

  @override
  void update(void Function(ChannelPreferenceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChannelPreference build() => _build();

  _$ChannelPreference _build() {
    final _$result = _$v ??
        _$ChannelPreference._(
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'ChannelPreference', 'channel'),
          optedIn: BuiltValueNullFieldError.checkNotNull(
              optedIn, r'ChannelPreference', 'optedIn'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'ChannelPreference', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
