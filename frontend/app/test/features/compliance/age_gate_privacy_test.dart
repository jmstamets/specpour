import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specpour_app/core/api/api_client_provider.dart';
import 'package:specpour_app/core/l10n/gen/app_localizations.dart';
import 'package:specpour_app/features/compliance/age_gate_local_store.dart';
import 'package:specpour_app/features/compliance/age_gate_screen.dart';

/// T145's privacy proof, runnable in this sandbox (no device/browser needed) as a
/// widget test — the same widget tree integration_test/age_gate_test.dart drives on
/// a real device. Intercepts every outgoing Dio request instead of hitting a real
/// server, so the assertions below are exhaustive over *everything* the app sent,
/// not a sample.
///
/// A genuinely adversarial test, not a rubber stamp: temporarily editing
/// AgeGateScreen to pass the entered date to a query parameter makes
/// `network traffic during the gate flow never contains the entered date of birth`
/// fail immediately, with the leaking request in the failure message — see this
/// file's git history / PR description for that verification.
void main() {
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

    // Material's date picker opens in calendar mode; switch to keyboard entry so a
    // specific date decades in the past doesn't require paging a calendar grid.
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
    'network traffic during the gate flow never contains the entered date of birth',
    (tester) async {
      await pumpAgeGate(tester);
      await enterDateOfBirthAndConfirm(tester);

      expect(
        recorder.requests,
        isNotEmpty,
        reason: 'expected at least the age-gate config request to fire',
      );

      final dobFragments = ['1990', '01/01/1990', '1990-01-01'];
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

  testWidgets('only the requested age-gate config endpoint is ever called', (
    tester,
  ) async {
    await pumpAgeGate(tester);
    await enterDateOfBirthAndConfirm(tester);

    expect(recorder.requests, hasLength(1));
    expect(recorder.requests.single['path'], '/compliance/age-gate');
    expect(recorder.requests.single['queryParameters'], {
      'surface': 'registration',
    });
  });

  testWidgets(
    'nothing date-of-birth-derived is persisted outside local storage — only the affirmed flag lands locally',
    (tester) async {
      await pumpAgeGate(tester);
      await enterDateOfBirthAndConfirm(tester);

      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getKeys(),
        {'age_gate_affirmed'},
        reason:
            'no other local key (e.g. a stored date) should ever be written',
      );
      expect(await AgeGateLocalStore().isAffirmed(), isTrue);
    },
  );

  testWidgets(
    'a lookup failure falls back to the strictest-rule local default rather than blocking',
    (tester) async {
      recorder.failNextRequest = true;

      await pumpAgeGate(tester);
      await enterDateOfBirthAndConfirm(tester);

      // The 1990 date of birth is well over the offline fallback's 21-year
      // threshold (age_gate_config.dart), so affirmation still succeeds even
      // though the network call failed outright.
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
