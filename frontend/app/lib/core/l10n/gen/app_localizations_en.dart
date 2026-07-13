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
}
