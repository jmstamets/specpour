//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'external_providers.g.dart';

/// ExternalProviders
///
/// Properties:
/// * [providers] 
@BuiltValue()
abstract class ExternalProviders implements Built<ExternalProviders, ExternalProvidersBuilder> {
  @BuiltValueField(wireName: r'providers')
  BuiltList<ExternalProvidersProvidersEnum> get providers;
  // enum providersEnum {  google,  apple,  microsoft,  };

  ExternalProviders._();

  factory ExternalProviders([void updates(ExternalProvidersBuilder b)]) = _$ExternalProviders;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExternalProvidersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExternalProviders> get serializer => _$ExternalProvidersSerializer();
}

class _$ExternalProvidersSerializer implements PrimitiveSerializer<ExternalProviders> {
  @override
  final Iterable<Type> types = const [ExternalProviders, _$ExternalProviders];

  @override
  final String wireName = r'ExternalProviders';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExternalProviders object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'providers';
    yield serializers.serialize(
      object.providers,
      specifiedType: const FullType(BuiltList, [FullType(ExternalProvidersProvidersEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExternalProviders object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExternalProvidersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'providers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ExternalProvidersProvidersEnum)]),
          ) as BuiltList<ExternalProvidersProvidersEnum>;
          result.providers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExternalProviders deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExternalProvidersBuilder();
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

class ExternalProvidersProvidersEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'google')
  static const ExternalProvidersProvidersEnum google = _$externalProvidersProvidersEnum_google;
  @BuiltValueEnumConst(wireName: r'apple')
  static const ExternalProvidersProvidersEnum apple = _$externalProvidersProvidersEnum_apple;
  @BuiltValueEnumConst(wireName: r'microsoft')
  static const ExternalProvidersProvidersEnum microsoft = _$externalProvidersProvidersEnum_microsoft;

  static Serializer<ExternalProvidersProvidersEnum> get serializer => _$externalProvidersProvidersEnumSerializer;

  const ExternalProvidersProvidersEnum._(String name): super(name);

  static BuiltSet<ExternalProvidersProvidersEnum> get values => _$externalProvidersProvidersEnumValues;
  static ExternalProvidersProvidersEnum valueOf(String name) => _$externalProvidersProvidersEnumValueOf(name);
}

