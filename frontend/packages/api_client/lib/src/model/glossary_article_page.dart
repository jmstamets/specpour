//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/glossary_article_summary.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'glossary_article_page.g.dart';

/// GlossaryArticlePage
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class GlossaryArticlePage implements Built<GlossaryArticlePage, GlossaryArticlePageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<GlossaryArticleSummary> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  GlossaryArticlePage._();

  factory GlossaryArticlePage([void updates(GlossaryArticlePageBuilder b)]) = _$GlossaryArticlePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GlossaryArticlePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GlossaryArticlePage> get serializer => _$GlossaryArticlePageSerializer();
}

class _$GlossaryArticlePageSerializer implements PrimitiveSerializer<GlossaryArticlePage> {
  @override
  final Iterable<Type> types = const [GlossaryArticlePage, _$GlossaryArticlePage];

  @override
  final String wireName = r'GlossaryArticlePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GlossaryArticlePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(GlossaryArticleSummary)]),
    );
    if (object.nextCursor != null) {
      yield r'nextCursor';
      yield serializers.serialize(
        object.nextCursor,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GlossaryArticlePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GlossaryArticlePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GlossaryArticleSummary)]),
          ) as BuiltList<GlossaryArticleSummary>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GlossaryArticlePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GlossaryArticlePageBuilder();
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

