//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/recipe_summary.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_page.g.dart';

/// RecipePage
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class RecipePage implements Built<RecipePage, RecipePageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<RecipeSummary> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  RecipePage._();

  factory RecipePage([void updates(RecipePageBuilder b)]) = _$RecipePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipePage> get serializer => _$RecipePageSerializer();
}

class _$RecipePageSerializer implements PrimitiveSerializer<RecipePage> {
  @override
  final Iterable<Type> types = const [RecipePage, _$RecipePage];

  @override
  final String wireName = r'RecipePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(RecipeSummary)]),
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
    RecipePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecipePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RecipeSummary)]),
          ) as BuiltList<RecipeSummary>;
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
  RecipePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipePageBuilder();
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

