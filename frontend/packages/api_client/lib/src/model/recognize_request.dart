//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recognize_request.g.dart';

/// RecognizeRequest
///
/// Properties:
/// * [photoUrl] 
@BuiltValue()
abstract class RecognizeRequest implements Built<RecognizeRequest, RecognizeRequestBuilder> {
  @BuiltValueField(wireName: r'photoUrl')
  String? get photoUrl;

  RecognizeRequest._();

  factory RecognizeRequest([void updates(RecognizeRequestBuilder b)]) = _$RecognizeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecognizeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecognizeRequest> get serializer => _$RecognizeRequestSerializer();
}

class _$RecognizeRequestSerializer implements PrimitiveSerializer<RecognizeRequest> {
  @override
  final Iterable<Type> types = const [RecognizeRequest, _$RecognizeRequest];

  @override
  final String wireName = r'RecognizeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecognizeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.photoUrl != null) {
      yield r'photoUrl';
      yield serializers.serialize(
        object.photoUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RecognizeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecognizeRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'photoUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.photoUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecognizeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecognizeRequestBuilder();
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

