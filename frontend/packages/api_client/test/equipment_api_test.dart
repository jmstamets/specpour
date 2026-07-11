import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for EquipmentApi
void main() {
  final instance = ApiClient().getEquipmentApi();

  group(EquipmentApi, () {
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

  });
}
