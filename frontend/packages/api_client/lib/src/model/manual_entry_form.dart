//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'manual_entry_form.g.dart';

/// Pre-filled with the recognized candidate when recognized is true; both fields null otherwise.
///
/// Properties:
/// * [prefilledIngredientId] 
/// * [prefilledIngredientName] 
@BuiltValue()
abstract class ManualEntryForm implements Built<ManualEntryForm, ManualEntryFormBuilder> {
  @BuiltValueField(wireName: r'prefilledIngredientId')
  String? get prefilledIngredientId;

  @BuiltValueField(wireName: r'prefilledIngredientName')
  String? get prefilledIngredientName;

  ManualEntryForm._();

  factory ManualEntryForm([void updates(ManualEntryFormBuilder b)]) = _$ManualEntryForm;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ManualEntryFormBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ManualEntryForm> get serializer => _$ManualEntryFormSerializer();
}

class _$ManualEntryFormSerializer implements PrimitiveSerializer<ManualEntryForm> {
  @override
  final Iterable<Type> types = const [ManualEntryForm, _$ManualEntryForm];

  @override
  final String wireName = r'ManualEntryForm';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ManualEntryForm object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.prefilledIngredientId != null) {
      yield r'prefilledIngredientId';
      yield serializers.serialize(
        object.prefilledIngredientId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.prefilledIngredientName != null) {
      yield r'prefilledIngredientName';
      yield serializers.serialize(
        object.prefilledIngredientName,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ManualEntryForm object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ManualEntryFormBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'prefilledIngredientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.prefilledIngredientId = valueDes;
          break;
        case r'prefilledIngredientName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.prefilledIngredientName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ManualEntryForm deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ManualEntryFormBuilder();
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

