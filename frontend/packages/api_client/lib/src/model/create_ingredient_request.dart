//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/create_house_made_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_ingredient_request.g.dart';

/// T059, FR-012/FR-014/FR-017. libraryScope \"bar\" requires venueId, verified as owned by the caller (403 otherwise). categoryId defaults to a fixed system fallback category when omitted. Newly authored ingredients always start private (FR-008b).
///
/// Properties:
/// * [name] 
/// * [libraryScope] 
/// * [venueId] 
/// * [categoryId] 
/// * [parentId] 
/// * [abvPercent] 
/// * [sources] 
/// * [description] 
/// * [houseMade] 
@BuiltValue()
abstract class CreateIngredientRequest implements Built<CreateIngredientRequest, CreateIngredientRequestBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'libraryScope')
  CreateIngredientRequestLibraryScopeEnum get libraryScope;
  // enum libraryScopeEnum {  personal,  bar,  };

  @BuiltValueField(wireName: r'venueId')
  String? get venueId;

  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'parentId')
  String? get parentId;

  @BuiltValueField(wireName: r'abvPercent')
  num? get abvPercent;

  @BuiltValueField(wireName: r'sources')
  BuiltList<String>? get sources;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'houseMade')
  CreateHouseMadeRequest? get houseMade;

  CreateIngredientRequest._();

  factory CreateIngredientRequest([void updates(CreateIngredientRequestBuilder b)]) = _$CreateIngredientRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateIngredientRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateIngredientRequest> get serializer => _$CreateIngredientRequestSerializer();
}

class _$CreateIngredientRequestSerializer implements PrimitiveSerializer<CreateIngredientRequest> {
  @override
  final Iterable<Type> types = const [CreateIngredientRequest, _$CreateIngredientRequest];

  @override
  final String wireName = r'CreateIngredientRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateIngredientRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'libraryScope';
    yield serializers.serialize(
      object.libraryScope,
      specifiedType: const FullType(CreateIngredientRequestLibraryScopeEnum),
    );
    if (object.venueId != null) {
      yield r'venueId';
      yield serializers.serialize(
        object.venueId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.categoryId != null) {
      yield r'categoryId';
      yield serializers.serialize(
        object.categoryId,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    if (object.sources != null) {
      yield r'sources';
      yield serializers.serialize(
        object.sources,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.houseMade != null) {
      yield r'houseMade';
      yield serializers.serialize(
        object.houseMade,
        specifiedType: const FullType.nullable(CreateHouseMadeRequest),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateIngredientRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateIngredientRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(CreateIngredientRequestLibraryScopeEnum),
          ) as CreateIngredientRequestLibraryScopeEnum;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
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
        case r'houseMade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CreateHouseMadeRequest),
          ) as CreateHouseMadeRequest?;
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
  CreateIngredientRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateIngredientRequestBuilder();
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

class CreateIngredientRequestLibraryScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'personal')
  static const CreateIngredientRequestLibraryScopeEnum personal = _$createIngredientRequestLibraryScopeEnum_personal;
  @BuiltValueEnumConst(wireName: r'bar')
  static const CreateIngredientRequestLibraryScopeEnum bar = _$createIngredientRequestLibraryScopeEnum_bar;

  static Serializer<CreateIngredientRequestLibraryScopeEnum> get serializer => _$createIngredientRequestLibraryScopeEnumSerializer;

  const CreateIngredientRequestLibraryScopeEnum._(String name): super(name);

  static BuiltSet<CreateIngredientRequestLibraryScopeEnum> get values => _$createIngredientRequestLibraryScopeEnumValues;
  static CreateIngredientRequestLibraryScopeEnum valueOf(String name) => _$createIngredientRequestLibraryScopeEnumValueOf(name);
}

