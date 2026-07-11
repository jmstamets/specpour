import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for NotificationsApi
void main() {
  final instance = ApiClient().getNotificationsApi();

  group(NotificationsApi, () {
    // Get the caller's inbox messages
    //
    // Cursor-paginated in-app inbox (FR-040a) — the always-on notification channel. Email is the V1 opt-in alert channel (also carrying identity transactional mail); push delivery is modeled but deferred to Phase 2.
    //
    //Future<InboxPage> getInbox({ String cursor, int limit }) async
    test('test getInbox', () async {
      // TODO
    });

  });
}
