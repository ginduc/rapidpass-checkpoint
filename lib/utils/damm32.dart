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
  static int compute(final int n) {
    final digits = Base32.toRadixDigits(n);
    var checkDigit = 0;
    for (final digit in digits) {
      checkDigit = _nextDigit(checkDigit, digit);
    }
    return checkDigit;
  }

  static bool check(final int n, final int digit) {
    final digits = Base32.toRadixDigits(n);
    return compute(n) == digit; // _nextDigit(checkDigit, digit) == 0;
  }

  static int _nextDigit(final int checkDigit, final int digit) {
    var next = checkDigit;
    next ^= digit;
    next <<= 1;
    if (next >= modulus) {
      next ^= mask;
    }
    return next;
  }
}
