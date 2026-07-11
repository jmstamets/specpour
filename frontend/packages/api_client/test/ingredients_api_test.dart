import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for IngredientsApi
void main() {
  final instance = ApiClient().getIngredientsApi();

  group(IngredientsApi, () {
    // Get an ingredient's full detail, including allergen attributes (FR-016)
    //
    //Future<IngredientDetail> getIngredient(String id) async
    test('test getIngredient', () async {
      // TODO
    });

    // Browse ingredients (FR-014)
    //
    //Future<IngredientPage> listIngredients({ String category, String cursor, int limit }) async
    test('test listIngredients', () async {
      // TODO
    });

  });
}
