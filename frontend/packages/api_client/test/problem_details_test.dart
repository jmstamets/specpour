import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

// tests for ProblemDetails
void main() {
  final instance = ProblemDetailsBuilder();
  // TODO add properties to the builder and call build()

  group(ProblemDetails, () {
    // A URI identifying the problem type. \"about:blank\" if none is more specific.
    // String type
    test('to test the property `type`', () async {
      // TODO
    });

    // Short, human-readable summary of the problem type.
    // String title
    test('to test the property `title`', () async {
      // TODO
    });

    // The HTTP status code.
    // int status
    test('to test the property `status`', () async {
      // TODO
    });

    // Human-readable explanation specific to this occurrence.
    // String detail
    test('to test the property `detail`', () async {
      // TODO
    });

    // A URI identifying the specific occurrence of the problem.
    // String instance
    test('to test the property `instance`', () async {
      // TODO
    });

    // Correlation ID propagated from request tracing (OTel), for support/debugging.
    // String correlationId
    test('to test the property `correlationId`', () async {
      // TODO
    });

  });
}
