import 'package:flutter_test/flutter_test.dart';
import 'package:ukcs_app/core/utils/utilities.dart';

void main() {
  group('Utilities.formatMonth', () {
    test('should return empty string when input is empty', () {
      final result = Utilities.formatMonth('');
      expect(result, equals(''));
    });

    test('should parse and format a valid date string correctly', () {
      final result = Utilities.formatMonth('2023-05');
      expect(result, equals('May 2023'));
    });

    test('should parse and format another valid date string correctly', () {
      final result = Utilities.formatMonth('2026-12');
      expect(result, equals('December 2026'));
    });

    test(
      'should throw FormatException or RangeError when format is invalid',
      () {
        expect(
          () => Utilities.formatMonth('invalid'),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
