//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_resource_response.g.dart';

/// SupportResourceResponse
///
/// Properties:
/// * [name] 
/// * [link] 
/// * [displayOrder] 
@BuiltValue()
abstract class SupportResourceResponse implements Built<SupportResourceResponse, SupportResourceResponseBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'link')
  String get link;

  @BuiltValueField(wireName: r'displayOrder')
  int get displayOrder;

  SupportResourceResponse._();

  factory SupportResourceResponse([void updates(SupportResourceResponseBuilder b)]) = _$SupportResourceResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportResourceResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportResourceResponse> get serializer => _$SupportResourceResponseSerializer();
}

class _$SupportResourceResponseSerializer implements PrimitiveSerializer<SupportResourceResponse> {
  @override
  final Iterable<Type> types = const [SupportResourceResponse, _$SupportResourceResponse];

  @override
  final String wireName = r'SupportResourceResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportResourceResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'link';
    yield serializers.serialize(
      object.link,
      specifiedType: const FullType(String),
    );
    yield r'displayOrder';
    yield serializers.serialize(
      object.displayOrder,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SupportResourceResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportResourceResponseBuilder result,
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
        case r'link':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.link = valueDes;
          break;
        case r'displayOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.displayOrder = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupportResourceResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportResourceResponseBuilder();
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

