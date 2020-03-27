import 'package:intl/intl.dart';
import 'package:rapidpass_checkpoint/utils/base32_crockford.dart';

class QrData {
  final int passType;
  final int controlCode;
  final int validFrom;
  final int validUntil;
  final String idOrPlate;

  QrData(this.passType, this.controlCode, this.validFrom, this.validUntil,
      this.idOrPlate);

  @override
  String toString() {
    return "%{pass_type: $passType, control_code: $controlCode, "
        "valid_from: $validFrom, valid_until: $validUntil, "
        "id_or_plate: '$idOrPlate'}";
  }

  String controlCodeAsString() {
    // TODO: Compute and append check digit
    return crockford.encode(this.controlCode);
  }

  final displayPurpose = {'M': 'Medical (M)', 'V': 'VIP (V)'};

  String purposeCode() {
    return String.fromCharCode(passType & 0x7F);
  }

  String purpose() {
    final purposeCode = this.purposeCode();
    return displayPurpose.containsKey(purposeCode)
        ? displayPurpose[purposeCode]
        : purposeCode;
  }

  final DateFormat dateFormat = DateFormat.yMMMd('en_US');

  String validFromDisplayDate() {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(this.validFrom * 1000);
    return dateFormat.format(dateTime);
  }

  String validUntilDisplayDate() {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(this.validUntil * 1000);
    return dateFormat.format(dateTime);
  }
}
