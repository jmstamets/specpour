import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for IngredientsApi
void main() {
  final instance = ApiClient().getIngredientsApi();

  group(IngredientsApi, () {
    // Author an ingredient in the caller's personal or bar library, optionally house-made (T059, FR-012/FR-017)
    //
    //Future<IngredientAuthor> createIngredient(CreateIngredientRequest createIngredientRequest) async
    test('test createIngredient', () async {
      // TODO
    });

    // Delete one of the caller's own authored ingredients (T059)
    //
    //Future deleteIngredient(String id) async
    test('test deleteIngredient', () async {
      // TODO
    });

    // Get an ingredient's full detail, including allergen attributes (FR-016)
    //
    //Future<IngredientDetail> getIngredient(String id) async
    test('test getIngredient', () async {
      // TODO
    });

    // Recipes using this ingredient, hierarchy-aware (T155, FR-014a)
    //
    // A class-level ingredient (e.g. \"Rum\") lists recipes using it or any descendant (\"Aged Rum\", \"White Rum\", ...) — mirrors FR-024's equipment-to-recipes linking. Unpaginated: a single ingredient's usage list is small at V1 scale.
    //
    //Future<IngredientRecipes> getIngredientRecipes(String id) async
    test('test getIngredientRecipes', () async {
      // TODO
    });

    // Browse ingredients (FR-014)
    //
    //Future<IngredientPage> listIngredients({ String category, String scope, String cursor, int limit }) async
    test('test listIngredients', () async {
      // TODO
    });

    // Update one of the caller's own authored ingredients (T059, FR-012/FR-017)
    //
    // Rejects (400) a house-made defining recipe change that would transitively include this ingredient itself (FR-017's circular-reference edge case).
    //
    //Future<IngredientAuthor> updateIngredient(String id, UpdateIngredientRequest updateIngredientRequest) async
    test('test updateIngredient', () async {
      // TODO
    });

  });
}
