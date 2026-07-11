// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_manifest.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EntitlementManifest extends EntitlementManifest {
  @override
  final String tier;
  @override
  final BuiltList<String> capabilities;
  @override
  final BuiltList<RoleGrantSummary> roles;

  factory _$EntitlementManifest(
          [void Function(EntitlementManifestBuilder)? updates]) =>
      (EntitlementManifestBuilder()..update(updates))._build();

  _$EntitlementManifest._(
      {required this.tier, required this.capabilities, required this.roles})
      : super._();
  @override
  EntitlementManifest rebuild(
          void Function(EntitlementManifestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EntitlementManifestBuilder toBuilder() =>
      EntitlementManifestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntitlementManifest &&
        tier == other.tier &&
        capabilities == other.capabilities &&
        roles == other.roles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, capabilities.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EntitlementManifest')
          ..add('tier', tier)
          ..add('capabilities', capabilities)
          ..add('roles', roles))
        .toString();
  }
}

class EntitlementManifestBuilder
    implements Builder<EntitlementManifest, EntitlementManifestBuilder> {
  _$EntitlementManifest? _$v;

  String? _tier;
  String? get tier => _$this._tier;
  set tier(String? tier) => _$this._tier = tier;

  ListBuilder<String>? _capabilities;
  ListBuilder<String> get capabilities =>
      _$this._capabilities ??= ListBuilder<String>();
  set capabilities(ListBuilder<String>? capabilities) =>
      _$this._capabilities = capabilities;

  ListBuilder<RoleGrantSummary>? _roles;
  ListBuilder<RoleGrantSummary> get roles =>
      _$this._roles ??= ListBuilder<RoleGrantSummary>();
  set roles(ListBuilder<RoleGrantSummary>? roles) => _$this._roles = roles;

  EntitlementManifestBuilder() {
    EntitlementManifest._defaults(this);
  }

  EntitlementManifestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tier = $v.tier;
      _capabilities = $v.capabilities.toBuilder();
      _roles = $v.roles.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntitlementManifest other) {
    _$v = other as _$EntitlementManifest;
  }

  @override
  void update(void Function(EntitlementManifestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EntitlementManifest build() => _build();

  _$EntitlementManifest _build() {
    _$EntitlementManifest _$result;
    try {
      _$result = _$v ??
          _$EntitlementManifest._(
            tier: BuiltValueNullFieldError.checkNotNull(
                tier, r'EntitlementManifest', 'tier'),
            capabilities: capabilities.build(),
            roles: roles.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'capabilities';
        capabilities.build();
        _$failedField = 'roles';
        roles.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'EntitlementManifest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
