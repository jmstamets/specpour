// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(CursorPage.serializer)
      ..add(EntitlementManifest.serializer)
      ..add(ProblemDetails.serializer)
      ..add(RoleGrantSummary.serializer)
      ..add(RoleGrantSummaryScopeTypeEnum.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(RoleGrantSummary)]),
          () => ListBuilder<RoleGrantSummary>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(JsonObject)]),
          () => ListBuilder<JsonObject?>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
