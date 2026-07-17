//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:api_client/src/date_serializer.dart';
import 'package:api_client/src/model/date.dart';

import 'package:api_client/src/model/age_gate_response.dart';
import 'package:api_client/src/model/auth_account.dart';
import 'package:api_client/src/model/auto_link_match.dart';
import 'package:api_client/src/model/auto_link_response.dart';
import 'package:api_client/src/model/backup_codes.dart';
import 'package:api_client/src/model/channel_preference.dart';
import 'package:api_client/src/model/channel_preferences.dart';
import 'package:api_client/src/model/channel_preferences_update.dart';
import 'package:api_client/src/model/channel_preferences_update_channels_inner.dart';
import 'package:api_client/src/model/complete_external_registration_request.dart';
import 'package:api_client/src/model/concept_detail.dart';
import 'package:api_client/src/model/concept_page.dart';
import 'package:api_client/src/model/concept_summary.dart';
import 'package:api_client/src/model/concept_variant.dart';
import 'package:api_client/src/model/cursor_page.dart';
import 'package:api_client/src/model/enroll_mfa_request.dart';
import 'package:api_client/src/model/entitlement_manifest.dart';
import 'package:api_client/src/model/equipment_detail.dart';
import 'package:api_client/src/model/equipment_page.dart';
import 'package:api_client/src/model/equipment_ref.dart';
import 'package:api_client/src/model/equipment_summary.dart';
import 'package:api_client/src/model/external_providers.dart';
import 'package:api_client/src/model/glossary_article_detail.dart';
import 'package:api_client/src/model/glossary_article_page.dart';
import 'package:api_client/src/model/glossary_article_summary.dart';
import 'package:api_client/src/model/glossary_term_detail.dart';
import 'package:api_client/src/model/glossary_term_page.dart';
import 'package:api_client/src/model/glossary_term_summary.dart';
import 'package:api_client/src/model/inbox_message.dart';
import 'package:api_client/src/model/inbox_page.dart';
import 'package:api_client/src/model/ingredient_detail.dart';
import 'package:api_client/src/model/ingredient_page.dart';
import 'package:api_client/src/model/ingredient_recipe_ref.dart';
import 'package:api_client/src/model/ingredient_recipes.dart';
import 'package:api_client/src/model/ingredient_summary.dart';
import 'package:api_client/src/model/login_mfa_request.dart';
import 'package:api_client/src/model/login_request.dart';
import 'package:api_client/src/model/login_result.dart';
import 'package:api_client/src/model/me_export.dart';
import 'package:api_client/src/model/mfa_enrollment.dart';
import 'package:api_client/src/model/mfa_status.dart';
import 'package:api_client/src/model/problem_details.dart';
import 'package:api_client/src/model/recipe_detail.dart';
import 'package:api_client/src/model/recipe_ingredient_line.dart';
import 'package:api_client/src/model/recipe_page.dart';
import 'package:api_client/src/model/recipe_summary.dart';
import 'package:api_client/src/model/recovery_confirm_request.dart';
import 'package:api_client/src/model/recovery_request.dart';
import 'package:api_client/src/model/register_request.dart';
import 'package:api_client/src/model/responsible_consumption_message_response.dart';
import 'package:api_client/src/model/role_grant_summary.dart';
import 'package:api_client/src/model/search_result.dart';
import 'package:api_client/src/model/search_result_page.dart';
import 'package:api_client/src/model/session.dart';
import 'package:api_client/src/model/session_list.dart';
import 'package:api_client/src/model/support_resource_response.dart';
import 'package:api_client/src/model/support_resources_response.dart';

part 'serializers.g.dart';

@SerializersFor([
  AgeGateResponse,
  AuthAccount,
  AutoLinkMatch,
  AutoLinkResponse,
  BackupCodes,
  ChannelPreference,
  ChannelPreferences,
  ChannelPreferencesUpdate,
  ChannelPreferencesUpdateChannelsInner,
  CompleteExternalRegistrationRequest,
  ConceptDetail,
  ConceptPage,
  ConceptSummary,
  ConceptVariant,
  CursorPage,
  EnrollMfaRequest,
  EntitlementManifest,
  EquipmentDetail,
  EquipmentPage,
  EquipmentRef,
  EquipmentSummary,
  ExternalProviders,
  GlossaryArticleDetail,
  GlossaryArticlePage,
  GlossaryArticleSummary,
  GlossaryTermDetail,
  GlossaryTermPage,
  GlossaryTermSummary,
  InboxMessage,
  InboxPage,
  IngredientDetail,
  IngredientPage,
  IngredientRecipeRef,
  IngredientRecipes,
  IngredientSummary,
  LoginMfaRequest,
  LoginRequest,
  LoginResult,
  MeExport,
  MfaEnrollment,
  MfaStatus,
  ProblemDetails,
  RecipeDetail,
  RecipeIngredientLine,
  RecipePage,
  RecipeSummary,
  RecoveryConfirmRequest,
  RecoveryRequest,
  RegisterRequest,
  ResponsibleConsumptionMessageResponse,
  RoleGrantSummary,
  SearchResult,
  SearchResultPage,
  Session,
  SessionList,
  SupportResourceResponse,
  SupportResourcesResponse,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
