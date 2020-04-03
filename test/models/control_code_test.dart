import 'package:rapidpass_checkpoint/models/control_code.dart';
import 'package:test/test.dart';

void main() {
  test('ControlCode.isValid() works', () {
    expect(ControlCode.isValid('2A8B043S'), isTrue);
    expect(ControlCode.isValid('2A8B043T'), isFalse);
  });
  test('ControlCode.parse() works', () {
    expect(ControlCode.parse('2A8B043S'), equals(ControlCode(2491777155)));
  });
}
