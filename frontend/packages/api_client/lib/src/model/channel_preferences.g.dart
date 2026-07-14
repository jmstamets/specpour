// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_preferences.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChannelPreferences extends ChannelPreferences {
  @override
  final BuiltList<ChannelPreference> channels;

  factory _$ChannelPreferences(
          [void Function(ChannelPreferencesBuilder)? updates]) =>
      (ChannelPreferencesBuilder()..update(updates))._build();

  _$ChannelPreferences._({required this.channels}) : super._();
  @override
  ChannelPreferences rebuild(
          void Function(ChannelPreferencesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChannelPreferencesBuilder toBuilder() =>
      ChannelPreferencesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChannelPreferences && channels == other.channels;
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
    return (newBuiltValueToStringHelper(r'ChannelPreferences')
          ..add('channels', channels))
        .toString();
  }
}

class ChannelPreferencesBuilder
    implements Builder<ChannelPreferences, ChannelPreferencesBuilder> {
  _$ChannelPreferences? _$v;

  ListBuilder<ChannelPreference>? _channels;
  ListBuilder<ChannelPreference> get channels =>
      _$this._channels ??= ListBuilder<ChannelPreference>();
  set channels(ListBuilder<ChannelPreference>? channels) =>
      _$this._channels = channels;

  ChannelPreferencesBuilder() {
    ChannelPreferences._defaults(this);
  }

  ChannelPreferencesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channels = $v.channels.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChannelPreferences other) {
    _$v = other as _$ChannelPreferences;
  }

  @override
  void update(void Function(ChannelPreferencesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChannelPreferences build() => _build();

  _$ChannelPreferences _build() {
    _$ChannelPreferences _$result;
    try {
      _$result = _$v ??
          _$ChannelPreferences._(
            channels: channels.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChannelPreferences', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
