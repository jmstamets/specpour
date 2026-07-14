//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recovery_request.g.dart';

/// RecoveryRequest
///
/// Properties:
/// * [email] 
@BuiltValue()
abstract class RecoveryRequest implements Built<RecoveryRequest, RecoveryRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  RecoveryRequest._();

  factory RecoveryRequest([void updates(RecoveryRequestBuilder b)]) = _$RecoveryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecoveryRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecoveryRequest> get serializer => _$RecoveryRequestSerializer();
}

class _$RecoveryRequestSerializer implements PrimitiveSerializer<RecoveryRequest> {
  @override
  final Iterable<Type> types = const [RecoveryRequest, _$RecoveryRequest];

  @override
  final String wireName = r'RecoveryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecoveryRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecoveryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecoveryRequestBuilder();
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

