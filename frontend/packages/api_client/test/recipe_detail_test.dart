import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

// tests for RecipeDetail
void main() {
  final instance = RecipeDetailBuilder();
  // TODO add properties to the builder and call build()

  group(RecipeDetail, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String primaryName
    test('to test the property `primaryName`', () async {
      // TODO
    });

    // BuiltList<String> alternateNames
    test('to test the property `alternateNames`', () async {
      // TODO
    });

    // String familyKey
    test('to test the property `familyKey`', () async {
      // TODO
    });

    // BuiltList<String> categoryKeys
    test('to test the property `categoryKeys`', () async {
      // TODO
    });

    // BuiltList<String> flavorProfileKeys
    test('to test the property `flavorProfileKeys`', () async {
      // TODO
    });

    // BuiltList<String> tags
    test('to test the property `tags`', () async {
      // TODO
    });

    // BuiltList<RecipeIngredientLine> ingredientLines
    test('to test the property `ingredientLines`', () async {
      // TODO
    });

    // BuiltList<String> instructions
    test('to test the property `instructions`', () async {
      // TODO
    });

    // BuiltList<String> garnishes
    test('to test the property `garnishes`', () async {
      // TODO
    });

    // String iceSpec
    test('to test the property `iceSpec`', () async {
      // TODO
    });

    // BuiltList<EquipmentRef> glassware
    test('to test the property `glassware`', () async {
      // TODO
    });

    // BuiltList<EquipmentRef> equipment
    test('to test the property `equipment`', () async {
      // TODO
    });

    // String creatorAttribution
    test('to test the property `creatorAttribution`', () async {
      // TODO
    });

    // String history
    test('to test the property `history`', () async {
      // TODO
    });

    // String notes
    test('to test the property `notes`', () async {
      // TODO
    });

    // Derived — never stored, computed at read time from ingredient composition and method dilution (FR-022).
    // num abvPercent
    test('to test the property `abvPercent`', () async {
      // TODO
    });

    // num standardDrinks
    test('to test the property `standardDrinks`', () async {
      // TODO
    });

    // Rolled up from ingredient allergen attributes, conservative for uncertain (FR-055).
    // BuiltList<String> allergens
    test('to test the property `allergens`', () async {
      // TODO
    });

  });
}
