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
