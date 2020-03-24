import 'package:rapidpass_checkpoint/utils/base32_crockford.dart';
import 'package:test/test.dart';

void main() {
  test('Base32Crockford.encode(int) works', () {
    final String encoded = crockford.encode(1);
  });
}
