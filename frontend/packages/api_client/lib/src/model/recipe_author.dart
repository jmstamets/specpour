//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/recipe_ingredient_line.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_author.g.dart';

/// RecipeAuthor
///
/// Properties:
/// * [id] 
/// * [primaryName] 
/// * [alternateNames] 
/// * [libraryScope] 
/// * [venueId] 
/// * [instructions] 
/// * [ingredientLines] 
/// * [categoryIds] 
/// * [tags] 
/// * [visibility] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class RecipeAuthor implements Built<RecipeAuthor, RecipeAuthorBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'primaryName')
  String get primaryName;

  @BuiltValueField(wireName: r'alternateNames')
  BuiltList<String> get alternateNames;

  @BuiltValueField(wireName: r'libraryScope')
  RecipeAuthorLibraryScopeEnum get libraryScope;
  // enum libraryScopeEnum {  personal,  bar,  };

  @BuiltValueField(wireName: r'venueId')
  String? get venueId;

  @BuiltValueField(wireName: r'instructions')
  BuiltList<String> get instructions;

  @BuiltValueField(wireName: r'ingredientLines')
  BuiltList<RecipeIngredientLine> get ingredientLines;

  @BuiltValueField(wireName: r'categoryIds')
  BuiltList<String> get categoryIds;

  @BuiltValueField(wireName: r'tags')
  BuiltList<String> get tags;

  @BuiltValueField(wireName: r'visibility')
  RecipeAuthorVisibilityEnum get visibility;
  // enum visibilityEnum {  private,  public,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  RecipeAuthor._();

  factory RecipeAuthor([void updates(RecipeAuthorBuilder b)]) = _$RecipeAuthor;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeAuthorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeAuthor> get serializer => _$RecipeAuthorSerializer();
}

class _$RecipeAuthorSerializer implements PrimitiveSerializer<RecipeAuthor> {
  @override
  final Iterable<Type> types = const [RecipeAuthor, _$RecipeAuthor];

  @override
  final String wireName = r'RecipeAuthor';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeAuthor object, {
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
    yield r'alternateNames';
    yield serializers.serialize(
      object.alternateNames,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'libraryScope';
    yield serializers.serialize(
      object.libraryScope,
      specifiedType: const FullType(RecipeAuthorLibraryScopeEnum),
    );
    if (object.venueId != null) {
      yield r'venueId';
      yield serializers.serialize(
        object.venueId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'instructions';
    yield serializers.serialize(
      object.instructions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'ingredientLines';
    yield serializers.serialize(
      object.ingredientLines,
      specifiedType: const FullType(BuiltList, [FullType(RecipeIngredientLine)]),
    );
    yield r'categoryIds';
    yield serializers.serialize(
      object.categoryIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'tags';
    yield serializers.serialize(
      object.tags,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'visibility';
    yield serializers.serialize(
      object.visibility,
      specifiedType: const FullType(RecipeAuthorVisibilityEnum),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeAuthor object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecipeAuthorBuilder result,
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
        case r'alternateNames':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.alternateNames.replace(valueDes);
          break;
        case r'libraryScope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RecipeAuthorLibraryScopeEnum),
          ) as RecipeAuthorLibraryScopeEnum;
          result.libraryScope = valueDes;
          break;
        case r'venueId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.venueId = valueDes;
          break;
        case r'instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.instructions.replace(valueDes);
          break;
        case r'ingredientLines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RecipeIngredientLine)]),
          ) as BuiltList<RecipeIngredientLine>;
          result.ingredientLines.replace(valueDes);
          break;
        case r'categoryIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.categoryIds.replace(valueDes);
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.tags.replace(valueDes);
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RecipeAuthorVisibilityEnum),
          ) as RecipeAuthorVisibilityEnum;
          result.visibility = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeAuthor deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeAuthorBuilder();
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

class RecipeAuthorLibraryScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'personal')
  static const RecipeAuthorLibraryScopeEnum personal = _$recipeAuthorLibraryScopeEnum_personal;
  @BuiltValueEnumConst(wireName: r'bar')
  static const RecipeAuthorLibraryScopeEnum bar = _$recipeAuthorLibraryScopeEnum_bar;

  static Serializer<RecipeAuthorLibraryScopeEnum> get serializer => _$recipeAuthorLibraryScopeEnumSerializer;

  const RecipeAuthorLibraryScopeEnum._(String name): super(name);

  static BuiltSet<RecipeAuthorLibraryScopeEnum> get values => _$recipeAuthorLibraryScopeEnumValues;
  static RecipeAuthorLibraryScopeEnum valueOf(String name) => _$recipeAuthorLibraryScopeEnumValueOf(name);
}

class RecipeAuthorVisibilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'private')
  static const RecipeAuthorVisibilityEnum private = _$recipeAuthorVisibilityEnum_private;
  @BuiltValueEnumConst(wireName: r'public')
  static const RecipeAuthorVisibilityEnum public = _$recipeAuthorVisibilityEnum_public;

  static Serializer<RecipeAuthorVisibilityEnum> get serializer => _$recipeAuthorVisibilityEnumSerializer;

  const RecipeAuthorVisibilityEnum._(String name): super(name);

  static BuiltSet<RecipeAuthorVisibilityEnum> get values => _$recipeAuthorVisibilityEnumValues;
  static RecipeAuthorVisibilityEnum valueOf(String name) => _$recipeAuthorVisibilityEnumValueOf(name);
}

