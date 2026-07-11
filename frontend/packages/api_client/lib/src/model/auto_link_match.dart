//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_link_match.g.dart';

/// AutoLinkMatch
///
/// Properties:
/// * [start] - Character offset into the supplied content.
/// * [length] 
/// * [termId] 
/// * [term] 
@BuiltValue()
abstract class AutoLinkMatch implements Built<AutoLinkMatch, AutoLinkMatchBuilder> {
  /// Character offset into the supplied content.
  @BuiltValueField(wireName: r'start')
  int get start;

  @BuiltValueField(wireName: r'length')
  int get length;

  @BuiltValueField(wireName: r'termId')
  String get termId;

  @BuiltValueField(wireName: r'term')
  String get term;

  AutoLinkMatch._();

  factory AutoLinkMatch([void updates(AutoLinkMatchBuilder b)]) = _$AutoLinkMatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoLinkMatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoLinkMatch> get serializer => _$AutoLinkMatchSerializer();
}

class _$AutoLinkMatchSerializer implements PrimitiveSerializer<AutoLinkMatch> {
  @override
  final Iterable<Type> types = const [AutoLinkMatch, _$AutoLinkMatch];

  @override
  final String wireName = r'AutoLinkMatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoLinkMatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'start';
    yield serializers.serialize(
      object.start,
      specifiedType: const FullType(int),
    );
    yield r'length';
    yield serializers.serialize(
      object.length,
      specifiedType: const FullType(int),
    );
    yield r'termId';
    yield serializers.serialize(
      object.termId,
      specifiedType: const FullType(String),
    );
    yield r'term';
    yield serializers.serialize(
      object.term,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoLinkMatch object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoLinkMatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.start = valueDes;
          break;
        case r'length':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.length = valueDes;
          break;
        case r'termId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.termId = valueDes;
          break;
        case r'term':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.term = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoLinkMatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoLinkMatchBuilder();
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

