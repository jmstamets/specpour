import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The application title, shown on the home screen and as the OS task label.
  ///
  /// In en, this message translates to:
  /// **'SpecPour'**
  String get appTitle;

  /// Title of the age-affirmation gate screen (T144).
  ///
  /// In en, this message translates to:
  /// **'Confirm your age'**
  String get ageGateTitle;

  /// Body copy explaining why the age gate is shown.
  ///
  /// In en, this message translates to:
  /// **'SpecPour\'s content is intended for adults of legal drinking age. Please enter your date of birth to continue.'**
  String get ageGateExplanation;

  /// Label for the date-of-birth entry field.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get ageGateDateOfBirthLabel;

  /// Placeholder shown before a date has been selected.
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get ageGateDatePickerHint;

  /// Button that submits the entered date of birth for the local age check.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get ageGateConfirmButton;

  /// Validation message when the user taps confirm without selecting a date.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth.'**
  String get ageGateMissingDateOfBirth;

  /// Rejection message shown when the entered date of birth is under the legal drinking age threshold.
  ///
  /// In en, this message translates to:
  /// **'We\'re sorry, you must be of legal drinking age to use SpecPour.'**
  String get ageGateUnderageMessage;

  /// App bar title of the discover/browse/search home screen (T041).
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverTitle;

  /// Placeholder text in the discover screen's search field.
  ///
  /// In en, this message translates to:
  /// **'Search recipes, ingredients, glossary…'**
  String get discoverSearchHint;

  /// Shown when the curated-library browse list has no results.
  ///
  /// In en, this message translates to:
  /// **'No recipes to show yet.'**
  String get discoverBrowseEmpty;

  /// Shown when a search query returns no results.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get discoverSearchEmpty;

  /// Section header grouping recipe search results (FR-049 typed/grouped results).
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get discoverGroupRecipes;

  /// Section header grouping ingredient search results.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get discoverGroupIngredients;

  /// Section header grouping equipment search results.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get discoverGroupEquipment;

  /// Section header grouping glossary term and article search results.
  ///
  /// In en, this message translates to:
  /// **'Glossary'**
  String get discoverGroupGlossary;

  /// Display name for the family.cocktail taxonomy key (T157: backend sends i18n keys, client resolves).
  ///
  /// In en, this message translates to:
  /// **'Cocktail'**
  String get familyCocktail;

  /// Display name for family.spiritForward.
  ///
  /// In en, this message translates to:
  /// **'Spirit-Forward'**
  String get familySpiritForward;

  /// Display name for family.sour.
  ///
  /// In en, this message translates to:
  /// **'Sour'**
  String get familySour;

  /// Display name for family.highball.
  ///
  /// In en, this message translates to:
  /// **'Highball'**
  String get familyHighball;

  /// Display name for family.cobbler.
  ///
  /// In en, this message translates to:
  /// **'Cobbler'**
  String get familyCobbler;

  /// Display name for family.julep.
  ///
  /// In en, this message translates to:
  /// **'Julep'**
  String get familyJulep;

  /// Display name for family.smash.
  ///
  /// In en, this message translates to:
  /// **'Smash'**
  String get familySmash;

  /// Display name for family.flip.
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get familyFlip;

  /// Display name for family.nog.
  ///
  /// In en, this message translates to:
  /// **'Nog'**
  String get familyNog;

  /// Display name for the egg allergen key (FR-055 chips).
  ///
  /// In en, this message translates to:
  /// **'Egg'**
  String get allergenEgg;

  /// Display name for the dairy allergen key.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get allergenDairy;

  /// Display name for the treeNut allergen key.
  ///
  /// In en, this message translates to:
  /// **'Tree nut'**
  String get allergenTreeNut;

  /// Display name for the peanut allergen key.
  ///
  /// In en, this message translates to:
  /// **'Peanut'**
  String get allergenPeanut;

  /// Display name for the gluten allergen key.
  ///
  /// In en, this message translates to:
  /// **'Gluten'**
  String get allergenGluten;

  /// Display name for the sulfites allergen key.
  ///
  /// In en, this message translates to:
  /// **'Sulfites'**
  String get allergenSulfites;

  /// Section heading for a recipe's ingredient lines (T042).
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get recipeDetailIngredientsTitle;

  /// Section heading for a recipe's step-by-step instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get recipeDetailInstructionsTitle;

  /// Section heading for a recipe's garnishes.
  ///
  /// In en, this message translates to:
  /// **'Garnish'**
  String get recipeDetailGarnishTitle;

  /// Label for a recipe's ice specification (T158: previously the ice spec was mislabeled under Garnish).
  ///
  /// In en, this message translates to:
  /// **'Ice'**
  String get recipeDetailIceTitle;

  /// Section heading for a recipe's acceptable glassware (FR-020).
  ///
  /// In en, this message translates to:
  /// **'Glassware'**
  String get recipeDetailGlasswareTitle;

  /// Section heading for a recipe's required equipment (FR-020).
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get recipeDetailEquipmentTitle;

  /// Section heading for a recipe's rolled-up allergen flags (FR-055).
  ///
  /// In en, this message translates to:
  /// **'Contains'**
  String get recipeDetailAllergensTitle;

  /// Derived ABV and standard-drinks display (FR-022), values pre-formatted by the caller.
  ///
  /// In en, this message translates to:
  /// **'{abv}% ABV · {standardDrinks} standard drinks'**
  String recipeDetailAbvStandardDrinks(String abv, String standardDrinks);

  /// Section heading for a recipe's history/background text.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get recipeDetailHistoryTitle;

  /// Attribution line naming the recipe's creator/originator.
  ///
  /// In en, this message translates to:
  /// **'Created by {creator}'**
  String recipeDetailCreatorLabel(String creator);

  /// Section heading for a concept page's linked variant recipes (FR-021).
  ///
  /// In en, this message translates to:
  /// **'Variants'**
  String get conceptDetailVariantsTitle;

  /// Title of the sign-in prompt shown when a guest attempts an account-gated action (T043).
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get guestGatePromptTitle;

  /// Body of the guest-gate sign-in prompt; {action} describes the attempted action.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account to {action}. We\'ll pick up right where you left off.'**
  String guestGatePromptBody(String action);

  /// Sign-in button in the guest-gate prompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get guestGateSignInButton;

  /// Register button in the guest-gate prompt.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get guestGateRegisterButton;

  /// Dismiss button in the guest-gate prompt.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get guestGateDismissButton;

  /// Default responsible-consumption message (FR-067); resolved from the backend's 'responsibleUse.message.default' content key.
  ///
  /// In en, this message translates to:
  /// **'Please enjoy responsibly. Know your limits, and never drink and drive.'**
  String get responsibleUseMessageDefault;

  /// Shown when the backend returns a responsible-consumption content key the client doesn't recognize — never leave the surface without a message (FR-067).
  ///
  /// In en, this message translates to:
  /// **'Please enjoy responsibly.'**
  String get responsibleUseMessageFallback;

  /// Button/link opening the jurisdiction-aware support resources (FR-069).
  ///
  /// In en, this message translates to:
  /// **'Support resources'**
  String get responsibleUseSupportResourcesButton;

  /// Title of the support-resources sheet (FR-069).
  ///
  /// In en, this message translates to:
  /// **'Get support'**
  String get responsibleUseSupportResourcesTitle;

  /// Title of the about/settings surface (FR-067 footer/about; FR-069).
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// T156 entity info popover: shown when the entity has no curated description.
  ///
  /// In en, this message translates to:
  /// **'No description yet.'**
  String get entityInfoNoDescription;

  /// T156 entity info popover: label preceding equipment usage guidance.
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get entityInfoUsageLabel;

  /// T156 entity info popover: link to the entity's full detail screen.
  ///
  /// In en, this message translates to:
  /// **'Full entry'**
  String get entityInfoFullEntryButton;

  /// T156 ingredient detail: shown when the ingredient has a parent category ingredient.
  ///
  /// In en, this message translates to:
  /// **'Type of {parentName}'**
  String ingredientDetailParentLabel(String parentName);

  /// T156 ingredient detail: label for the ingredient's brand/source examples.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get ingredientDetailSourcesTitle;

  /// T156 ingredient detail: label for the ingredient's own allergen flags.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get ingredientDetailAllergensTitle;

  /// T156 ingredient detail: label for the ingredient's own ABV percentage, when it is a spirit/liqueur.
  ///
  /// In en, this message translates to:
  /// **'ABV'**
  String get ingredientDetailAbvLabel;

  /// T156 ingredient detail: label linking a house-made ingredient to the recipe that defines it.
  ///
  /// In en, this message translates to:
  /// **'House-made from'**
  String get ingredientDetailDefiningRecipeLabel;

  /// T156 ingredient detail: label for house-made yield quantity/unit.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get ingredientDetailYieldLabel;

  /// T156 ingredient detail: label for house-made shelf life.
  ///
  /// In en, this message translates to:
  /// **'Shelf life'**
  String get ingredientDetailShelfLifeLabel;

  /// T156 ingredient detail: label for house-made storage instructions.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get ingredientDetailStorageTitle;

  /// T156 equipment detail: label for the equipment category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get equipmentDetailCategoryLabel;

  /// T156 equipment detail: label for usage guidance.
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get equipmentDetailUsageTitle;

  /// T156 equipment detail: label for the list of typical applications.
  ///
  /// In en, this message translates to:
  /// **'Typical uses'**
  String get equipmentDetailApplicationsTitle;

  /// T055 registration screen title.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// T055 registration screen: email field label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// T055 registration screen: password field label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordLabel;

  /// T171: password field helper text, shown before first failure — mirrors the actual server policy exactly (IdentityModule.AddIdentityCore: RequiredLength=12, no composition requirements).
  ///
  /// In en, this message translates to:
  /// **'At least 12 characters'**
  String get registerPasswordPolicyHint;

  /// T171: tooltip/semantic label for the password reveal toggle when the password is currently hidden.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get registerPasswordRevealTooltip;

  /// T171: tooltip/semantic label for the password reveal toggle when the password is currently shown.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get registerPasswordHideTooltip;

  /// T055 registration screen: display name field label.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get registerDisplayNameLabel;

  /// T055 registration screen: date-of-birth field label (a real date picker, never a checkbox, same as the age gate).
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get registerDateOfBirthLabel;

  /// T055 registration screen: date-picker placeholder before a date is chosen.
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get registerDateOfBirthHint;

  /// T055 registration screen: submit button.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerSubmitButton;

  /// T055 registration screen: client-side validation message when a required field is empty.
  ///
  /// In en, this message translates to:
  /// **'Please fill in every field.'**
  String get registerMissingFieldsError;

  /// T055 registration screen: link to the sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get registerSignInInstead;

  /// T055 sign-in screen title.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTitle;

  /// T055 sign-in screen: submit button.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInSubmitButton;

  /// T055 sign-in screen: client-side validation message.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email and password.'**
  String get signInMissingFieldsError;

  /// T055 sign-in screen: link to the registration screen.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Create one'**
  String get signInRegisterInstead;

  /// T050 sign-in screen: link to the account recovery request screen.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get signInForgotPasswordLink;

  /// T050 MFA login-challenge screen title.
  ///
  /// In en, this message translates to:
  /// **'Enter your code'**
  String get mfaChallengeTitle;

  /// T050 MFA login-challenge screen: instructions.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your authenticator app.'**
  String get mfaChallengeBody;

  /// T050 MFA login-challenge screen: code field label.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get mfaChallengeCodeLabel;

  /// T050 MFA login-challenge screen: submit button.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get mfaChallengeSubmitButton;

  /// T050 MFA login-challenge screen: client-side validation message.
  ///
  /// In en, this message translates to:
  /// **'Please enter your code.'**
  String get mfaChallengeMissingCodeError;

  /// T050 MFA settings screen title.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication'**
  String get mfaSettingsTitle;

  /// T050 MFA settings screen: status when enabled.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication is on.'**
  String get mfaSettingsStatusEnabled;

  /// T050 MFA settings screen: status when disabled.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication is off.'**
  String get mfaSettingsStatusDisabled;

  /// T050 MFA settings screen: start-enrollment button.
  ///
  /// In en, this message translates to:
  /// **'Set up two-factor authentication'**
  String get mfaSettingsEnrollButton;

  /// T050 MFA settings screen: label for the confirmation code field.
  ///
  /// In en, this message translates to:
  /// **'Enter the code it shows'**
  String get mfaSettingsEnterCodeLabel;

  /// T050 MFA settings screen: confirm-enrollment button.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get mfaSettingsConfirmButton;

  /// T050 MFA settings screen: disable button.
  ///
  /// In en, this message translates to:
  /// **'Turn off two-factor authentication'**
  String get mfaSettingsDisableButton;

  /// T050 MFA settings screen: confirmation message after enabling.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication is now on.'**
  String get mfaSettingsEnabledConfirmation;

  /// T050 MFA settings screen: confirmation message after disabling.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication is now off.'**
  String get mfaSettingsDisabledConfirmation;

  /// T050 MFA settings screen: client-side validation message.
  ///
  /// In en, this message translates to:
  /// **'Please enter the code.'**
  String get mfaSettingsMissingCodeError;

  /// T163 MFA settings screen: label above the issued backup-code set, shown exactly once after enrollment confirmation or regeneration.
  ///
  /// In en, this message translates to:
  /// **'Save these backup codes somewhere safe. Each can be used once to sign in if you lose access to your authenticator app. They won\'t be shown again.'**
  String get mfaSettingsBackupCodesLabel;

  /// T163 MFA settings screen: dismisses the one-time backup-code display.
  ///
  /// In en, this message translates to:
  /// **'I\'ve saved these codes'**
  String get mfaSettingsBackupCodesSavedButton;

  /// T163 MFA settings screen: issues a fresh backup-code set, invalidating the prior one.
  ///
  /// In en, this message translates to:
  /// **'Regenerate backup codes'**
  String get mfaSettingsRegenerateBackupCodesButton;

  /// T163 MFA settings screen: confirmation message after regenerating backup codes.
  ///
  /// In en, this message translates to:
  /// **'Your backup codes have been regenerated. Your old codes no longer work.'**
  String get mfaSettingsBackupCodesRegeneratedConfirmation;

  /// T050 account-recovery request screen title.
  ///
  /// In en, this message translates to:
  /// **'Recover your account'**
  String get recoveryRequestTitle;

  /// T050 account-recovery request screen: email field label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get recoveryRequestEmailLabel;

  /// T050 account-recovery request screen: submit button.
  ///
  /// In en, this message translates to:
  /// **'Send recovery code'**
  String get recoveryRequestSubmitButton;

  /// T050 account-recovery request screen: client-side validation message.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email.'**
  String get recoveryRequestMissingFieldError;

  /// T050 account-recovery request screen: confirmation shown regardless of whether the account exists (no enumeration).
  ///
  /// In en, this message translates to:
  /// **'If that email has an account, a recovery code is on its way.'**
  String get recoveryRequestSuccessMessage;

  /// T050 account-recovery request screen: link to the confirm screen.
  ///
  /// In en, this message translates to:
  /// **'Already have a code?'**
  String get recoveryRequestGoToConfirmLink;

  /// T050 account-recovery confirm screen title.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get recoveryConfirmTitle;

  /// T050 account-recovery confirm screen: email field label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get recoveryConfirmEmailLabel;

  /// T050 account-recovery confirm screen: recovery-code field label.
  ///
  /// In en, this message translates to:
  /// **'Recovery code'**
  String get recoveryConfirmTokenLabel;

  /// T050 account-recovery confirm screen: new-password field label.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get recoveryConfirmNewPasswordLabel;

  /// T050 account-recovery confirm screen: submit button.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get recoveryConfirmSubmitButton;

  /// T050 account-recovery confirm screen: client-side validation message.
  ///
  /// In en, this message translates to:
  /// **'Please fill in every field.'**
  String get recoveryConfirmMissingFieldsError;

  /// T050 account-recovery confirm screen: success message.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset. You can sign in now.'**
  String get recoveryConfirmSuccessMessage;

  /// T049 sign-in/register screens: divider between the password form and social sign-in buttons.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get socialSignInDivider;

  /// T049 social sign-in button.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get socialSignInGoogleButton;

  /// T049 social sign-in button.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get socialSignInAppleButton;

  /// T049 social sign-in button.
  ///
  /// In en, this message translates to:
  /// **'Continue with Microsoft'**
  String get socialSignInMicrosoftButton;

  /// T049 social sign-in callback screen: shown while the redirect result is being processed.
  ///
  /// In en, this message translates to:
  /// **'Finishing sign-in…'**
  String get externalCallbackProcessingMessage;

  /// T049 social sign-in callback screen: shown when the provider redirected back with an error.
  ///
  /// In en, this message translates to:
  /// **'Sign-in with that provider didn\'t work. Please try again.'**
  String get externalCallbackErrorMessage;

  /// T049 social sign-in DOB-completion screen title.
  ///
  /// In en, this message translates to:
  /// **'Finish creating your account'**
  String get completeExternalRegistrationTitle;

  /// T049 social sign-in DOB-completion screen: instructions.
  ///
  /// In en, this message translates to:
  /// **'We just need your date of birth to finish setting up your account.'**
  String get completeExternalRegistrationBody;

  /// T049 social sign-in DOB-completion screen: display-name field label (used only if the provider didn't share one).
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get completeExternalRegistrationDisplayNameLabel;

  /// T049 social sign-in DOB-completion screen: date-of-birth field label.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get completeExternalRegistrationDateOfBirthLabel;

  /// T049 social sign-in DOB-completion screen: date-picker placeholder.
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get completeExternalRegistrationDateOfBirthHint;

  /// T049 social sign-in DOB-completion screen: submit button.
  ///
  /// In en, this message translates to:
  /// **'Finish creating account'**
  String get completeExternalRegistrationSubmitButton;

  /// T049 social sign-in DOB-completion screen: client-side validation message.
  ///
  /// In en, this message translates to:
  /// **'Please fill in every field.'**
  String get completeExternalRegistrationMissingFieldsError;

  /// T051 sessions screen title.
  ///
  /// In en, this message translates to:
  /// **'Active sessions'**
  String get sessionsTitle;

  /// T051 sessions screen: shown when the list is empty.
  ///
  /// In en, this message translates to:
  /// **'No active sessions.'**
  String get sessionsEmpty;

  /// T051 sessions screen: per-session last-active timestamp, pre-formatted by the caller.
  ///
  /// In en, this message translates to:
  /// **'Last active {when}'**
  String sessionsLastActive(String when);

  /// T051 sessions screen: per-session revoke button.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get sessionsRevokeButton;

  /// T052 account lifecycle screen title.
  ///
  /// In en, this message translates to:
  /// **'Deactivate account'**
  String get accountLifecycleTitle;

  /// T052 account lifecycle screen: explanation of the grace-period behavior (FR-003).
  ///
  /// In en, this message translates to:
  /// **'Deactivating your account signs you out of every device. You can reactivate any time by signing back in — after the grace period ends, your account and its data are permanently deleted.'**
  String get accountLifecycleGracePeriodExplanation;

  /// T052 account lifecycle screen: deactivate button.
  ///
  /// In en, this message translates to:
  /// **'Deactivate my account'**
  String get accountLifecycleDeactivateButton;

  /// T052 account lifecycle screen: deactivate confirmation dialog title.
  ///
  /// In en, this message translates to:
  /// **'Deactivate your account?'**
  String get accountLifecycleDeactivateConfirmTitle;

  /// T052 account lifecycle screen: deactivate confirmation dialog message.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be signed out of every device. You can reactivate any time before the grace period ends.'**
  String get accountLifecycleDeactivateConfirmMessage;

  /// T052/T053 confirmation dialogs: cancel button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get accountLifecycleCancelButton;

  /// T052 account lifecycle screen: confirmation message after deactivating.
  ///
  /// In en, this message translates to:
  /// **'Your account is now deactivated.'**
  String get accountLifecycleDeactivatedConfirmation;

  /// T052 account lifecycle screen: reactivate button.
  ///
  /// In en, this message translates to:
  /// **'Reactivate my account'**
  String get accountLifecycleReactivateButton;

  /// T052 account lifecycle screen: confirmation message after reactivating.
  ///
  /// In en, this message translates to:
  /// **'Your account is active again.'**
  String get accountLifecycleReactivatedConfirmation;

  /// T053 account data (export/delete) screen title.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get accountDataTitle;

  /// T053 account data screen: export button.
  ///
  /// In en, this message translates to:
  /// **'Export my data'**
  String get accountDataExportButton;

  /// T053 account data screen: the sole surface anywhere in the app that displays the raw date of birth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth: {dateOfBirth}'**
  String accountDataExportDateOfBirth(String dateOfBirth);

  /// T053 account data screen: exported email.
  ///
  /// In en, this message translates to:
  /// **'Email: {email}'**
  String accountDataExportEmail(String email);

  /// T053 account data screen: explanation above the delete button.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account is permanent and cannot be undone. Export your data first if you want to keep a copy.'**
  String get accountDataDeleteExplanation;

  /// T053 account data screen: delete button.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get accountDataDeleteButton;

  /// T053 account data screen: delete confirmation dialog title.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get accountDataDeleteConfirmTitle;

  /// T053 account data screen: delete confirmation dialog message.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and all its data. This cannot be undone.'**
  String get accountDataDeleteConfirmMessage;

  /// T161 account menu screen title, and the tooltip/gated-action label for the AppBar entry point that opens it.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountMenuTitle;

  /// T188 account menu: signs out of the current session and returns to Discover.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get accountMenuSignOutButton;

  /// T151 channel-preferences screen title.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get channelPreferencesTitle;

  /// T151 channel-preferences screen: email channel row label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get channelPreferencesEmailLabel;

  /// T151 channel-preferences screen: push channel row label (modeled in V1, no delivery until Phase 2).
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get channelPreferencesPushLabel;

  /// T187 MFA settings screen: instructions shown above the enrollment QR code.
  ///
  /// In en, this message translates to:
  /// **'Scan with any authenticator app (such as Google Authenticator, Microsoft Authenticator, or 1Password), then enter the 6-digit code it shows.'**
  String get mfaSettingsScanInstructions;

  /// T187 MFA settings screen: label above the manual-entry secret shown as a fallback beneath the QR code.
  ///
  /// In en, this message translates to:
  /// **'Can\'t scan the code? Enter this key manually instead:'**
  String get mfaSettingsManualKeyLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
