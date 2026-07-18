//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/venue.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'venue_page.g.dart';

/// VenuePage
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class VenuePage implements Built<VenuePage, VenuePageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<Venue> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  VenuePage._();

  factory VenuePage([void updates(VenuePageBuilder b)]) = _$VenuePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VenuePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VenuePage> get serializer => _$VenuePageSerializer();
}

class _$VenuePageSerializer implements PrimitiveSerializer<VenuePage> {
  @override
  final Iterable<Type> types = const [VenuePage, _$VenuePage];

  @override
  final String wireName = r'VenuePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VenuePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(Venue)]),
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
    VenuePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VenuePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Venue)]),
          ) as BuiltList<Venue>;
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
  VenuePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VenuePageBuilder();
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

