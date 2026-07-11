//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/glossary_term_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'glossary_term_page.g.dart';

/// GlossaryTermPage
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class GlossaryTermPage implements Built<GlossaryTermPage, GlossaryTermPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<GlossaryTermSummary> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  GlossaryTermPage._();

  factory GlossaryTermPage([void updates(GlossaryTermPageBuilder b)]) = _$GlossaryTermPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GlossaryTermPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GlossaryTermPage> get serializer => _$GlossaryTermPageSerializer();
}

class _$GlossaryTermPageSerializer implements PrimitiveSerializer<GlossaryTermPage> {
  @override
  final Iterable<Type> types = const [GlossaryTermPage, _$GlossaryTermPage];

  @override
  final String wireName = r'GlossaryTermPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GlossaryTermPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(GlossaryTermSummary)]),
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
    GlossaryTermPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GlossaryTermPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GlossaryTermSummary)]),
          ) as BuiltList<GlossaryTermSummary>;
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
  GlossaryTermPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GlossaryTermPageBuilder();
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

