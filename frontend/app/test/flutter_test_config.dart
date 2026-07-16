// ADR-0005 (T177): global test setup, auto-applied by Flutter to every test
// in this directory tree (Flutter's own convention — no per-file wiring
// needed). Mocks flutter_secure_storage's platform channel so widget tests
// never touch the real native backend, which on a headless Linux VM (this
// package's `flutter test` target platform) depends on a running D-Bus
// secret-service that doesn't exist here — confirmed by direct reproduction:
// without this, the channel call either hangs indefinitely (breaking every
// test that pumps SpecPourApp, since sessionRestoreProvider's
// tokenStore.readRefreshToken() never resolves) or, once bounded with a real
// Timer-based timeout, trips Flutter's "Timer still pending after widget
// tree disposed" invariant on any test that finishes before the timeout
// fires. Mocked to always report "nothing stored" — the correct default for
// nearly every existing test, none of which are about session persistence.
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
        switch (call.method) {
          case 'read':
            return null;
          case 'readAll':
            return <String, String>{};
          case 'containsKey':
            return false;
          case 'isProtectedDataAvailable':
            return true;
          default:
            return null;
        }
      });

  await testMain();
}
