//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/concept_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'concept_page.g.dart';

/// ConceptPage
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class ConceptPage implements Built<ConceptPage, ConceptPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ConceptSummary> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  ConceptPage._();

  factory ConceptPage([void updates(ConceptPageBuilder b)]) = _$ConceptPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConceptPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConceptPage> get serializer => _$ConceptPageSerializer();
}

class _$ConceptPageSerializer implements PrimitiveSerializer<ConceptPage> {
  @override
  final Iterable<Type> types = const [ConceptPage, _$ConceptPage];

  @override
  final String wireName = r'ConceptPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConceptPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ConceptSummary)]),
    );
    if (object.nextCursor != null) {
      yield r'nextCursor';
      yield serializers.serialize(
        object.nextCursor,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ConceptPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConceptPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ConceptSummary)]),
          ) as BuiltList<ConceptSummary>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConceptPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConceptPageBuilder();
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

