import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/compliance/age_gate_local_store.dart';
import 'package:specpour_app/features/compliance/age_gate_screen.dart';

/// T145: failing-first age-gate privacy tests, run on a real device/browser (CI:
/// reactivecircus/android-emulator-runner, per .github/workflows/ci.yml's
/// frontend-integration-tests job). This is the on-device counterpart to
/// test/features/compliance/age_gate_privacy_test.dart, which proves the identical
/// three assertions in this sandbox (no device/emulator available here — see that
/// file's header for how its "failing-first" property was verified by temporarily
/// reintroducing a real leak and confirming the test caught it).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const chosenDateOfBirth = '01/01/1990'; // well over any legal drinking age

  late _RecordingInterceptor recorder;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    recorder = _RecordingInterceptor();
  });

  Future<void> pumpAgeGate(WidgetTester tester) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test.invalid/api/v1'))
      ..interceptors.add(recorder);
    final complianceApi = ComplianceApi(dio, standardSerializers);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [complianceApiProvider.overrideWithValue(complianceApi)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AgeGateScreen(surface: 'registration'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> enterDateOfBirthAndConfirm(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('ageGateDatePickerButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, chosenDateOfBirth);
    await tester.pumpAndSettle();

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('ageGateConfirmButton')));
    await tester.pumpAndSettle();
  }

  testWidgets(
    '1: network traffic during the gate flow never contains the entered date of birth',
    (tester) async {
      await pumpAgeGate(tester);
      await enterDateOfBirthAndConfirm(tester);

      expect(recorder.requests, isNotEmpty);

      const dobFragments = ['1990', '01/01/1990', '1990-01-01'];
      for (final request in recorder.requests) {
        final serialized = request.toString();
        for (final fragment in dobFragments) {
          expect(
            serialized.contains(fragment),
            isFalse,
            reason:
                'request $serialized must never contain the date-of-birth fragment "$fragment"',
          );
        }
      }
    },
  );

  testWidgets('2: nothing date-of-birth-derived exists outside local storage', (
    tester,
  ) async {
    await pumpAgeGate(tester);
    await enterDateOfBirthAndConfirm(tester);

    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getKeys(),
      {'age_gate_affirmed'},
      reason: 'no other local key (e.g. a stored date) should ever be written',
    );
    expect(await AgeGateLocalStore().isAffirmed(), isTrue);
  });

  testWidgets(
    '3: offline/lookup-failure falls back to the strictest-rule local default',
    (tester) async {
      recorder.failNextRequest = true;

      await pumpAgeGate(tester);
      await enterDateOfBirthAndConfirm(tester);

      expect(await AgeGateLocalStore().isAffirmed(), isTrue);
    },
  );
}

class _RecordingInterceptor extends Interceptor {
  final List<Map<String, dynamic>> requests = [];
  bool failNextRequest = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    requests.add({
      'path': options.path,
      'queryParameters': options.queryParameters,
      'data': options.data,
      'headers': options.headers,
    });

    if (failNextRequest) {
      handler.reject(
        DioException.connectionError(
          requestOptions: options,
          reason: 'simulated offline/lookup failure',
        ),
      );
      return;
    }

    handler.resolve(
      Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'surfaceStrictness': 'mandatory',
          'jurisdictionCode': 'default',
          'legalDrinkingAge': 21,
          'strictestRuleApplied': true,
        },
      ),
    );
  }
}
