import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for InventoryApi
void main() {
  final instance = ApiClient().getInventoryApi();

  group(InventoryApi, () {
    // Add an item to the caller's personal inventory, or a venue's inventory the caller owns (T066, FR-029/FR-030)
    //
    //Future<InventoryItem> createInventoryItem(CreateInventoryItemRequest createInventoryItemRequest) async
    test('test createInventoryItem', () async {
      // TODO
    });

    // Remove one of the caller's own inventory items (T066, FR-029)
    //
    //Future deleteInventoryItem(String id) async
    test('test deleteInventoryItem', () async {
      // TODO
    });

    // Get one of the caller's own inventory items by id (T066, FR-029)
    //
    //Future<InventoryItem> getInventoryItem(String id) async
    test('test getInventoryItem', () async {
      // TODO
    });

    // List the caller's own inventory, or a venue's inventory the caller owns (T066, FR-029)
    //
    //Future<InventoryItemPage> listInventoryItems({ String venueId, String cursor, int limit }) async
    test('test listInventoryItems', () async {
      // TODO
    });

    // Update the quantity/bottle size of one of the caller's own inventory items (T066, FR-029)
    //
    //Future<InventoryItem> updateInventoryItem(String id, UpdateInventoryItemRequest updateInventoryItemRequest) async
    test('test updateInventoryItem', () async {
      // TODO
    });

  });
}
