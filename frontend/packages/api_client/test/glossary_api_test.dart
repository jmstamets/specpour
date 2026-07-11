import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for GlossaryApi
void main() {
  final instance = ApiClient().getGlossaryApi();

  group(GlossaryApi, () {
    // Get an article's full body (FR-026)
    //
    //Future<GlossaryArticleDetail> getGlossaryArticle(String id) async
    test('test getGlossaryArticle', () async {
      // TODO
    });

    // Resolve auto-link matches for a block of content (FR-027)
    //
    // Best-effort automated matching: first occurrence per term, longest-match-wins on overlapping terms, curator Suppress/Force overrides applied per `context`. Auto-links are computed at render time from the live term list, never stored.
    //
    //Future<AutoLinkResponse> getGlossaryAutolink(String context, String content) async
    test('test getGlossaryAutolink', () async {
      // TODO
    });

    // Get a glossary term's ordered, numbered definitions (FR-025)
    //
    //Future<GlossaryTermDetail> getGlossaryTerm(String id) async
    test('test getGlossaryTerm', () async {
      // TODO
    });

    // Browse glossary articles (FR-026)
    //
    //Future<GlossaryArticlePage> listGlossaryArticles({ String cursor, int limit }) async
    test('test listGlossaryArticles', () async {
      // TODO
    });

    // Browse glossary terms (FR-025)
    //
    //Future<GlossaryTermPage> listGlossaryTerms({ String cursor, int limit }) async
    test('test listGlossaryTerms', () async {
      // TODO
    });

  });
}
