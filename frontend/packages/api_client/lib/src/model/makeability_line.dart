//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/match_quality.dart';
import 'package:api_client/src/model/requirement.dart';
import 'package:api_client/src/model/satisfied_by.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'makeability_line.g.dart';

/// MakeabilityLine
///
/// Properties:
/// * [requirement] 
/// * [matchQuality] 
/// * [satisfiedBy] 
@BuiltValue()
abstract class MakeabilityLine implements Built<MakeabilityLine, MakeabilityLineBuilder> {
  @BuiltValueField(wireName: r'requirement')
  Requirement get requirement;

  @BuiltValueField(wireName: r'matchQuality')
  MatchQuality get matchQuality;
  // enum matchQualityEnum {  exact-product,  class-satisfied,  substitution,  missing,  };

  @BuiltValueField(wireName: r'satisfiedBy')
  SatisfiedBy? get satisfiedBy;

  MakeabilityLine._();

  factory MakeabilityLine([void updates(MakeabilityLineBuilder b)]) = _$MakeabilityLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MakeabilityLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MakeabilityLine> get serializer => _$MakeabilityLineSerializer();
}

class _$MakeabilityLineSerializer implements PrimitiveSerializer<MakeabilityLine> {
  @override
  final Iterable<Type> types = const [MakeabilityLine, _$MakeabilityLine];

  @override
  final String wireName = r'MakeabilityLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MakeabilityLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'requirement';
    yield serializers.serialize(
      object.requirement,
      specifiedType: const FullType(Requirement),
    );
    yield r'matchQuality';
    yield serializers.serialize(
      object.matchQuality,
      specifiedType: const FullType(MatchQuality),
    );
    yield r'satisfiedBy';
    yield object.satisfiedBy == null ? null : serializers.serialize(
      object.satisfiedBy,
      specifiedType: const FullType.nullable(SatisfiedBy),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MakeabilityLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MakeabilityLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'requirement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Requirement),
          ) as Requirement;
          result.requirement.replace(valueDes);
          break;
        case r'matchQuality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MatchQuality),
          ) as MatchQuality;
          result.matchQuality = valueDes;
          break;
        case r'satisfiedBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SatisfiedBy),
          ) as SatisfiedBy?;
          if (valueDes == null) continue;
          result.satisfiedBy.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MakeabilityLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MakeabilityLineBuilder();
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

