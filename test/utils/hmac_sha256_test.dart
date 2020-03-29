import 'dart:convert';

import 'package:rapidpass_checkpoint/utils/hmac_sha256.dart';
import 'package:test/test.dart';

void main() {
  test('HmacShac256.validateSignature() works', () {
    final testCases = {
      '0EkTqZtyXlqKgF6q9gAHTkFaMjA3MGxRlmM=': true,
      'R08dFxeqXlqKgF6q9gAHQUJDMTIzNKqIOIY=': true,
      'R08dFxeqXlqKgF6q9gAHQUJDMTIzNKqIOI0=': false,
    };
    testCases.forEach((input, expected) {
      final decodedFromBase64 = base64.decode(input);
      expect(
          HmacShac256.validateSignature(decodedFromBase64), equals(expected));
    });
  });
}
