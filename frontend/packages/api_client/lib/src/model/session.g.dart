// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Session extends Session {
  @override
  final String id;
  @override
  final String deviceDescription;
  @override
  final DateTime createdAt;
  @override
  final DateTime lastSeenAt;

  factory _$Session([void Function(SessionBuilder)? updates]) =>
      (SessionBuilder()..update(updates))._build();

  _$Session._(
      {required this.id,
      required this.deviceDescription,
      required this.createdAt,
      required this.lastSeenAt})
      : super._();
  @override
  Session rebuild(void Function(SessionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SessionBuilder toBuilder() => SessionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Session &&
        id == other.id &&
        deviceDescription == other.deviceDescription &&
        createdAt == other.createdAt &&
        lastSeenAt == other.lastSeenAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, deviceDescription.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, lastSeenAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Session')
          ..add('id', id)
          ..add('deviceDescription', deviceDescription)
          ..add('createdAt', createdAt)
          ..add('lastSeenAt', lastSeenAt))
        .toString();
  }
}

class SessionBuilder implements Builder<Session, SessionBuilder> {
  _$Session? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _deviceDescription;
  String? get deviceDescription => _$this._deviceDescription;
  set deviceDescription(String? deviceDescription) =>
      _$this._deviceDescription = deviceDescription;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _lastSeenAt;
  DateTime? get lastSeenAt => _$this._lastSeenAt;
  set lastSeenAt(DateTime? lastSeenAt) => _$this._lastSeenAt = lastSeenAt;

  SessionBuilder() {
    Session._defaults(this);
  }

  SessionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _deviceDescription = $v.deviceDescription;
      _createdAt = $v.createdAt;
      _lastSeenAt = $v.lastSeenAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Session other) {
    _$v = other as _$Session;
  }

  @override
  void update(void Function(SessionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Session build() => _build();

  _$Session _build() {
    final _$result = _$v ??
        _$Session._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Session', 'id'),
          deviceDescription: BuiltValueNullFieldError.checkNotNull(
              deviceDescription, r'Session', 'deviceDescription'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'Session', 'createdAt'),
          lastSeenAt: BuiltValueNullFieldError.checkNotNull(
              lastSeenAt, r'Session', 'lastSeenAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
