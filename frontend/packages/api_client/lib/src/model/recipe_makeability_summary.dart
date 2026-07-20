//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/match_quality.dart';
import 'package:api_client/src/model/recipe_makeability_line.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_makeability_summary.g.dart';

/// matchQuality is a derived summary of lines (the loosest satisfied-line quality) — never independent truth. Null for near-miss entries (a near-miss has no single aggregate quality).
///
/// Properties:
/// * [isNearMiss] 
/// * [matchQuality] 
/// * [lines] 
@BuiltValue()
abstract class RecipeMakeabilitySummary implements Built<RecipeMakeabilitySummary, RecipeMakeabilitySummaryBuilder> {
  @BuiltValueField(wireName: r'isNearMiss')
  bool get isNearMiss;

  @BuiltValueField(wireName: r'matchQuality')
  MatchQuality? get matchQuality;
  // enum matchQualityEnum {  exact-product,  class-satisfied,  substitution,  missing,  };

  @BuiltValueField(wireName: r'lines')
  BuiltList<RecipeMakeabilityLine> get lines;

  RecipeMakeabilitySummary._();

  factory RecipeMakeabilitySummary([void updates(RecipeMakeabilitySummaryBuilder b)]) = _$RecipeMakeabilitySummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeMakeabilitySummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeMakeabilitySummary> get serializer => _$RecipeMakeabilitySummarySerializer();
}

class _$RecipeMakeabilitySummarySerializer implements PrimitiveSerializer<RecipeMakeabilitySummary> {
  @override
  final Iterable<Type> types = const [RecipeMakeabilitySummary, _$RecipeMakeabilitySummary];

  @override
  final String wireName = r'RecipeMakeabilitySummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeMakeabilitySummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'isNearMiss';
    yield serializers.serialize(
      object.isNearMiss,
      specifiedType: const FullType(bool),
    );
    yield r'matchQuality';
    yield object.matchQuality == null ? null : serializers.serialize(
      object.matchQuality,
      specifiedType: const FullType.nullable(MatchQuality),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(RecipeMakeabilityLine)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeMakeabilitySummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecipeMakeabilitySummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'isNearMiss':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isNearMiss = valueDes;
          break;
        case r'matchQuality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MatchQuality),
          ) as MatchQuality?;
          if (valueDes == null) continue;
          result.matchQuality = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RecipeMakeabilityLine)]),
          ) as BuiltList<RecipeMakeabilityLine>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeMakeabilitySummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeMakeabilitySummaryBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

