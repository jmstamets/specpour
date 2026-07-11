//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'glossary_term_detail.g.dart';

/// GlossaryTermDetail
///
/// Properties:
/// * [id] 
/// * [term] 
/// * [definitions] - Ordered and numbered — array order IS the numbering.
@BuiltValue()
abstract class GlossaryTermDetail implements Built<GlossaryTermDetail, GlossaryTermDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'term')
  String get term;

  /// Ordered and numbered — array order IS the numbering.
  @BuiltValueField(wireName: r'definitions')
  BuiltList<String> get definitions;

  GlossaryTermDetail._();

  factory GlossaryTermDetail([void updates(GlossaryTermDetailBuilder b)]) = _$GlossaryTermDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GlossaryTermDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GlossaryTermDetail> get serializer => _$GlossaryTermDetailSerializer();
}

class _$GlossaryTermDetailSerializer implements PrimitiveSerializer<GlossaryTermDetail> {
  @override
  final Iterable<Type> types = const [GlossaryTermDetail, _$GlossaryTermDetail];

  @override
  final String wireName = r'GlossaryTermDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GlossaryTermDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'term';
    yield serializers.serialize(
      object.term,
      specifiedType: const FullType(String),
    );
    yield r'definitions';
    yield serializers.serialize(
      object.definitions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GlossaryTermDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GlossaryTermDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'term':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.term = valueDes;
          break;
        case r'definitions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.definitions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GlossaryTermDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GlossaryTermDetailBuilder();
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

