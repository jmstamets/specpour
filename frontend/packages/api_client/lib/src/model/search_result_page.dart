//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/search_result.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_result_page.g.dart';

/// SearchResultPage
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class SearchResultPage implements Built<SearchResultPage, SearchResultPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<SearchResult> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  SearchResultPage._();

  factory SearchResultPage([void updates(SearchResultPageBuilder b)]) = _$SearchResultPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchResultPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchResultPage> get serializer => _$SearchResultPageSerializer();
}

class _$SearchResultPageSerializer implements PrimitiveSerializer<SearchResultPage> {
  @override
  final Iterable<Type> types = const [SearchResultPage, _$SearchResultPage];

  @override
  final String wireName = r'SearchResultPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchResultPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(SearchResult)]),
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
    SearchResultPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchResultPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchResult)]),
          ) as BuiltList<SearchResult>;
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
  SearchResultPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchResultPageBuilder();
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

