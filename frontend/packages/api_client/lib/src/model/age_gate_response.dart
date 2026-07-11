//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'age_gate_response.g.dart';

/// AgeGateResponse
///
/// Properties:
/// * [surfaceStrictness] 
/// * [jurisdictionCode] - Resolved jurisdiction code, or \"default\" when unresolved.
/// * [legalDrinkingAge] 
/// * [strictestRuleApplied] - True when the jurisdiction was unresolved or no jurisdiction-specific rule matched.
@BuiltValue()
abstract class AgeGateResponse implements Built<AgeGateResponse, AgeGateResponseBuilder> {
  @BuiltValueField(wireName: r'surfaceStrictness')
  AgeGateResponseSurfaceStrictnessEnum get surfaceStrictness;
  // enum surfaceStrictnessEnum {  off,  soft,  mandatory,  };

  /// Resolved jurisdiction code, or \"default\" when unresolved.
  @BuiltValueField(wireName: r'jurisdictionCode')
  String get jurisdictionCode;

  @BuiltValueField(wireName: r'legalDrinkingAge')
  int get legalDrinkingAge;

  /// True when the jurisdiction was unresolved or no jurisdiction-specific rule matched.
  @BuiltValueField(wireName: r'strictestRuleApplied')
  bool get strictestRuleApplied;

  AgeGateResponse._();

  factory AgeGateResponse([void updates(AgeGateResponseBuilder b)]) = _$AgeGateResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AgeGateResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AgeGateResponse> get serializer => _$AgeGateResponseSerializer();
}

class _$AgeGateResponseSerializer implements PrimitiveSerializer<AgeGateResponse> {
  @override
  final Iterable<Type> types = const [AgeGateResponse, _$AgeGateResponse];

  @override
  final String wireName = r'AgeGateResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AgeGateResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'surfaceStrictness';
    yield serializers.serialize(
      object.surfaceStrictness,
      specifiedType: const FullType(AgeGateResponseSurfaceStrictnessEnum),
    );
    yield r'jurisdictionCode';
    yield serializers.serialize(
      object.jurisdictionCode,
      specifiedType: const FullType(String),
    );
    yield r'legalDrinkingAge';
    yield serializers.serialize(
      object.legalDrinkingAge,
      specifiedType: const FullType(int),
    );
    yield r'strictestRuleApplied';
    yield serializers.serialize(
      object.strictestRuleApplied,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AgeGateResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AgeGateResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'surfaceStrictness':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AgeGateResponseSurfaceStrictnessEnum),
          ) as AgeGateResponseSurfaceStrictnessEnum;
          result.surfaceStrictness = valueDes;
          break;
        case r'jurisdictionCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.jurisdictionCode = valueDes;
          break;
        case r'legalDrinkingAge':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.legalDrinkingAge = valueDes;
          break;
        case r'strictestRuleApplied':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.strictestRuleApplied = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AgeGateResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AgeGateResponseBuilder();
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

class AgeGateResponseSurfaceStrictnessEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'off')
  static const AgeGateResponseSurfaceStrictnessEnum off = _$ageGateResponseSurfaceStrictnessEnum_off;
  @BuiltValueEnumConst(wireName: r'soft')
  static const AgeGateResponseSurfaceStrictnessEnum soft = _$ageGateResponseSurfaceStrictnessEnum_soft;
  @BuiltValueEnumConst(wireName: r'mandatory')
  static const AgeGateResponseSurfaceStrictnessEnum mandatory = _$ageGateResponseSurfaceStrictnessEnum_mandatory;

  static Serializer<AgeGateResponseSurfaceStrictnessEnum> get serializer => _$ageGateResponseSurfaceStrictnessEnumSerializer;

  const AgeGateResponseSurfaceStrictnessEnum._(String name): super(name);

  static BuiltSet<AgeGateResponseSurfaceStrictnessEnum> get values => _$ageGateResponseSurfaceStrictnessEnumValues;
  static AgeGateResponseSurfaceStrictnessEnum valueOf(String name) => _$ageGateResponseSurfaceStrictnessEnumValueOf(name);
}

