import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/utils/hmac_sha256.dart';
import 'package:rapidpass_checkpoint/utils/qr_code_decoder.dart';

class PassValidationService {
  static ScanResults deserializeAndValidate(final String base64Encoded) {
    try {
      final decodedFromBase64 = base64.decode(base64Encoded);
      final asHex = hex.encode(decodedFromBase64);
      print('barcode => $asHex (${asHex.length} codes)');
      final buffer = decodedFromBase64 is Uint8List
          ? decodedFromBase64.buffer
          : Uint8List.fromList(decodedFromBase64).buffer;
      final byteData = ByteData.view(buffer);
      final qrData = QrCodeDecoder().convert(byteData);
      final scanResults = validate(qrData);
      final signatureIsValid = HmacShac256.validateSignature(decodedFromBase64);
      if (!signatureIsValid) {
        scanResults.addError('Invalid signature');
        scanResults.resultMessage = 'INVALID PASS';
        scanResults.allRed = true;
      }
      return scanResults;
    } catch (e) {
      print(e.toString());
      final scanResults =
          ScanResults(null, resultMessage: 'Invalid Pass', allRed: true);
      scanResults.addError('Invalid QR Data');
      return scanResults;
    }
  }

  static ScanResults validate(final QrData qrData) {
    final results = ScanResults(qrData);
    final DateTime now = DateTime.now();
    if (now.isBefore(qrData.validFromDateTime())) {
      results.resultMessage = 'INVALID PASS';
      results.addError(
          'Pass is only valid starting on ${qrData.validFromDisplayDate()}',
          source: RapidPassField.validFrom);
    }
    if (now.isAfter(qrData.validUntilDateTime())) {
      results.resultMessage = 'PASS EXPIRED';
      results.addError('Pass expired on ${qrData.validUntilDisplayTimestamp()}',
          source: RapidPassField.validUntil);
    }
    return results;
  }
}
