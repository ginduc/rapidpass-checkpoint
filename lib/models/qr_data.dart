import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:rapidpass_checkpoint/utils/base32_crockford.dart';
import 'package:rapidpass_checkpoint/utils/damm32.dart';

const CrockfordEncoder paddedEncoder = const CrockfordEncoder(7);

enum PassType { Vehicle, Individual }

class QrData {
  final PassType passType;
  final String apor;
  final int controlCode;
  final int validFrom;
  final int validUntil;
  final String idOrPlate;
  final String status;
  final int signature;

  QrData(
      {@required this.passType,
      @required this.apor,
      @required this.controlCode,
      @required this.validFrom,
      @required this.validUntil,
      @required this.idOrPlate,
      @required this.status,
      this.signature});

  static final QrData empty = QrData(
      passType: null,
      apor: '',
      controlCode: 0,
      validFrom: 0,
      validUntil: 0,
      idOrPlate: '',
      status: '');

  @override
  String toString() {
    return "%{pass_type: $passType, apor: $apor, control_code: $controlCode, "
        "valid_from: $validFrom, valid_until: $validUntil, "
        "id_or_plate: '$idOrPlate', status: '$status', signature: $signature}";
  }

  String controlCodeAsString() {
    return paddedEncoder.convert(this.controlCode) +
        crockford.encode(Damm32.compute(this.controlCode));
  }

  String purpose() {
    return this.apor;
  }

  DateTime validFromDateTime() {
    if (this.validFrom == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(this.validFrom * 1000);
  }

  DateTime validUntilDateTime() {
    if (this.validUntil == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(this.validUntil * 1000);
  }

  final DateFormat dateFormat = DateFormat.yMMMd('en_US');

  String validFromDisplayDate() {
    var vfdt = validFromDateTime();
    if (vfdt == null) {
      return '';
    }
    return dateFormat.format(vfdt);
  }

  String validUntilDisplayDate() {
    var vudt = validUntilDateTime();
    if (vudt == null) {
      return '';
    }
    return dateFormat.format(vudt);
  }

  String validUntilDisplayTimestamp() {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(this.validUntil * 1000);
    return dateFormat.format(dateTime) +
        ' ' +
        DateFormat.Hm('en_US').format(dateTime);
  }
}
