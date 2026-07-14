// T028's go_router navigation shell, extended by T041/T042 (discover feature)
// with the discover home route plus recipe/concept detail routes. Deep-linkable
// (R18 — Flutter web serves crawlable/shareable URLs for public content).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/about/about_screen.dart';
import '../../features/discover/concept_detail/concept_detail_screen.dart';
import '../../features/discover/discover_screen.dart';
import '../../features/discover/equipment_detail/equipment_detail_screen.dart';
import '../../features/discover/ingredient_detail/ingredient_detail_screen.dart';
import '../../features/discover/recipe_detail/recipe_detail_screen.dart';
import '../../features/identity/complete_external_registration_screen.dart';
import '../../features/identity/external_sign_in_callback_screen.dart';
import '../../features/identity/mfa_challenge_screen.dart';
import '../../features/identity/mfa_settings_screen.dart';
import '../../features/identity/recovery_confirm_screen.dart';
import '../../features/identity/recovery_request_screen.dart';
import '../../features/identity/register_screen.dart';
import '../../features/identity/sign_in_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'discover',
        builder: (context, state) => const DiscoverScreen(),
      ),
      GoRoute(
        path: '/recipes/:id',
        name: 'recipeDetail',
        builder: (context, state) =>
            RecipeDetailScreen(recipeId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/concepts/:id',
        name: 'conceptDetail',
        builder: (context, state) =>
            ConceptDetailScreen(conceptId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/ingredients/:id',
        name: 'ingredientDetail',
        builder: (context, state) =>
            IngredientDetailScreen(ingredientId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/equipment/:id',
        name: 'equipmentDetail',
        builder: (context, state) =>
            EquipmentDetailScreen(equipmentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        name: 'signIn',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/mfa-challenge',
        name: 'mfaChallenge',
        builder: (context, state) => const MfaChallengeScreen(),
      ),
      GoRoute(
        path: '/account/mfa',
        name: 'mfaSettings',
        builder: (context, state) => const MfaSettingsScreen(),
      ),
      GoRoute(
        path: '/recovery',
        name: 'recoveryRequest',
        builder: (context, state) => const RecoveryRequestScreen(),
      ),
      GoRoute(
        path: '/recovery/confirm',
        name: 'recoveryConfirm',
        builder: (context, state) => const RecoveryConfirmScreen(),
      ),
      GoRoute(
        path: '/auth/external/callback',
        name: 'externalSignInCallback',
        builder: (context, state) =>
            ExternalSignInCallbackScreen(queryParameters: state.uri.queryParameters),
      ),
      GoRoute(
        path: '/auth/external/complete-registration',
        name: 'completeExternalRegistration',
        builder: (context, state) => const CompleteExternalRegistrationScreen(),
      ),
    ],
  );
});
