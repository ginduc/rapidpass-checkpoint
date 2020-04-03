// quick dirty code, please enhance if needed

import 'dart:math';

class IMEIGenerator {
  static int luhnChecksum(String digits) {
    int sum = 0;
    int length = digits.length;
    for (int i = 0; i < length; i++) {
      int digit = int.parse(digits[(length - i) - 1]);
      if ((i % 2) == 1) {
        digit *= 2;
      }
      sum += ((digit > 9) ? (digit - 9) : digit);
    }
    return sum % 10;
  }

  static String generateIMEI() {
    // https://en.wikipedia.org/wiki/Reporting_Body_Identifier
    List<String> rbi = ['01', '10', '30', '33', '35', '44', '45', '49', '50', '51', '52', '53', '54', '86', '91', '98', '99'];

    Random random = Random.secure();

    // generate 12 random number
    List<int> randomDigits = List<int>.generate(12, (i) => random.nextInt(10));

    int index = random.nextInt(rbi.length); // pick random rbi

    String digits = rbi[index] +
        randomDigits
            .join(); // create string from first 2 digit rbi and 12 random digits

    int checksum = luhnChecksum(digits + '0');

    int checkdigit = (checksum == 0) ? 0 : 10 - checksum;

    return digits + checkdigit.toString(); // generated imei with checkdigit
  }
}
