// T157: resolvers mapping backend content keys (family taxonomy NameKeys,
// allergen keys) to localized display strings. The backend convention is
// "send i18n keys, never display copy" (Tier.DisplayNameKey, Allergen.DisplayNameKey,
// T150's MessageContentKey all follow it); the client resolves known keys via ARB
// and falls back to a humanized form of the key for curator-added vocabulary the
// shipped client doesn't know yet — a raw key must never reach the screen
// (constitution Principle VIII; enforced by the key-shaped rendering assertion in
// the test suites).

import 'gen/app_localizations.dart';

/// Resolves a Family taxonomy key (e.g. "family.sour") to its display name.
String resolveFamilyDisplayName(AppLocalizations l10n, String key) {
  return switch (key) {
    'family.cocktail' => l10n.familyCocktail,
    'family.spiritForward' => l10n.familySpiritForward,
    'family.sour' => l10n.familySour,
    'family.highball' => l10n.familyHighball,
    'family.cobbler' => l10n.familyCobbler,
    'family.julep' => l10n.familyJulep,
    'family.smash' => l10n.familySmash,
    'family.flip' => l10n.familyFlip,
    'family.nog' => l10n.familyNog,
    _ => humanizeContentKey(key),
  };
}

/// Resolves an allergen key (e.g. "treeNut") to its display name.
String resolveAllergenDisplayName(AppLocalizations l10n, String key) {
  return switch (key) {
    'egg' => l10n.allergenEgg,
    'dairy' => l10n.allergenDairy,
    'treeNut' => l10n.allergenTreeNut,
    'peanut' => l10n.allergenPeanut,
    'gluten' => l10n.allergenGluten,
    'sulfites' => l10n.allergenSulfites,
    _ => humanizeContentKey(key),
  };
}

/// Fallback for curator-added vocabulary the shipped client has no ARB entry
/// for: takes the key's last dotted segment, splits camelCase, and capitalizes —
/// "family.newOrleansSour" -> "New Orleans Sour". Readable (and never
/// key-shaped), if unavoidably untranslated until the next client release adds a
/// proper ARB entry.
String humanizeContentKey(String key) {
  final segment = key.split('.').last;
  final words = segment
      .replaceAllMapped(RegExp('([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .split(RegExp(r'[\s_-]+'))
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');
  return words.isEmpty ? key : words;
}
