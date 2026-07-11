//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/auto_link_match.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_link_response.g.dart';

/// AutoLinkResponse
///
/// Properties:
/// * [matches] 
@BuiltValue()
abstract class AutoLinkResponse implements Built<AutoLinkResponse, AutoLinkResponseBuilder> {
  @BuiltValueField(wireName: r'matches')
  BuiltList<AutoLinkMatch> get matches;

  AutoLinkResponse._();

  factory AutoLinkResponse([void updates(AutoLinkResponseBuilder b)]) = _$AutoLinkResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoLinkResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoLinkResponse> get serializer => _$AutoLinkResponseSerializer();
}

class _$AutoLinkResponseSerializer implements PrimitiveSerializer<AutoLinkResponse> {
  @override
  final Iterable<Type> types = const [AutoLinkResponse, _$AutoLinkResponse];

  @override
  final String wireName = r'AutoLinkResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoLinkResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'matches';
    yield serializers.serialize(
      object.matches,
      specifiedType: const FullType(BuiltList, [FullType(AutoLinkMatch)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoLinkResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoLinkResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'matches':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AutoLinkMatch)]),
          ) as BuiltList<AutoLinkMatch>;
          result.matches.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoLinkResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoLinkResponseBuilder();
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

