//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/makeable_recipe.dart';
import 'package:api_client/src/model/near_miss_recipe.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'makeable_response.g.dart';

/// MakeableResponse
///
/// Properties:
/// * [makeable] 
/// * [nearMiss] 
@BuiltValue()
abstract class MakeableResponse implements Built<MakeableResponse, MakeableResponseBuilder> {
  @BuiltValueField(wireName: r'makeable')
  BuiltList<MakeableRecipe> get makeable;

  @BuiltValueField(wireName: r'nearMiss')
  BuiltList<NearMissRecipe> get nearMiss;

  MakeableResponse._();

  factory MakeableResponse([void updates(MakeableResponseBuilder b)]) = _$MakeableResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MakeableResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MakeableResponse> get serializer => _$MakeableResponseSerializer();
}

class _$MakeableResponseSerializer implements PrimitiveSerializer<MakeableResponse> {
  @override
  final Iterable<Type> types = const [MakeableResponse, _$MakeableResponse];

  @override
  final String wireName = r'MakeableResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MakeableResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'makeable';
    yield serializers.serialize(
      object.makeable,
      specifiedType: const FullType(BuiltList, [FullType(MakeableRecipe)]),
    );
    yield r'nearMiss';
    yield serializers.serialize(
      object.nearMiss,
      specifiedType: const FullType(BuiltList, [FullType(NearMissRecipe)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MakeableResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MakeableResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'makeable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MakeableRecipe)]),
          ) as BuiltList<MakeableRecipe>;
          result.makeable.replace(valueDes);
          break;
        case r'nearMiss':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(NearMissRecipe)]),
          ) as BuiltList<NearMissRecipe>;
          result.nearMiss.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MakeableResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MakeableResponseBuilder();
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

