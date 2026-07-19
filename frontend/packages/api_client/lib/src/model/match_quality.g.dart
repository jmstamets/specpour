// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_quality.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MatchQuality _$exactProduct = const MatchQuality._('exactProduct');
const MatchQuality _$classSatisfied = const MatchQuality._('classSatisfied');
const MatchQuality _$substitution = const MatchQuality._('substitution');
const MatchQuality _$missing = const MatchQuality._('missing');

MatchQuality _$valueOf(String name) {
  switch (name) {
    case 'exactProduct':
      return _$exactProduct;
    case 'classSatisfied':
      return _$classSatisfied;
    case 'substitution':
      return _$substitution;
    case 'missing':
      return _$missing;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MatchQuality> _$values =
    BuiltSet<MatchQuality>(const <MatchQuality>[
  _$exactProduct,
  _$classSatisfied,
  _$substitution,
  _$missing,
]);

class _$MatchQualityMeta {
  const _$MatchQualityMeta();
  MatchQuality get exactProduct => _$exactProduct;
  MatchQuality get classSatisfied => _$classSatisfied;
  MatchQuality get substitution => _$substitution;
  MatchQuality get missing => _$missing;
  MatchQuality valueOf(String name) => _$valueOf(name);
  BuiltSet<MatchQuality> get values => _$values;
}

abstract class _$MatchQualityMixin {
  // ignore: non_constant_identifier_names
  _$MatchQualityMeta get MatchQuality => const _$MatchQualityMeta();
}

Serializer<MatchQuality> _$matchQualitySerializer = _$MatchQualitySerializer();

class _$MatchQualitySerializer implements PrimitiveSerializer<MatchQuality> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'exactProduct': 'exact-product',
    'classSatisfied': 'class-satisfied',
    'substitution': 'substitution',
    'missing': 'missing',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'exact-product': 'exactProduct',
    'class-satisfied': 'classSatisfied',
    'substitution': 'substitution',
    'missing': 'missing',
  };

  @override
  final Iterable<Type> types = const <Type>[MatchQuality];
  @override
  final String wireName = 'MatchQuality';

  @override
  Object serialize(Serializers serializers, MatchQuality object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MatchQuality deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MatchQuality.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
