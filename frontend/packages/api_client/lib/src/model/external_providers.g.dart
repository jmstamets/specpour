// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_providers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ExternalProvidersProvidersEnum _$externalProvidersProvidersEnum_google =
    const ExternalProvidersProvidersEnum._('google');
const ExternalProvidersProvidersEnum _$externalProvidersProvidersEnum_apple =
    const ExternalProvidersProvidersEnum._('apple');
const ExternalProvidersProvidersEnum
    _$externalProvidersProvidersEnum_microsoft =
    const ExternalProvidersProvidersEnum._('microsoft');

ExternalProvidersProvidersEnum _$externalProvidersProvidersEnumValueOf(
    String name) {
  switch (name) {
    case 'google':
      return _$externalProvidersProvidersEnum_google;
    case 'apple':
      return _$externalProvidersProvidersEnum_apple;
    case 'microsoft':
      return _$externalProvidersProvidersEnum_microsoft;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ExternalProvidersProvidersEnum>
    _$externalProvidersProvidersEnumValues = BuiltSet<
        ExternalProvidersProvidersEnum>(const <ExternalProvidersProvidersEnum>[
  _$externalProvidersProvidersEnum_google,
  _$externalProvidersProvidersEnum_apple,
  _$externalProvidersProvidersEnum_microsoft,
]);

Serializer<ExternalProvidersProvidersEnum>
    _$externalProvidersProvidersEnumSerializer =
    _$ExternalProvidersProvidersEnumSerializer();

class _$ExternalProvidersProvidersEnumSerializer
    implements PrimitiveSerializer<ExternalProvidersProvidersEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'google': 'google',
    'apple': 'apple',
    'microsoft': 'microsoft',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'google': 'google',
    'apple': 'apple',
    'microsoft': 'microsoft',
  };

  @override
  final Iterable<Type> types = const <Type>[ExternalProvidersProvidersEnum];
  @override
  final String wireName = 'ExternalProvidersProvidersEnum';

  @override
  Object serialize(
          Serializers serializers, ExternalProvidersProvidersEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ExternalProvidersProvidersEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ExternalProvidersProvidersEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ExternalProviders extends ExternalProviders {
  @override
  final BuiltList<ExternalProvidersProvidersEnum> providers;

  factory _$ExternalProviders(
          [void Function(ExternalProvidersBuilder)? updates]) =>
      (ExternalProvidersBuilder()..update(updates))._build();

  _$ExternalProviders._({required this.providers}) : super._();
  @override
  ExternalProviders rebuild(void Function(ExternalProvidersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExternalProvidersBuilder toBuilder() =>
      ExternalProvidersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExternalProviders && providers == other.providers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, providers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExternalProviders')
          ..add('providers', providers))
        .toString();
  }
}

class ExternalProvidersBuilder
    implements Builder<ExternalProviders, ExternalProvidersBuilder> {
  _$ExternalProviders? _$v;

  ListBuilder<ExternalProvidersProvidersEnum>? _providers;
  ListBuilder<ExternalProvidersProvidersEnum> get providers =>
      _$this._providers ??= ListBuilder<ExternalProvidersProvidersEnum>();
  set providers(ListBuilder<ExternalProvidersProvidersEnum>? providers) =>
      _$this._providers = providers;

  ExternalProvidersBuilder() {
    ExternalProviders._defaults(this);
  }

  ExternalProvidersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _providers = $v.providers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExternalProviders other) {
    _$v = other as _$ExternalProviders;
  }

  @override
  void update(void Function(ExternalProvidersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExternalProviders build() => _build();

  _$ExternalProviders _build() {
    _$ExternalProviders _$result;
    try {
      _$result = _$v ??
          _$ExternalProviders._(
            providers: providers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'providers';
        providers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ExternalProviders', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
