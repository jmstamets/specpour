//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'match_quality.g.dart';

class MatchQuality extends EnumClass {

  /// statement §2's ladder, tightest to loosest. Extensible from day one — T201's facet-partial slots in later as a new value, never a shape change.
  @BuiltValueEnumConst(wireName: r'exact-product')
  static const MatchQuality exactProduct = _$exactProduct;
  /// statement §2's ladder, tightest to loosest. Extensible from day one — T201's facet-partial slots in later as a new value, never a shape change.
  @BuiltValueEnumConst(wireName: r'class-satisfied')
  static const MatchQuality classSatisfied = _$classSatisfied;
  /// statement §2's ladder, tightest to loosest. Extensible from day one — T201's facet-partial slots in later as a new value, never a shape change.
  @BuiltValueEnumConst(wireName: r'substitution')
  static const MatchQuality substitution = _$substitution;
  /// statement §2's ladder, tightest to loosest. Extensible from day one — T201's facet-partial slots in later as a new value, never a shape change.
  @BuiltValueEnumConst(wireName: r'missing')
  static const MatchQuality missing = _$missing;

  static Serializer<MatchQuality> get serializer => _$matchQualitySerializer;

  const MatchQuality._(String name): super(name);

  static BuiltSet<MatchQuality> get values => _$values;
  static MatchQuality valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MatchQualityMixin = Object with _$MatchQualityMixin;

