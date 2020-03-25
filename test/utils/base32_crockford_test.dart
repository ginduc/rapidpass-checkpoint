import 'package:rapidpass_checkpoint/utils/base32_crockford.dart';
import 'package:test/test.dart';

void main() {
  test('Base32Crockford.encode(int) works', () {
    final String encoded = crockford.encode(987654321);
    expect(encoded, equals('XDWT5H'));
  });
  test('normalize() works', () {
    final testCases = {
      '': '',
      '0': '0',
      '0123456789abcdefgHJKMNPQRSTUVwxyz': '0123456789ABCDEFGHJKMNPQRSTUVWXYZ',
      'ILilOo': '111100'
    };
    testCases.forEach((input, expected) {
      expect(normalize(input), equals(expected));
    });
  });
  test('Base32Crockford.decode(String) works', () {
    final testCases = {
      '': 0,
      '0': 0,
      'Z': 31,
      '10': 32,
      'abc091': int.parse('abc091', radix: 32),
      'ILilOo': int.parse('111100', radix: 32)
    };
    testCases.forEach((input, expected) {
      expect(crockford.decode(input), equals(expected));
    });
  });
}
