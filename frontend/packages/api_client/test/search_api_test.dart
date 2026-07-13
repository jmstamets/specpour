import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for SearchApi
void main() {
  final instance = ApiClient().getSearchApi();

  group(SearchApi, () {
    // Full-text search across recipes, ingredients, equipment, glossary terms, and articles (FR-049)
    //
    // Guest-accessible (FR-004b). Search itself owns no schema and has no opinion on content facets (T141 ADR) — this endpoint returns entity references only (`entityType`/`entityId`); fetch the full record from that entity's own GET-by-id endpoint. Content-facet filtering composition lands in T148/T149.
    //
    //Future<SearchResultPage> search({ String q, String uses, String cursor, int limit }) async
    test('test search', () async {
      // TODO
    });

  });
}
