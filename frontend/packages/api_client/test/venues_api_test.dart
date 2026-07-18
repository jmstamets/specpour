import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for VenuesApi
void main() {
  final instance = ApiClient().getVenuesApi();

  group(VenuesApi, () {
    // Create a venue owned by the caller (T061, FR-058)
    //
    //Future<Venue> createVenue(CreateVenueRequest createVenueRequest) async
    test('test createVenue', () async {
      // TODO
    });

    // Delete one of the caller's venues (T061, FR-058)
    //
    //Future deleteVenue(String id) async
    test('test deleteVenue', () async {
      // TODO
    });

    // Get one of the caller's venues by id (T061, FR-058)
    //
    //Future<Venue> getVenue(String id) async
    test('test getVenue', () async {
      // TODO
    });

    // List the caller's venues (T061, FR-058)
    //
    //Future<VenuePage> listVenues({ String cursor, int limit }) async
    test('test listVenues', () async {
      // TODO
    });

    // Update one of the caller's venues (T061, FR-058)
    //
    //Future<Venue> updateVenue(String id, UpdateVenueRequest updateVenueRequest) async
    test('test updateVenue', () async {
      // TODO
    });

  });
}
