// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_preferences_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChannelPreferencesUpdate extends ChannelPreferencesUpdate {
  @override
  final BuiltList<ChannelPreferencesUpdateChannelsInner> channels;

  factory _$ChannelPreferencesUpdate(
          [void Function(ChannelPreferencesUpdateBuilder)? updates]) =>
      (ChannelPreferencesUpdateBuilder()..update(updates))._build();

  _$ChannelPreferencesUpdate._({required this.channels}) : super._();
  @override
  ChannelPreferencesUpdate rebuild(
          void Function(ChannelPreferencesUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChannelPreferencesUpdateBuilder toBuilder() =>
      ChannelPreferencesUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChannelPreferencesUpdate && channels == other.channels;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channels.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChannelPreferencesUpdate')
          ..add('channels', channels))
        .toString();
  }
}

class ChannelPreferencesUpdateBuilder
    implements
        Builder<ChannelPreferencesUpdate, ChannelPreferencesUpdateBuilder> {
  _$ChannelPreferencesUpdate? _$v;

  ListBuilder<ChannelPreferencesUpdateChannelsInner>? _channels;
  ListBuilder<ChannelPreferencesUpdateChannelsInner> get channels =>
      _$this._channels ??= ListBuilder<ChannelPreferencesUpdateChannelsInner>();
  set channels(ListBuilder<ChannelPreferencesUpdateChannelsInner>? channels) =>
      _$this._channels = channels;

  ChannelPreferencesUpdateBuilder() {
    ChannelPreferencesUpdate._defaults(this);
  }

  ChannelPreferencesUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channels = $v.channels.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChannelPreferencesUpdate other) {
    _$v = other as _$ChannelPreferencesUpdate;
  }

  @override
  void update(void Function(ChannelPreferencesUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChannelPreferencesUpdate build() => _build();

  _$ChannelPreferencesUpdate _build() {
    _$ChannelPreferencesUpdate _$result;
    try {
      _$result = _$v ??
          _$ChannelPreferencesUpdate._(
            channels: channels.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChannelPreferencesUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
