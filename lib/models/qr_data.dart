import 'package:intl/intl.dart';
import 'package:rapidpass_checkpoint/utils/base32_crockford.dart';
import 'package:rapidpass_checkpoint/utils/damm32.dart';

const CrockfordEncoder paddedEncoder = const CrockfordEncoder(7);

class QrData {
  final int passType;
  final String apor;
  final int controlCode;
  final int validFrom;
  final int validUntil;
  final String idOrPlate;
  final int signature;

  QrData(this.passType, this.apor, this.controlCode, this.validFrom,
      this.validUntil, this.idOrPlate,
      {this.signature});

  @override
  String toString() {
    return "%{pass_type: $passType, apor: $apor, control_code: $controlCode, "
        "valid_from: $validFrom, valid_until: $validUntil, "
        "id_or_plate: '$idOrPlate', signature: $signature}";
  }

  String controlCodeAsString() {
    return paddedEncoder.convert(this.controlCode) +
        crockford.encode(Damm32.compute(this.controlCode));
  }

  String purpose() {
    return this.apor;
  }

  DateTime validFromDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this.validFrom * 1000);
  }

  DateTime validUntilDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this.validUntil * 1000);
  }

  final DateFormat dateFormat = DateFormat.yMMMd('en_US');

  String validFromDisplayDate() {
    return dateFormat.format(validFromDateTime());
  }

  String validUntilDisplayDate() {
    return dateFormat.format(validUntilDateTime());
  }

  String validUntilDisplayTimestamp() {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(this.validUntil * 1000);
    return dateFormat.format(dateTime) +
        ' ' +
        DateFormat.Hm('en_US').format(dateTime);
  }
}
