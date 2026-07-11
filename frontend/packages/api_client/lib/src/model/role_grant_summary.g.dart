// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_grant_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RoleGrantSummaryScopeTypeEnum _$roleGrantSummaryScopeTypeEnum_platform =
    const RoleGrantSummaryScopeTypeEnum._('platform');
const RoleGrantSummaryScopeTypeEnum _$roleGrantSummaryScopeTypeEnum_venue =
    const RoleGrantSummaryScopeTypeEnum._('venue');

RoleGrantSummaryScopeTypeEnum _$roleGrantSummaryScopeTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'platform':
      return _$roleGrantSummaryScopeTypeEnum_platform;
    case 'venue':
      return _$roleGrantSummaryScopeTypeEnum_venue;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RoleGrantSummaryScopeTypeEnum>
    _$roleGrantSummaryScopeTypeEnumValues = BuiltSet<
        RoleGrantSummaryScopeTypeEnum>(const <RoleGrantSummaryScopeTypeEnum>[
  _$roleGrantSummaryScopeTypeEnum_platform,
  _$roleGrantSummaryScopeTypeEnum_venue,
]);

Serializer<RoleGrantSummaryScopeTypeEnum>
    _$roleGrantSummaryScopeTypeEnumSerializer =
    _$RoleGrantSummaryScopeTypeEnumSerializer();

class _$RoleGrantSummaryScopeTypeEnumSerializer
    implements PrimitiveSerializer<RoleGrantSummaryScopeTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'platform': 'platform',
    'venue': 'venue',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'platform': 'platform',
    'venue': 'venue',
  };

  @override
  final Iterable<Type> types = const <Type>[RoleGrantSummaryScopeTypeEnum];
  @override
  final String wireName = 'RoleGrantSummaryScopeTypeEnum';

  @override
  Object serialize(
          Serializers serializers, RoleGrantSummaryScopeTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RoleGrantSummaryScopeTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RoleGrantSummaryScopeTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RoleGrantSummary extends RoleGrantSummary {
  @override
  final String roleKey;
  @override
  final RoleGrantSummaryScopeTypeEnum scopeType;
  @override
  final String? scopeId;

  factory _$RoleGrantSummary(
          [void Function(RoleGrantSummaryBuilder)? updates]) =>
      (RoleGrantSummaryBuilder()..update(updates))._build();

  _$RoleGrantSummary._(
      {required this.roleKey, required this.scopeType, this.scopeId})
      : super._();
  @override
  RoleGrantSummary rebuild(void Function(RoleGrantSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoleGrantSummaryBuilder toBuilder() =>
      RoleGrantSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoleGrantSummary &&
        roleKey == other.roleKey &&
        scopeType == other.scopeType &&
        scopeId == other.scopeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, roleKey.hashCode);
    _$hash = $jc(_$hash, scopeType.hashCode);
    _$hash = $jc(_$hash, scopeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoleGrantSummary')
          ..add('roleKey', roleKey)
          ..add('scopeType', scopeType)
          ..add('scopeId', scopeId))
        .toString();
  }
}

class RoleGrantSummaryBuilder
    implements Builder<RoleGrantSummary, RoleGrantSummaryBuilder> {
  _$RoleGrantSummary? _$v;

  String? _roleKey;
  String? get roleKey => _$this._roleKey;
  set roleKey(String? roleKey) => _$this._roleKey = roleKey;

  RoleGrantSummaryScopeTypeEnum? _scopeType;
  RoleGrantSummaryScopeTypeEnum? get scopeType => _$this._scopeType;
  set scopeType(RoleGrantSummaryScopeTypeEnum? scopeType) =>
      _$this._scopeType = scopeType;

  String? _scopeId;
  String? get scopeId => _$this._scopeId;
  set scopeId(String? scopeId) => _$this._scopeId = scopeId;

  RoleGrantSummaryBuilder() {
    RoleGrantSummary._defaults(this);
  }

  RoleGrantSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _roleKey = $v.roleKey;
      _scopeType = $v.scopeType;
      _scopeId = $v.scopeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoleGrantSummary other) {
    _$v = other as _$RoleGrantSummary;
  }

  @override
  void update(void Function(RoleGrantSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoleGrantSummary build() => _build();

  _$RoleGrantSummary _build() {
    final _$result = _$v ??
        _$RoleGrantSummary._(
          roleKey: BuiltValueNullFieldError.checkNotNull(
              roleKey, r'RoleGrantSummary', 'roleKey'),
          scopeType: BuiltValueNullFieldError.checkNotNull(
              scopeType, r'RoleGrantSummary', 'scopeType'),
          scopeId: scopeId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
