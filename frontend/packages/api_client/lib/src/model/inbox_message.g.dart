// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_message.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InboxMessage extends InboxMessage {
  @override
  final String id;
  @override
  final String type;
  @override
  final BuiltMap<String, JsonObject?> payload;
  @override
  final DateTime createdAt;
  @override
  final DateTime? readAt;

  factory _$InboxMessage([void Function(InboxMessageBuilder)? updates]) =>
      (InboxMessageBuilder()..update(updates))._build();

  _$InboxMessage._(
      {required this.id,
      required this.type,
      required this.payload,
      required this.createdAt,
      this.readAt})
      : super._();
  @override
  InboxMessage rebuild(void Function(InboxMessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InboxMessageBuilder toBuilder() => InboxMessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InboxMessage &&
        id == other.id &&
        type == other.type &&
        payload == other.payload &&
        createdAt == other.createdAt &&
        readAt == other.readAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, payload.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, readAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InboxMessage')
          ..add('id', id)
          ..add('type', type)
          ..add('payload', payload)
          ..add('createdAt', createdAt)
          ..add('readAt', readAt))
        .toString();
  }
}

class InboxMessageBuilder
    implements Builder<InboxMessage, InboxMessageBuilder> {
  _$InboxMessage? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  MapBuilder<String, JsonObject?>? _payload;
  MapBuilder<String, JsonObject?> get payload =>
      _$this._payload ??= MapBuilder<String, JsonObject?>();
  set payload(MapBuilder<String, JsonObject?>? payload) =>
      _$this._payload = payload;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _readAt;
  DateTime? get readAt => _$this._readAt;
  set readAt(DateTime? readAt) => _$this._readAt = readAt;

  InboxMessageBuilder() {
    InboxMessage._defaults(this);
  }

  InboxMessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _payload = $v.payload.toBuilder();
      _createdAt = $v.createdAt;
      _readAt = $v.readAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InboxMessage other) {
    _$v = other as _$InboxMessage;
  }

  @override
  void update(void Function(InboxMessageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InboxMessage build() => _build();

  _$InboxMessage _build() {
    _$InboxMessage _$result;
    try {
      _$result = _$v ??
          _$InboxMessage._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'InboxMessage', 'id'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'InboxMessage', 'type'),
            payload: payload.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'InboxMessage', 'createdAt'),
            readAt: readAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payload';
        payload.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InboxMessage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
