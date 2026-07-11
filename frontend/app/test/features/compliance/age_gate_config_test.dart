import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/features/compliance/age_gate_config.dart';

void main() {
  group('isOfLegalAge', () {
    final now = DateTime(2026, 6, 15);

    test('is true the day the threshold birthday is reached', () {
      final dateOfBirth = DateTime(2005, 6, 15); // exactly 21 today
      expect(isOfLegalAge(dateOfBirth, 21, now: now), isTrue);
    });

    test('is false the day before the threshold birthday', () {
      final dateOfBirth = DateTime(2005, 6, 16); // turns 21 tomorrow
      expect(isOfLegalAge(dateOfBirth, 21, now: now), isFalse);
    });

    test('is true the day after the threshold birthday', () {
      final dateOfBirth = DateTime(2005, 6, 14); // turned 21 yesterday
      expect(isOfLegalAge(dateOfBirth, 21, now: now), isTrue);
    });

    test('is false for a clearly underage date of birth', () {
      final dateOfBirth = DateTime(2015, 1, 1);
      expect(isOfLegalAge(dateOfBirth, 21, now: now), isFalse);
    });

    test('handles a leap-day date of birth correctly', () {
      final dateOfBirth = DateTime(2004, 2, 29);
      expect(isOfLegalAge(dateOfBirth, 21, now: DateTime(2025, 3, 1)), isTrue);
      expect(
        isOfLegalAge(dateOfBirth, 21, now: DateTime(2025, 2, 28)),
        isFalse,
      );
    });
  });
}
