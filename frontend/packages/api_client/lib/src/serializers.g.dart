// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(AgeGateResponse.serializer)
      ..add(AgeGateResponseSurfaceStrictnessEnum.serializer)
      ..add(AuthAccount.serializer)
      ..add(AutoLinkMatch.serializer)
      ..add(AutoLinkResponse.serializer)
      ..add(ConceptDetail.serializer)
      ..add(ConceptPage.serializer)
      ..add(ConceptSummary.serializer)
      ..add(ConceptVariant.serializer)
      ..add(CursorPage.serializer)
      ..add(EntitlementManifest.serializer)
      ..add(EquipmentDetail.serializer)
      ..add(EquipmentPage.serializer)
      ..add(EquipmentRef.serializer)
      ..add(EquipmentSummary.serializer)
      ..add(GlossaryArticleDetail.serializer)
      ..add(GlossaryArticlePage.serializer)
      ..add(GlossaryArticleSummary.serializer)
      ..add(GlossaryTermDetail.serializer)
      ..add(GlossaryTermPage.serializer)
      ..add(GlossaryTermSummary.serializer)
      ..add(InboxMessage.serializer)
      ..add(InboxPage.serializer)
      ..add(IngredientDetail.serializer)
      ..add(IngredientPage.serializer)
      ..add(IngredientRecipeRef.serializer)
      ..add(IngredientRecipes.serializer)
      ..add(IngredientSummary.serializer)
      ..add(LoginRequest.serializer)
      ..add(ProblemDetails.serializer)
      ..add(RecipeDetail.serializer)
      ..add(RecipeIngredientLine.serializer)
      ..add(RecipeIngredientLineScalingRuleEnum.serializer)
      ..add(RecipePage.serializer)
      ..add(RecipeSummary.serializer)
      ..add(RegisterRequest.serializer)
      ..add(RegisterRequestUnitPreferenceEnum.serializer)
      ..add(ResponsibleConsumptionMessageResponse.serializer)
      ..add(RoleGrantSummary.serializer)
      ..add(RoleGrantSummaryScopeTypeEnum.serializer)
      ..add(SearchResult.serializer)
      ..add(SearchResultEntityTypeEnum.serializer)
      ..add(SearchResultPage.serializer)
      ..add(SupportResourceResponse.serializer)
      ..add(SupportResourcesResponse.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AutoLinkMatch)]),
          () => ListBuilder<AutoLinkMatch>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ConceptSummary)]),
          () => ListBuilder<ConceptSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ConceptVariant)]),
          () => ListBuilder<ConceptVariant>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(EquipmentSummary)]),
          () => ListBuilder<EquipmentSummary>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(GlossaryArticleSummary)]),
          () => ListBuilder<GlossaryArticleSummary>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(GlossaryTermSummary)]),
          () => ListBuilder<GlossaryTermSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InboxMessage)]),
          () => ListBuilder<InboxMessage>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(IngredientRecipeRef)]),
          () => ListBuilder<IngredientRecipeRef>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(IngredientSummary)]),
          () => ListBuilder<IngredientSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(RecipeSummary)]),
          () => ListBuilder<RecipeSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SearchResult)]),
          () => ListBuilder<SearchResult>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(RoleGrantSummary)]),
          () => ListBuilder<RoleGrantSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(RecipeIngredientLine)]),
          () => ListBuilder<RecipeIngredientLine>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(EquipmentRef)]),
          () => ListBuilder<EquipmentRef>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(EquipmentRef)]),
          () => ListBuilder<EquipmentRef>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(SupportResourceResponse)]),
          () => ListBuilder<SupportResourceResponse>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(JsonObject)]),
          () => ListBuilder<JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
