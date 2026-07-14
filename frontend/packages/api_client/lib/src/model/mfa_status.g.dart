// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MfaStatusMethodEnum _$mfaStatusMethodEnum_totp =
    const MfaStatusMethodEnum._('totp');

MfaStatusMethodEnum _$mfaStatusMethodEnumValueOf(String name) {
  switch (name) {
    case 'totp':
      return _$mfaStatusMethodEnum_totp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MfaStatusMethodEnum> _$mfaStatusMethodEnumValues =
    BuiltSet<MfaStatusMethodEnum>(const <MfaStatusMethodEnum>[
  _$mfaStatusMethodEnum_totp,
]);

Serializer<MfaStatusMethodEnum> _$mfaStatusMethodEnumSerializer =
    _$MfaStatusMethodEnumSerializer();

class _$MfaStatusMethodEnumSerializer
    implements PrimitiveSerializer<MfaStatusMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'totp': 'totp',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'totp': 'totp',
  };

  @override
  final Iterable<Type> types = const <Type>[MfaStatusMethodEnum];
  @override
  final String wireName = 'MfaStatusMethodEnum';

  @override
  Object serialize(Serializers serializers, MfaStatusMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MfaStatusMethodEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MfaStatusMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MfaStatus extends MfaStatus {
  @override
  final bool enabled;
  @override
  final MfaStatusMethodEnum? method;

  factory _$MfaStatus([void Function(MfaStatusBuilder)? updates]) =>
      (MfaStatusBuilder()..update(updates))._build();

  _$MfaStatus._({required this.enabled, this.method}) : super._();
  @override
  MfaStatus rebuild(void Function(MfaStatusBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaStatusBuilder toBuilder() => MfaStatusBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaStatus &&
        enabled == other.enabled &&
        method == other.method;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaStatus')
          ..add('enabled', enabled)
          ..add('method', method))
        .toString();
  }
}

class MfaStatusBuilder implements Builder<MfaStatus, MfaStatusBuilder> {
  _$MfaStatus? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  MfaStatusMethodEnum? _method;
  MfaStatusMethodEnum? get method => _$this._method;
  set method(MfaStatusMethodEnum? method) => _$this._method = method;

  MfaStatusBuilder() {
    MfaStatus._defaults(this);
  }

  MfaStatusBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _method = $v.method;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaStatus other) {
    _$v = other as _$MfaStatus;
  }

  @override
  void update(void Function(MfaStatusBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaStatus build() => _build();

  _$MfaStatus _build() {
    final _$result = _$v ??
        _$MfaStatus._(
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'MfaStatus', 'enabled'),
          method: method,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
