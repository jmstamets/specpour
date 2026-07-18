//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/recipe_ingredient_line_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_recipe_request.g.dart';

/// T058, FR-018. libraryScope \"bar\" requires venueId, verified as owned by the caller (403 otherwise). Newly authored recipes always start private (FR-008b) — publishing is a separate, not-yet-built flow.
///
/// Properties:
/// * [primaryName] 
/// * [alternateNames] 
/// * [libraryScope] 
/// * [venueId] 
/// * [instructions] 
/// * [ingredientLines] 
/// * [categoryIds] 
/// * [tags] 
@BuiltValue()
abstract class CreateRecipeRequest implements Built<CreateRecipeRequest, CreateRecipeRequestBuilder> {
  @BuiltValueField(wireName: r'primaryName')
  String get primaryName;

  @BuiltValueField(wireName: r'alternateNames')
  BuiltList<String>? get alternateNames;

  @BuiltValueField(wireName: r'libraryScope')
  CreateRecipeRequestLibraryScopeEnum get libraryScope;
  // enum libraryScopeEnum {  personal,  bar,  };

  @BuiltValueField(wireName: r'venueId')
  String? get venueId;

  @BuiltValueField(wireName: r'instructions')
  BuiltList<String>? get instructions;

  @BuiltValueField(wireName: r'ingredientLines')
  BuiltList<RecipeIngredientLineInput>? get ingredientLines;

  @BuiltValueField(wireName: r'categoryIds')
  BuiltList<String>? get categoryIds;

  @BuiltValueField(wireName: r'tags')
  BuiltList<String>? get tags;

  CreateRecipeRequest._();

  factory CreateRecipeRequest([void updates(CreateRecipeRequestBuilder b)]) = _$CreateRecipeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateRecipeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateRecipeRequest> get serializer => _$CreateRecipeRequestSerializer();
}

class _$CreateRecipeRequestSerializer implements PrimitiveSerializer<CreateRecipeRequest> {
  @override
  final Iterable<Type> types = const [CreateRecipeRequest, _$CreateRecipeRequest];

  @override
  final String wireName = r'CreateRecipeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateRecipeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'primaryName';
    yield serializers.serialize(
      object.primaryName,
      specifiedType: const FullType(String),
    );
    if (object.alternateNames != null) {
      yield r'alternateNames';
      yield serializers.serialize(
        object.alternateNames,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    yield r'libraryScope';
    yield serializers.serialize(
      object.libraryScope,
      specifiedType: const FullType(CreateRecipeRequestLibraryScopeEnum),
    );
    if (object.venueId != null) {
      yield r'venueId';
      yield serializers.serialize(
        object.venueId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.instructions != null) {
      yield r'instructions';
      yield serializers.serialize(
        object.instructions,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    if (object.ingredientLines != null) {
      yield r'ingredientLines';
      yield serializers.serialize(
        object.ingredientLines,
        specifiedType: const FullType.nullable(BuiltList, [FullType(RecipeIngredientLineInput)]),
      );
    }
    if (object.categoryIds != null) {
      yield r'categoryIds';
      yield serializers.serialize(
        object.categoryIds,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    if (object.tags != null) {
      yield r'tags';
      yield serializers.serialize(
        object.tags,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateRecipeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateRecipeRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.alternateNames.replace(valueDes);
          break;
        case r'libraryScope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateRecipeRequestLibraryScopeEnum),
          ) as CreateRecipeRequestLibraryScopeEnum;
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
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.instructions.replace(valueDes);
          break;
        case r'ingredientLines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(RecipeIngredientLineInput)]),
          ) as BuiltList<RecipeIngredientLineInput>?;
          if (valueDes == null) continue;
          result.ingredientLines.replace(valueDes);
          break;
        case r'categoryIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.categoryIds.replace(valueDes);
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.tags.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateRecipeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateRecipeRequestBuilder();
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

class CreateRecipeRequestLibraryScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'personal')
  static const CreateRecipeRequestLibraryScopeEnum personal = _$createRecipeRequestLibraryScopeEnum_personal;
  @BuiltValueEnumConst(wireName: r'bar')
  static const CreateRecipeRequestLibraryScopeEnum bar = _$createRecipeRequestLibraryScopeEnum_bar;

  static Serializer<CreateRecipeRequestLibraryScopeEnum> get serializer => _$createRecipeRequestLibraryScopeEnumSerializer;

  const CreateRecipeRequestLibraryScopeEnum._(String name): super(name);

  static BuiltSet<CreateRecipeRequestLibraryScopeEnum> get values => _$createRecipeRequestLibraryScopeEnumValues;
  static CreateRecipeRequestLibraryScopeEnum valueOf(String name) => _$createRecipeRequestLibraryScopeEnumValueOf(name);
}

