import 'package:rapidpass_checkpoint/utils/damm32.dart';
import 'package:test/test.dart';

void main() {
  test('Base32.toRadixDigits() works', () {
    final testCases = {
      0: [0],
      1: [1],
      31: [31],
      32: [1, 0],
      63: [1, 31],
      64: [2, 0],
      1024: [1, 0, 0],
      1091: [1, 2, 3],
      2491777155: [2, 10, 8, 11, 0, 4, 3]
    };
    testCases.forEach((input, expected) {
      expect(Base32.toRadixDigits(input), equals(expected));
    });
  });
  test('Damm32.compute() works', () {
    final testCases = {
      0: 0,
      1: 2,
      31: 27,
      32: 4,
      63: 31,
      64: 8,
      1024: 8,
      1091: 6,
      2491777155: 25
    };
    testCases.forEach((input, expected) {
      expect(Damm32.compute(input), equals(expected));
    });
  });
  test('Damm32.check() works', () {
    final testCases = {
      0: 0,
      1: 2,
      31: 27,
      32: 4,
      63: 31,
      64: 8,
      1024: 8,
      1091: 6,
      2491777155: 25
    };
    testCases.forEach((n, digit) {
      expect(Damm32.check(n, digit), isTrue);
    });
  });
}
