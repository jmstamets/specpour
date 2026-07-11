//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_summary.g.dart';

/// RecipeSummary
///
/// Properties:
/// * [id] 
/// * [primaryName] 
/// * [familyKey] 
@BuiltValue()
abstract class RecipeSummary implements Built<RecipeSummary, RecipeSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'primaryName')
  String get primaryName;

  @BuiltValueField(wireName: r'familyKey')
  String? get familyKey;

  RecipeSummary._();

  factory RecipeSummary([void updates(RecipeSummaryBuilder b)]) = _$RecipeSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeSummary> get serializer => _$RecipeSummarySerializer();
}

class _$RecipeSummarySerializer implements PrimitiveSerializer<RecipeSummary> {
  @override
  final Iterable<Type> types = const [RecipeSummary, _$RecipeSummary];

  @override
  final String wireName = r'RecipeSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'primaryName';
    yield serializers.serialize(
      object.primaryName,
      specifiedType: const FullType(String),
    );
    if (object.familyKey != null) {
      yield r'familyKey';
      yield serializers.serialize(
        object.familyKey,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecipeSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'primaryName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.primaryName = valueDes;
          break;
        case r'familyKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.familyKey = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeSummaryBuilder();
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

