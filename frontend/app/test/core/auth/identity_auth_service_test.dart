import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/core/auth/identity_auth_service.dart';

/// T170 (Phase 4 walkthrough finding #2): describeIdentityError/describeApiError
/// are the single funnel every screen's catch block goes through — verified
/// directly rather than only incidentally through a widget test, matching the
/// TokenRefreshInterceptor precedent.
void main() {
  DioException problemJson(int status, Map<String, dynamic> body) {
    final options = RequestOptions(path: '/test');
    return DioException(
      requestOptions: options,
      response: Response(
        requestOptions: options,
        statusCode: status,
        data: body,
      ),
    );
  }

  group('a forced 500 never renders exception text', () {
    test('a 500 with a JSON body still gets the generic message', () {
      final error = problemJson(500, {
        'title': 'An error occurred while processing your request.',
        'detail': 'NullReferenceException at Foo.Bar.Baz line 42',
        'correlationId': 'corr-abc-123',
      });

      final result = describeApiError(error);

      expect(
        result.message,
        isNot(contains('NullReferenceException')),
        reason: 'the raw exception detail must never reach the user',
      );
      expect(result.correlationId, 'corr-abc-123');
      expect(describeIdentityError(error), contains('corr-abc-123'));
    });

    test(
      'a 500 with an unparseable (non-JSON) body gets the generic message',
      () {
        final options = RequestOptions(path: '/test');
        final error = DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 500,
            // Development's UseDeveloperExceptionPage returns an HTML page, not
            // problem+json — this is what that looks like to the client.
            data: '<html><body>Unhandled exception at line 42...</body></html>',
          ),
        );

        final result = describeApiError(error);

        expect(result.message, isNot(contains('Unhandled exception')));
        expect(result.message, isNot(contains('<html>')));
      },
    );

    test(
      'a connection error (no response at all) never surfaces Dio internals',
      () {
        final options = RequestOptions(path: '/test');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'Connection refused',
        );

        final result = describeApiError(error);

        expect(result.message, isNot(contains('connectionError')));
        expect(result.message, isNot(contains('Connection refused')));
        expect(result.correlationId, isNull);
      },
    );

    test(
      'a non-DioException (unexpected) error also gets the generic message',
      () {
        final result = describeApiError(
          StateError('some internal invariant broke'),
        );

        expect(result.message, isNot(contains('StateError')));
        expect(result.message, isNot(contains('invariant')));
      },
    );
  });

  group('4xx validation/business errors stay friendly, no correlation ID', () {
    test('a 400 with detail uses it verbatim and shows no correlation ID', () {
      final error = problemJson(400, {
        'title': 'Registration failed',
        'detail': 'Passwords must be at least 12 characters.',
        'correlationId': 'corr-should-not-appear',
      });

      final result = describeApiError(error);

      expect(result.message, 'Passwords must be at least 12 characters.');
      expect(result.correlationId, isNull);
      expect(
        describeIdentityError(error),
        isNot(contains('corr-should-not-appear')),
        reason: 'routine validation errors should not surface a reference id',
      );
    });

    test(
      'field-level errors (if ever returned) are joined into one message',
      () {
        final error = problemJson(400, {
          'title': 'Validation failed',
          'errors': {
            'email': ['Email is required.'],
            'password': ['Password is too short.'],
          },
        });

        final result = describeApiError(error);

        expect(result.message, contains('Email is required.'));
        expect(result.message, contains('Password is too short.'));
      },
    );

    test('falls back to title when detail is missing', () {
      final error = problemJson(403, {'title': 'Forbidden'});

      expect(describeApiError(error).message, 'Forbidden');
    });
  });
}
