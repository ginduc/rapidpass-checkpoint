import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/utils/hmac_sha256.dart';
import 'package:rapidpass_checkpoint/utils/qr_code_decoder.dart';
import 'package:rapidpass_checkpoint/utils/skip32.dart';

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
      if (signatureIsValid) {
        return scanResults;
      } else {
        final sr =
            ScanResults(null, resultMessage: 'Invalid Pass', allRed: true);
        sr.addError('Invalid QR Data');
        return sr;
      }
    } catch (e) {
      print(e.toString());
      final sr = ScanResults(null, resultMessage: 'Invalid Pass', allRed: true);
      sr.addError('Invalid QR Data');
      return sr;
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
    if (qrData.idOrPlate.isEmpty) {
      results.resultMessage = 'INVALID PASS';
      results.addError('Invalid Plate Number',
          source: RapidPassField.idOrPlate);
    }
    return results;
  }

  static final skip32key = AsciiEncoder().convert('SKIP32_SECRET_KEY');

  static final knownPlateNumbers = {
    'NAZ2070': QrData(
        PassType.Vehicle, 'PI', 329882482, 1582992000, 1588262400, 'NAZ2070')
  };

  static String normalizePlateNumber(final String plateNumber) {
    return plateNumber.toUpperCase().split('\\s').join();
  }

  static ScanResults checkPlateNumber(final String plateNumber) {
    final normalizedPlateNumber = normalizePlateNumber(plateNumber);
    if (knownPlateNumbers.containsKey(normalizedPlateNumber)) {
      return ScanResults(knownPlateNumbers[normalizedPlateNumber]);
    } else {
      return ScanResults.invalidPass;
    }
  }

  static final knownControlCodes = {
    '09TK6VJ2': QrData(
        PassType.Vehicle, 'PI', 329882482, 1582992000, 1588262400, 'NAZ2070')
  };

  static ScanResults checkControlCode(final String controlCode) {
    final String normalizedControlCode = controlCode.toUpperCase();
    if (knownControlCodes.containsKey(normalizedControlCode)) {
      return ScanResults(knownControlCodes[normalizedControlCode]);
    } else {
      return ScanResults.invalidPass;
    }
  }
}
