import 'package:rapidpass_checkpoint/utils/base32_crockford.dart';
import 'package:rapidpass_checkpoint/utils/damm32.dart';

class ControlCode {
  final int value;

  ControlCode(this.value);

  int get checkDigit => Damm32.compute(this.value);

  @override
  String toString() {
    return crockford.encode(this.value).padLeft(7, '0') +
        crockford.encode(checkDigit);
  }

  @override
  bool operator ==(o) => o is ControlCode && o.value == this.value;

  @override
  int get hashCode => this.value.hashCode;

  /// Return `true` if the given control code string has a valid check digit
  static bool isValid(String controlCode) {
    final int length = controlCode.length;
    if (length != 8) return false;
    final String base = controlCode.substring(0, length - 1);
    final String actual = controlCode.substring(length - 1, length);
    final int controlCodeNumber = crockford.decode(base);
    final int damm32 = Damm32.compute(controlCodeNumber);
    final String checkDigit = crockford.encode(damm32);
    return checkDigit == actual;
  }

  /// Parse a control code string into a ControlCode
  /// Throws a FormatException if the given control code string is invalid
  static ControlCode parse(String controlCode) {
    final int length = controlCode.length;
    if (length != 8)
      throw FormatException('ControlCode "$controlCode" has invalid length');
    final String base = controlCode.substring(0, length - 1);
    final String actual = controlCode.substring(length - 1, length);
    final int controlCodeNumber = crockford.decode(base);
    final int damm32 = Damm32.compute(controlCodeNumber);
    final String checkDigit = crockford.encode(damm32);
    if (checkDigit != actual)
      throw FormatException(
          'ControlCode "$controlCode" has invalid check digit');
    return ControlCode(controlCodeNumber);
  }
}
