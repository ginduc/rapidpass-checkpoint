import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:moor/moor.dart';
import 'package:rapidpass_checkpoint/utils/hmac_sha256.dart';
import 'package:test/test.dart';

void main() {
  test('HmacShac256.validateSignature() works', () {
    final Uint8List hmacSha256SigningKey = hex.decode(
        'a993cb123b3ba87bf06c22365bfa0951e2521fcff5990b42dacf7c4b55e83a42');

    final testCases = {
      '0EkTqZtyXlqKgF6q9gAHTkFaMjA3MGxRlmM=': true,
      'R08dFxeqXlqKgF6q9gAHQUJDMTIzNKqIOIY=': true,
      'R08dFxeqXlqKgF6q9gAHQUJDMTIzNKqIOI0=': false,
    };
    testCases.forEach((input, expected) {
      final decodedFromBase64 = base64.decode(input);
      expect(
          HmacShac256.validateSignature(
              hmacSha256SigningKey, decodedFromBase64),
          equals(expected));
    });
  });
}
