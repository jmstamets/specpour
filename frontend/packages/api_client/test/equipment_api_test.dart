import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for EquipmentApi
void main() {
  final instance = ApiClient().getEquipmentApi();

  group(EquipmentApi, () {
    // Author an equipment item in the caller's personal or bar library (T060, FR-024)
    //
    //Future<EquipmentAuthor> createEquipment(CreateEquipmentRequest createEquipmentRequest) async
    test('test createEquipment', () async {
      // TODO
    });

    // Delete one of the caller's own authored equipment items (T060)
    //
    //Future deleteEquipmentItem(String id) async
    test('test deleteEquipmentItem', () async {
      // TODO
    });

    // Get an equipment item's full detail (FR-024)
    //
    //Future<EquipmentDetail> getEquipmentItem(String id) async
    test('test getEquipmentItem', () async {
      // TODO
    });

    // Browse equipment (FR-024)
    //
    //Future<EquipmentPage> listEquipment({ String cursor, int limit }) async
    test('test listEquipment', () async {
      // TODO
    });

    // Update one of the caller's own authored equipment items (T060, FR-024)
    //
    //Future<EquipmentAuthor> updateEquipmentItem(String id, UpdateEquipmentRequest updateEquipmentRequest) async
    test('test updateEquipmentItem', () async {
      // TODO
    });

  });
}
