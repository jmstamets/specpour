//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'glossary_article_summary.g.dart';

/// GlossaryArticleSummary
///
/// Properties:
/// * [id] 
/// * [title] 
@BuiltValue()
abstract class GlossaryArticleSummary implements Built<GlossaryArticleSummary, GlossaryArticleSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'title')
  String get title;

  GlossaryArticleSummary._();

  factory GlossaryArticleSummary([void updates(GlossaryArticleSummaryBuilder b)]) = _$GlossaryArticleSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GlossaryArticleSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GlossaryArticleSummary> get serializer => _$GlossaryArticleSummarySerializer();
}

class _$GlossaryArticleSummarySerializer implements PrimitiveSerializer<GlossaryArticleSummary> {
  @override
  final Iterable<Type> types = const [GlossaryArticleSummary, _$GlossaryArticleSummary];

  @override
  final String wireName = r'GlossaryArticleSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GlossaryArticleSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GlossaryArticleSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GlossaryArticleSummaryBuilder result,
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
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GlossaryArticleSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GlossaryArticleSummaryBuilder();
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

