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

    // Get the caller's notification channel opt-in preferences
    //
    // Email is the V1 opt-in alert channel (FR-040a); the push preference is modeled here but push delivery is deferred to Phase 2, so opting into push has no delivery effect in V1.
    //
    //Future<ChannelPreferences> getMyChannelPreferences() async
    test('test getMyChannelPreferences', () async {
      // TODO
    });

    // Mark an inbox message as read
    //
    // Sets the message's read timestamp. Idempotent — marking an already-read message again succeeds without changing the original readAt.
    //
    //Future markInboxMessageRead(String id) async
    test('test markInboxMessageRead', () async {
      // TODO
    });

    // Update the caller's notification channel opt-in preferences
    //
    //Future<ChannelPreferences> updateMyChannelPreferences(ChannelPreferencesUpdate channelPreferencesUpdate) async
    test('test updateMyChannelPreferences', () async {
      // TODO
    });

  });
}
