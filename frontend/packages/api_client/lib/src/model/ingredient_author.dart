//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/house_made.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ingredient_author.g.dart';

/// IngredientAuthor
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [libraryScope] 
/// * [venueId] 
/// * [categoryId] 
/// * [parentId] 
/// * [abvPercent] 
/// * [sources] 
/// * [description] 
/// * [visibility] 
/// * [houseMade] 
@BuiltValue()
abstract class IngredientAuthor implements Built<IngredientAuthor, IngredientAuthorBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'libraryScope')
  IngredientAuthorLibraryScopeEnum get libraryScope;
  // enum libraryScopeEnum {  personal,  bar,  };

  @BuiltValueField(wireName: r'venueId')
  String? get venueId;

  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  @BuiltValueField(wireName: r'parentId')
  String? get parentId;

  @BuiltValueField(wireName: r'abvPercent')
  num? get abvPercent;

  @BuiltValueField(wireName: r'sources')
  BuiltList<String> get sources;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'visibility')
  IngredientAuthorVisibilityEnum get visibility;
  // enum visibilityEnum {  private,  public,  };

  @BuiltValueField(wireName: r'houseMade')
  HouseMade? get houseMade;

  IngredientAuthor._();

  factory IngredientAuthor([void updates(IngredientAuthorBuilder b)]) = _$IngredientAuthor;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IngredientAuthorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IngredientAuthor> get serializer => _$IngredientAuthorSerializer();
}

class _$IngredientAuthorSerializer implements PrimitiveSerializer<IngredientAuthor> {
  @override
  final Iterable<Type> types = const [IngredientAuthor, _$IngredientAuthor];

  @override
  final String wireName = r'IngredientAuthor';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IngredientAuthor object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'libraryScope';
    yield serializers.serialize(
      object.libraryScope,
      specifiedType: const FullType(IngredientAuthorLibraryScopeEnum),
    );
    if (object.venueId != null) {
      yield r'venueId';
      yield serializers.serialize(
        object.venueId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'categoryId';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    if (object.parentId != null) {
      yield r'parentId';
      yield serializers.serialize(
        object.parentId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.abvPercent != null) {
      yield r'abvPercent';
      yield serializers.serialize(
        object.abvPercent,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'sources';
    yield serializers.serialize(
      object.sources,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'visibility';
    yield serializers.serialize(
      object.visibility,
      specifiedType: const FullType(IngredientAuthorVisibilityEnum),
    );
    if (object.houseMade != null) {
      yield r'houseMade';
      yield serializers.serialize(
        object.houseMade,
        specifiedType: const FullType.nullable(HouseMade),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    IngredientAuthor object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IngredientAuthorBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'libraryScope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(IngredientAuthorLibraryScopeEnum),
          ) as IngredientAuthorLibraryScopeEnum;
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
        case r'categoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryId = valueDes;
          break;
        case r'parentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        case r'abvPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.abvPercent = valueDes;
          break;
        case r'sources':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.sources.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(IngredientAuthorVisibilityEnum),
          ) as IngredientAuthorVisibilityEnum;
          result.visibility = valueDes;
          break;
        case r'houseMade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(HouseMade),
          ) as HouseMade?;
          if (valueDes == null) continue;
          result.houseMade.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IngredientAuthor deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IngredientAuthorBuilder();
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

class IngredientAuthorLibraryScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'personal')
  static const IngredientAuthorLibraryScopeEnum personal = _$ingredientAuthorLibraryScopeEnum_personal;
  @BuiltValueEnumConst(wireName: r'bar')
  static const IngredientAuthorLibraryScopeEnum bar = _$ingredientAuthorLibraryScopeEnum_bar;

  static Serializer<IngredientAuthorLibraryScopeEnum> get serializer => _$ingredientAuthorLibraryScopeEnumSerializer;

  const IngredientAuthorLibraryScopeEnum._(String name): super(name);

  static BuiltSet<IngredientAuthorLibraryScopeEnum> get values => _$ingredientAuthorLibraryScopeEnumValues;
  static IngredientAuthorLibraryScopeEnum valueOf(String name) => _$ingredientAuthorLibraryScopeEnumValueOf(name);
}

class IngredientAuthorVisibilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'private')
  static const IngredientAuthorVisibilityEnum private = _$ingredientAuthorVisibilityEnum_private;
  @BuiltValueEnumConst(wireName: r'public')
  static const IngredientAuthorVisibilityEnum public = _$ingredientAuthorVisibilityEnum_public;

  static Serializer<IngredientAuthorVisibilityEnum> get serializer => _$ingredientAuthorVisibilityEnumSerializer;

  const IngredientAuthorVisibilityEnum._(String name): super(name);

  static BuiltSet<IngredientAuthorVisibilityEnum> get values => _$ingredientAuthorVisibilityEnumValues;
  static IngredientAuthorVisibilityEnum valueOf(String name) => _$ingredientAuthorVisibilityEnumValueOf(name);
}

