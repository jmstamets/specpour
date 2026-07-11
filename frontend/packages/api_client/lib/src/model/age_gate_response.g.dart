// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'age_gate_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AgeGateResponseSurfaceStrictnessEnum
    _$ageGateResponseSurfaceStrictnessEnum_off =
    const AgeGateResponseSurfaceStrictnessEnum._('off');
const AgeGateResponseSurfaceStrictnessEnum
    _$ageGateResponseSurfaceStrictnessEnum_soft =
    const AgeGateResponseSurfaceStrictnessEnum._('soft');
const AgeGateResponseSurfaceStrictnessEnum
    _$ageGateResponseSurfaceStrictnessEnum_mandatory =
    const AgeGateResponseSurfaceStrictnessEnum._('mandatory');

AgeGateResponseSurfaceStrictnessEnum
    _$ageGateResponseSurfaceStrictnessEnumValueOf(String name) {
  switch (name) {
    case 'off':
      return _$ageGateResponseSurfaceStrictnessEnum_off;
    case 'soft':
      return _$ageGateResponseSurfaceStrictnessEnum_soft;
    case 'mandatory':
      return _$ageGateResponseSurfaceStrictnessEnum_mandatory;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AgeGateResponseSurfaceStrictnessEnum>
    _$ageGateResponseSurfaceStrictnessEnumValues = BuiltSet<
        AgeGateResponseSurfaceStrictnessEnum>(const <AgeGateResponseSurfaceStrictnessEnum>[
  _$ageGateResponseSurfaceStrictnessEnum_off,
  _$ageGateResponseSurfaceStrictnessEnum_soft,
  _$ageGateResponseSurfaceStrictnessEnum_mandatory,
]);

Serializer<AgeGateResponseSurfaceStrictnessEnum>
    _$ageGateResponseSurfaceStrictnessEnumSerializer =
    _$AgeGateResponseSurfaceStrictnessEnumSerializer();

class _$AgeGateResponseSurfaceStrictnessEnumSerializer
    implements PrimitiveSerializer<AgeGateResponseSurfaceStrictnessEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'off': 'off',
    'soft': 'soft',
    'mandatory': 'mandatory',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'off': 'off',
    'soft': 'soft',
    'mandatory': 'mandatory',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AgeGateResponseSurfaceStrictnessEnum
  ];
  @override
  final String wireName = 'AgeGateResponseSurfaceStrictnessEnum';

  @override
  Object serialize(
          Serializers serializers, AgeGateResponseSurfaceStrictnessEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AgeGateResponseSurfaceStrictnessEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AgeGateResponseSurfaceStrictnessEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AgeGateResponse extends AgeGateResponse {
  @override
  final AgeGateResponseSurfaceStrictnessEnum surfaceStrictness;
  @override
  final String jurisdictionCode;
  @override
  final int legalDrinkingAge;
  @override
  final bool strictestRuleApplied;

  factory _$AgeGateResponse([void Function(AgeGateResponseBuilder)? updates]) =>
      (AgeGateResponseBuilder()..update(updates))._build();

  _$AgeGateResponse._(
      {required this.surfaceStrictness,
      required this.jurisdictionCode,
      required this.legalDrinkingAge,
      required this.strictestRuleApplied})
      : super._();
  @override
  AgeGateResponse rebuild(void Function(AgeGateResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgeGateResponseBuilder toBuilder() => AgeGateResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgeGateResponse &&
        surfaceStrictness == other.surfaceStrictness &&
        jurisdictionCode == other.jurisdictionCode &&
        legalDrinkingAge == other.legalDrinkingAge &&
        strictestRuleApplied == other.strictestRuleApplied;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, surfaceStrictness.hashCode);
    _$hash = $jc(_$hash, jurisdictionCode.hashCode);
    _$hash = $jc(_$hash, legalDrinkingAge.hashCode);
    _$hash = $jc(_$hash, strictestRuleApplied.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AgeGateResponse')
          ..add('surfaceStrictness', surfaceStrictness)
          ..add('jurisdictionCode', jurisdictionCode)
          ..add('legalDrinkingAge', legalDrinkingAge)
          ..add('strictestRuleApplied', strictestRuleApplied))
        .toString();
  }
}

class AgeGateResponseBuilder
    implements Builder<AgeGateResponse, AgeGateResponseBuilder> {
  _$AgeGateResponse? _$v;

  AgeGateResponseSurfaceStrictnessEnum? _surfaceStrictness;
  AgeGateResponseSurfaceStrictnessEnum? get surfaceStrictness =>
      _$this._surfaceStrictness;
  set surfaceStrictness(
          AgeGateResponseSurfaceStrictnessEnum? surfaceStrictness) =>
      _$this._surfaceStrictness = surfaceStrictness;

  String? _jurisdictionCode;
  String? get jurisdictionCode => _$this._jurisdictionCode;
  set jurisdictionCode(String? jurisdictionCode) =>
      _$this._jurisdictionCode = jurisdictionCode;

  int? _legalDrinkingAge;
  int? get legalDrinkingAge => _$this._legalDrinkingAge;
  set legalDrinkingAge(int? legalDrinkingAge) =>
      _$this._legalDrinkingAge = legalDrinkingAge;

  bool? _strictestRuleApplied;
  bool? get strictestRuleApplied => _$this._strictestRuleApplied;
  set strictestRuleApplied(bool? strictestRuleApplied) =>
      _$this._strictestRuleApplied = strictestRuleApplied;

  AgeGateResponseBuilder() {
    AgeGateResponse._defaults(this);
  }

  AgeGateResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _surfaceStrictness = $v.surfaceStrictness;
      _jurisdictionCode = $v.jurisdictionCode;
      _legalDrinkingAge = $v.legalDrinkingAge;
      _strictestRuleApplied = $v.strictestRuleApplied;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgeGateResponse other) {
    _$v = other as _$AgeGateResponse;
  }

  @override
  void update(void Function(AgeGateResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AgeGateResponse build() => _build();

  _$AgeGateResponse _build() {
    final _$result = _$v ??
        _$AgeGateResponse._(
          surfaceStrictness: BuiltValueNullFieldError.checkNotNull(
              surfaceStrictness, r'AgeGateResponse', 'surfaceStrictness'),
          jurisdictionCode: BuiltValueNullFieldError.checkNotNull(
              jurisdictionCode, r'AgeGateResponse', 'jurisdictionCode'),
          legalDrinkingAge: BuiltValueNullFieldError.checkNotNull(
              legalDrinkingAge, r'AgeGateResponse', 'legalDrinkingAge'),
          strictestRuleApplied: BuiltValueNullFieldError.checkNotNull(
              strictestRuleApplied, r'AgeGateResponse', 'strictestRuleApplied'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
