//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_result.g.dart';

/// SearchResult
///
/// Properties:
/// * [entityType] 
/// * [entityId] 
/// * [title] 
/// * [snippet] 
/// * [score] 
@BuiltValue()
abstract class SearchResult implements Built<SearchResult, SearchResultBuilder> {
  @BuiltValueField(wireName: r'entityType')
  SearchResultEntityTypeEnum get entityType;
  // enum entityTypeEnum {  recipe,  ingredient,  equipment,  glossaryTerm,  article,  };

  @BuiltValueField(wireName: r'entityId')
  String get entityId;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'snippet')
  String? get snippet;

  @BuiltValueField(wireName: r'score')
  num get score;

  SearchResult._();

  factory SearchResult([void updates(SearchResultBuilder b)]) = _$SearchResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchResult> get serializer => _$SearchResultSerializer();
}

class _$SearchResultSerializer implements PrimitiveSerializer<SearchResult> {
  @override
  final Iterable<Type> types = const [SearchResult, _$SearchResult];

  @override
  final String wireName = r'SearchResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entityType';
    yield serializers.serialize(
      object.entityType,
      specifiedType: const FullType(SearchResultEntityTypeEnum),
    );
    yield r'entityId';
    yield serializers.serialize(
      object.entityId,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    if (object.snippet != null) {
      yield r'snippet';
      yield serializers.serialize(
        object.snippet,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'score';
    yield serializers.serialize(
      object.score,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'entityType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SearchResultEntityTypeEnum),
          ) as SearchResultEntityTypeEnum;
          result.entityType = valueDes;
          break;
        case r'entityId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.entityId = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'snippet':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.snippet = valueDes;
          break;
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.score = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchResultBuilder();
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

class SearchResultEntityTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'recipe')
  static const SearchResultEntityTypeEnum recipe = _$searchResultEntityTypeEnum_recipe;
  @BuiltValueEnumConst(wireName: r'ingredient')
  static const SearchResultEntityTypeEnum ingredient = _$searchResultEntityTypeEnum_ingredient;
  @BuiltValueEnumConst(wireName: r'equipment')
  static const SearchResultEntityTypeEnum equipment = _$searchResultEntityTypeEnum_equipment;
  @BuiltValueEnumConst(wireName: r'glossaryTerm')
  static const SearchResultEntityTypeEnum glossaryTerm = _$searchResultEntityTypeEnum_glossaryTerm;
  @BuiltValueEnumConst(wireName: r'article')
  static const SearchResultEntityTypeEnum article = _$searchResultEntityTypeEnum_article;

  static Serializer<SearchResultEntityTypeEnum> get serializer => _$searchResultEntityTypeEnumSerializer;

  const SearchResultEntityTypeEnum._(String name): super(name);

  static BuiltSet<SearchResultEntityTypeEnum> get values => _$searchResultEntityTypeEnumValues;
  static SearchResultEntityTypeEnum valueOf(String name) => _$searchResultEntityTypeEnumValueOf(name);
}

