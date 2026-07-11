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
}
