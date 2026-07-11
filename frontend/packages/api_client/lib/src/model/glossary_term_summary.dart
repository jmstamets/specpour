//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'glossary_term_summary.g.dart';

/// GlossaryTermSummary
///
/// Properties:
/// * [id] 
/// * [term] 
@BuiltValue()
abstract class GlossaryTermSummary implements Built<GlossaryTermSummary, GlossaryTermSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'term')
  String get term;

  GlossaryTermSummary._();

  factory GlossaryTermSummary([void updates(GlossaryTermSummaryBuilder b)]) = _$GlossaryTermSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GlossaryTermSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GlossaryTermSummary> get serializer => _$GlossaryTermSummarySerializer();
}

class _$GlossaryTermSummarySerializer implements PrimitiveSerializer<GlossaryTermSummary> {
  @override
  final Iterable<Type> types = const [GlossaryTermSummary, _$GlossaryTermSummary];

  @override
  final String wireName = r'GlossaryTermSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GlossaryTermSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'term';
    yield serializers.serialize(
      object.term,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GlossaryTermSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GlossaryTermSummaryBuilder result,
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
        case r'term':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.term = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GlossaryTermSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GlossaryTermSummaryBuilder();
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

