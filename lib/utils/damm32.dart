/// Base32 conversion
class Base32 {
  static List<int> toRadixDigits(final int i) {
    final int rem = i >> 5; // div 32
    final int digit = i & 0x1F;
    if (rem > 0) {
      final list = toRadixDigits(rem);
      list.add(digit);
      return list;
    } else {
      return [digit];
    }
  }
}

const modulus = 1 << 5; // 32
const mask = modulus | 5; // 32 | mask[5 - 2] => 32 | 5 => 37

/// Damm check digit calculator for base 32, based on Python code at:
/// https://stackoverflow.com/questions/23431621/extending-the-damm-algorithm-to-base-32#answer-23433934
class Damm32 {
  static int checkDigit(int n) {
    final digits = Base32.toRadixDigits(n);
    var checkDigit = 0;
    for (final digit in digits) {
      checkDigit ^= digit;
      checkDigit <<= 1;
      if (checkDigit >= modulus) {
        checkDigit ^= mask;
      }
    }
    return checkDigit;
  }
}
