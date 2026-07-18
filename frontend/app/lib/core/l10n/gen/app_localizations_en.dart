// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SpecPour';

  @override
  String get ageGateTitle => 'Confirm your age';

  @override
  String get ageGateExplanation =>
      'SpecPour\'s content is intended for adults of legal drinking age. Please enter your date of birth to continue.';

  @override
  String get ageGateDateOfBirthLabel => 'Date of birth';

  @override
  String get ageGateDatePickerHint => 'Select your date of birth';

  @override
  String get ageGateConfirmButton => 'Confirm';

  @override
  String get ageGateMissingDateOfBirth => 'Please select your date of birth.';

  @override
  String get ageGateUnderageMessage =>
      'We\'re sorry, you must be of legal drinking age to use SpecPour.';

  @override
  String get discoverTitle => 'Discover';

  @override
  String get discoverSearchHint => 'Search recipes, ingredients, glossary…';

  @override
  String get discoverBrowseEmpty => 'No recipes to show yet.';

  @override
  String get discoverSearchEmpty => 'No results found.';

  @override
  String get discoverGroupRecipes => 'Recipes';

  @override
  String get discoverGroupIngredients => 'Ingredients';

  @override
  String get discoverGroupEquipment => 'Equipment';

  @override
  String get discoverGroupGlossary => 'Glossary';

  @override
  String get familyCocktail => 'Cocktail';

  @override
  String get familySpiritForward => 'Spirit-Forward';

  @override
  String get familySour => 'Sour';

  @override
  String get familyHighball => 'Highball';

  @override
  String get familyCobbler => 'Cobbler';

  @override
  String get familyJulep => 'Julep';

  @override
  String get familySmash => 'Smash';

  @override
  String get familyFlip => 'Flip';

  @override
  String get familyNog => 'Nog';

  @override
  String get allergenEgg => 'Egg';

  @override
  String get allergenDairy => 'Dairy';

  @override
  String get allergenTreeNut => 'Tree nut';

  @override
  String get allergenPeanut => 'Peanut';

  @override
  String get allergenGluten => 'Gluten';

  @override
  String get allergenSulfites => 'Sulfites';

  @override
  String get recipeDetailIngredientsTitle => 'Ingredients';

  @override
  String get recipeDetailInstructionsTitle => 'Instructions';

  @override
  String get recipeDetailGarnishTitle => 'Garnish';

  @override
  String get recipeDetailIceTitle => 'Ice';

  @override
  String get recipeDetailGlasswareTitle => 'Glassware';

  @override
  String get recipeDetailEquipmentTitle => 'Equipment';

  @override
  String get recipeDetailAllergensTitle => 'Contains';

  @override
  String recipeDetailAbvStandardDrinks(String abv, String standardDrinks) {
    return '$abv% ABV · $standardDrinks standard drinks';
  }

  @override
  String get recipeDetailHistoryTitle => 'History';

  @override
  String recipeDetailCreatorLabel(String creator) {
    return 'Created by $creator';
  }

  @override
  String get conceptDetailVariantsTitle => 'Variants';

  @override
  String get guestGatePromptTitle => 'Sign in to continue';

  @override
  String guestGatePromptBody(String action) {
    return 'Sign in or create an account to $action. We\'ll pick up right where you left off.';
  }

  @override
  String get guestGateSignInButton => 'Sign in';

  @override
  String get guestGateRegisterButton => 'Create account';

  @override
  String get guestGateDismissButton => 'Not now';

  @override
  String get responsibleUseMessageDefault =>
      'Please enjoy responsibly. Know your limits, and never drink and drive.';

  @override
  String get responsibleUseMessageFallback => 'Please enjoy responsibly.';

  @override
  String get responsibleUseSupportResourcesButton => 'Support resources';

  @override
  String get responsibleUseSupportResourcesTitle => 'Get support';

  @override
  String get aboutTitle => 'About';

  @override
  String get entityInfoNoDescription => 'No description yet.';

  @override
  String get entityInfoUsageLabel => 'How to use';

  @override
  String get entityInfoFullEntryButton => 'Full entry';

  @override
  String ingredientDetailParentLabel(String parentName) {
    return 'Type of $parentName';
  }

  @override
  String get ingredientDetailSourcesTitle => 'Sources';

  @override
  String get ingredientDetailAllergensTitle => 'Allergens';

  @override
  String get ingredientDetailAbvLabel => 'ABV';

  @override
  String get ingredientDetailDefiningRecipeLabel => 'House-made from';

  @override
  String get ingredientDetailYieldLabel => 'Yield';

  @override
  String get ingredientDetailShelfLifeLabel => 'Shelf life';

  @override
  String get ingredientDetailStorageTitle => 'Storage';

  @override
  String get equipmentDetailCategoryLabel => 'Category';

  @override
  String get equipmentDetailUsageTitle => 'How to use';

  @override
  String get equipmentDetailApplicationsTitle => 'Typical uses';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerPasswordPolicyHint => 'At least 12 characters';

  @override
  String get registerPasswordRevealTooltip => 'Show password';

  @override
  String get registerPasswordHideTooltip => 'Hide password';

  @override
  String get registerDisplayNameLabel => 'Display name';

  @override
  String get registerDateOfBirthLabel => 'Date of birth';

  @override
  String get registerDateOfBirthHint => 'Select your date of birth';

  @override
  String get registerSubmitButton => 'Create account';

  @override
  String get registerMissingFieldsError => 'Please fill in every field.';

  @override
  String get registerSignInInstead => 'Already have an account? Sign in';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get signInSubmitButton => 'Sign in';

  @override
  String get signInMissingFieldsError =>
      'Please enter your email and password.';

  @override
  String get signInRegisterInstead => 'Don\'t have an account? Create one';

  @override
  String get signInForgotPasswordLink => 'Forgot your password?';

  @override
  String get mfaChallengeTitle => 'Enter your code';

  @override
  String get mfaChallengeBody =>
      'Enter the 6-digit code from your authenticator app.';

  @override
  String get mfaChallengeCodeLabel => 'Code';

  @override
  String get mfaChallengeSubmitButton => 'Verify';

  @override
  String get mfaChallengeMissingCodeError => 'Please enter your code.';

  @override
  String get mfaSettingsTitle => 'Two-factor authentication';

  @override
  String get mfaSettingsStatusEnabled => 'Two-factor authentication is on.';

  @override
  String get mfaSettingsStatusDisabled => 'Two-factor authentication is off.';

  @override
  String get mfaSettingsEnrollButton => 'Set up two-factor authentication';

  @override
  String get mfaSettingsEnterCodeLabel => 'Enter the code it shows';

  @override
  String get mfaSettingsConfirmButton => 'Confirm';

  @override
  String get mfaSettingsDisableButton => 'Turn off two-factor authentication';

  @override
  String get mfaSettingsEnabledConfirmation =>
      'Two-factor authentication is now on.';

  @override
  String get mfaSettingsDisabledConfirmation =>
      'Two-factor authentication is now off.';

  @override
  String get mfaSettingsMissingCodeError => 'Please enter the code.';

  @override
  String get mfaSettingsBackupCodesLabel =>
      'Save these backup codes somewhere safe. Each can be used once to sign in if you lose access to your authenticator app. They won\'t be shown again.';

  @override
  String get mfaSettingsBackupCodesSavedButton => 'I\'ve saved these codes';

  @override
  String get mfaSettingsRegenerateBackupCodesButton =>
      'Regenerate backup codes';

  @override
  String get mfaSettingsBackupCodesRegeneratedConfirmation =>
      'Your backup codes have been regenerated. Your old codes no longer work.';

  @override
  String get recoveryRequestTitle => 'Recover your account';

  @override
  String get recoveryRequestEmailLabel => 'Email';

  @override
  String get recoveryRequestSubmitButton => 'Send recovery code';

  @override
  String get recoveryRequestMissingFieldError => 'Please enter your email.';

  @override
  String get recoveryRequestSuccessMessage =>
      'If that email has an account, a recovery code is on its way.';

  @override
  String get recoveryRequestGoToConfirmLink => 'Already have a code?';

  @override
  String get recoveryConfirmTitle => 'Reset your password';

  @override
  String get recoveryConfirmEmailLabel => 'Email';

  @override
  String get recoveryConfirmTokenLabel => 'Recovery code';

  @override
  String get recoveryConfirmNewPasswordLabel => 'New password';

  @override
  String get recoveryConfirmSubmitButton => 'Reset password';

  @override
  String get recoveryConfirmMissingFieldsError => 'Please fill in every field.';

  @override
  String get recoveryConfirmSuccessMessage =>
      'Your password has been reset. You can sign in now.';

  @override
  String get socialSignInDivider => 'or';

  @override
  String get socialSignInGoogleButton => 'Continue with Google';

  @override
  String get socialSignInAppleButton => 'Continue with Apple';

  @override
  String get socialSignInMicrosoftButton => 'Continue with Microsoft';

  @override
  String get externalCallbackProcessingMessage => 'Finishing sign-in…';

  @override
  String get externalCallbackErrorMessage =>
      'Sign-in with that provider didn\'t work. Please try again.';

  @override
  String get completeExternalRegistrationTitle =>
      'Finish creating your account';

  @override
  String get completeExternalRegistrationBody =>
      'We just need your date of birth to finish setting up your account.';

  @override
  String get completeExternalRegistrationDisplayNameLabel => 'Display name';

  @override
  String get completeExternalRegistrationDateOfBirthLabel => 'Date of birth';

  @override
  String get completeExternalRegistrationDateOfBirthHint =>
      'Select your date of birth';

  @override
  String get completeExternalRegistrationSubmitButton =>
      'Finish creating account';

  @override
  String get completeExternalRegistrationMissingFieldsError =>
      'Please fill in every field.';

  @override
  String get sessionsTitle => 'Active sessions';

  @override
  String get sessionsEmpty => 'No active sessions.';

  @override
  String sessionsLastActive(String when) {
    return 'Last active $when';
  }

  @override
  String get sessionsRevokeButton => 'Revoke';

  @override
  String get accountLifecycleTitle => 'Deactivate account';

  @override
  String get accountLifecycleGracePeriodExplanation =>
      'Deactivating your account signs you out of every device. You can reactivate any time by signing back in — after the grace period ends, your account and its data are permanently deleted.';

  @override
  String get accountLifecycleDeactivateButton => 'Deactivate my account';

  @override
  String get accountLifecycleDeactivateConfirmTitle =>
      'Deactivate your account?';

  @override
  String get accountLifecycleDeactivateConfirmMessage =>
      'You\'ll be signed out of every device. You can reactivate any time before the grace period ends.';

  @override
  String get accountLifecycleCancelButton => 'Cancel';

  @override
  String get accountLifecycleDeactivatedConfirmation =>
      'Your account is now deactivated.';

  @override
  String get accountLifecycleReactivateButton => 'Reactivate my account';

  @override
  String get accountLifecycleReactivatedConfirmation =>
      'Your account is active again.';

  @override
  String get accountDataTitle => 'Your data';

  @override
  String get accountDataExportButton => 'Export my data';

  @override
  String accountDataExportDateOfBirth(String dateOfBirth) {
    return 'Date of birth: $dateOfBirth';
  }

  @override
  String accountDataExportEmail(String email) {
    return 'Email: $email';
  }

  @override
  String get accountDataDeleteExplanation =>
      'Deleting your account is permanent and cannot be undone. Export your data first if you want to keep a copy.';

  @override
  String get accountDataDeleteButton => 'Delete my account';

  @override
  String get accountDataDeleteConfirmTitle => 'Delete your account?';

  @override
  String get accountDataDeleteConfirmMessage =>
      'This permanently deletes your account and all its data. This cannot be undone.';

  @override
  String get accountMenuTitle => 'Account';

  @override
  String get accountMenuSignOutButton => 'Sign out';

  @override
  String get channelPreferencesTitle => 'Notification preferences';

  @override
  String get channelPreferencesEmailLabel => 'Email';

  @override
  String get channelPreferencesPushLabel => 'Push notifications';

  @override
  String get mfaSettingsScanInstructions =>
      'Scan with any authenticator app (such as Google Authenticator, Microsoft Authenticator, or 1Password), then enter the 6-digit code it shows.';

  @override
  String get mfaSettingsManualKeyLabel =>
      'Can\'t scan the code? Enter this key manually instead:';
}
