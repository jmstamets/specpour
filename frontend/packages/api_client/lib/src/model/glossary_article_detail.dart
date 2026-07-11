//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'glossary_article_detail.g.dart';

/// GlossaryArticleDetail
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [body] 
@BuiltValue()
abstract class GlossaryArticleDetail implements Built<GlossaryArticleDetail, GlossaryArticleDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'body')
  String get body;

  GlossaryArticleDetail._();

  factory GlossaryArticleDetail([void updates(GlossaryArticleDetailBuilder b)]) = _$GlossaryArticleDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GlossaryArticleDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GlossaryArticleDetail> get serializer => _$GlossaryArticleDetailSerializer();
}

class _$GlossaryArticleDetailSerializer implements PrimitiveSerializer<GlossaryArticleDetail> {
  @override
  final Iterable<Type> types = const [GlossaryArticleDetail, _$GlossaryArticleDetail];

  @override
  final String wireName = r'GlossaryArticleDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GlossaryArticleDetail object, {
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
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GlossaryArticleDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GlossaryArticleDetailBuilder result,
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
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GlossaryArticleDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GlossaryArticleDetailBuilder();
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

