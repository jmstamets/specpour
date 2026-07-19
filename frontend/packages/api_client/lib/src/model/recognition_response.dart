//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/manual_entry_form.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recognition_response.g.dart';

/// RecognitionResponse
///
/// Properties:
/// * [recognized] 
/// * [candidateIngredientId] 
/// * [manualEntryForm] 
@BuiltValue()
abstract class RecognitionResponse implements Built<RecognitionResponse, RecognitionResponseBuilder> {
  @BuiltValueField(wireName: r'recognized')
  bool get recognized;

  @BuiltValueField(wireName: r'candidateIngredientId')
  String? get candidateIngredientId;

  @BuiltValueField(wireName: r'manualEntryForm')
  ManualEntryForm get manualEntryForm;

  RecognitionResponse._();

  factory RecognitionResponse([void updates(RecognitionResponseBuilder b)]) = _$RecognitionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecognitionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecognitionResponse> get serializer => _$RecognitionResponseSerializer();
}

class _$RecognitionResponseSerializer implements PrimitiveSerializer<RecognitionResponse> {
  @override
  final Iterable<Type> types = const [RecognitionResponse, _$RecognitionResponse];

  @override
  final String wireName = r'RecognitionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecognitionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'recognized';
    yield serializers.serialize(
      object.recognized,
      specifiedType: const FullType(bool),
    );
    if (object.candidateIngredientId != null) {
      yield r'candidateIngredientId';
      yield serializers.serialize(
        object.candidateIngredientId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'manualEntryForm';
    yield serializers.serialize(
      object.manualEntryForm,
      specifiedType: const FullType(ManualEntryForm),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecognitionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecognitionResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recognized':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.recognized = valueDes;
          break;
        case r'candidateIngredientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.candidateIngredientId = valueDes;
          break;
        case r'manualEntryForm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ManualEntryForm),
          ) as ManualEntryForm;
          result.manualEntryForm.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecognitionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecognitionResponseBuilder();
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

