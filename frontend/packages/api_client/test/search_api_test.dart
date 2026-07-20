import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for SearchApi
void main() {
  final instance = ApiClient().getSearchApi();

  group(SearchApi, () {
    // Full-text search across recipes, ingredients, equipment, glossary terms, and articles (FR-049)
    //
    // Guest-accessible (FR-004b) unless `makeable=true` is used. Search itself owns no schema and has no opinion on content facets (T141 ADR) — this endpoint returns entity references only (`entityType`/`entityId`); fetch the full record from that entity's own GET-by-id endpoint. Rating-facet composition lands in T149. `q` returning nothing is a pre-existing adapter limitation, not a facet bug — this endpoint requires non-empty text; browsing (no `q`) is `GET /recipes`'s job, not this one's.
    //
    //Future<SearchResultPage> search({ String q, String uses, String makeable, String cursor, int limit }) async
    test('test search', () async {
      // TODO
    });

  });
}
