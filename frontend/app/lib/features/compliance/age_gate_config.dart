/// T144: the age-gate decision the client renders against. Never carries a DOB —
/// only the threshold and where it came from.
class AgeGateConfig {
  const AgeGateConfig({
    required this.legalDrinkingAge,
    required this.strictestRuleApplied,
    required this.jurisdictionCode,
  });

  final int legalDrinkingAge;
  final bool strictestRuleApplied;
  final String jurisdictionCode;

  /// T144's required fallback: "strictest-rule fallback when the jurisdiction call
  /// fails or the device is offline." 21 matches the backend's own
  /// JurisdictionRule.DefaultCode seed (compliance module, T020) — the two defaults
  /// are independently maintained but intentionally kept equal; this one exists
  /// specifically for when the server can't be reached at all, so it can never
  /// simply read the server's value.
  static const AgeGateConfig offlineFallback = AgeGateConfig(
    legalDrinkingAge: 21,
    strictestRuleApplied: true,
    jurisdictionCode: 'offline-default',
  );
}

/// Pure, locally-computed age check — the ONLY place a date of birth is ever
/// compared to anything. Never called with a value that leaves this device.
bool isOfLegalAge(DateTime dateOfBirth, int legalDrinkingAge, {DateTime? now}) {
  final today = now ?? DateTime.now();
  var age = today.year - dateOfBirth.year;
  final birthdayNotYetReachedThisYear =
      today.month < dateOfBirth.month ||
      (today.month == dateOfBirth.month && today.day < dateOfBirth.day);
  if (birthdayNotYetReachedThisYear) {
    age--;
  }
  return age >= legalDrinkingAge;
}
