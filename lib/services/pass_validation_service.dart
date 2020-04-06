import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:rapidpass_checkpoint/models/app_secrets.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/repository/api_repository.dart';
import 'package:rapidpass_checkpoint/utils/hmac_sha256.dart';
import 'package:rapidpass_checkpoint/utils/qr_code_decoder.dart';

class PassValidationService {
  final ApiRepository apiRepository;

  PassValidationService(this.apiRepository);

  static ScanResults deserializeAndValidate(
      final AppSecrets appSecrets, final String base64Encoded) {
    try {
      final decodedFromBase64 = base64.decode(base64Encoded);
      final asHex = hex.encode(decodedFromBase64);
      print('QR Code as hex => $asHex (${asHex.length} codes)');
      final buffer = decodedFromBase64 is Uint8List
          ? decodedFromBase64.buffer
          : Uint8List.fromList(decodedFromBase64).buffer;
      final byteData = ByteData.view(buffer);
      final Uint8List encryptionKey = hex.decode(appSecrets.encryptionKey);
      final qrData = QrCodeDecoder(encryptionKey).convert(byteData);
      final scanResults = validate(qrData);
      final Uint8List signingKey = hex.decode(appSecrets.signingKey);
      final signatureIsValid =
          HmacShac256.validateSignature(signingKey, decodedFromBase64);
      if (signatureIsValid) {
        return scanResults;
      } else {
        final sr =
            ScanResults(null, resultMessage: 'ENTRY DENIED', allRed: true);
        sr.addError('Invalid QR Data');
        return sr;
      }
    } catch (e) {
      print(e.toString());
      final sr = ScanResults(null, resultMessage: 'ENTRY DENIED', allRed: true);
      sr.resultSubMessage = 'QR CODE INVALID';
      sr.addError('Invalid QR Data');
      print(sr.resultSubMessage);
      return sr;
    }
  }

  static ScanResults validate(final QrData qrData) {
    final results = ScanResults(qrData);
    final DateTime now = DateTime.now();

    if (now.isBefore(qrData.validFromDateTime())) {
      results.resultMessage = 'ENTRY DENIED';
      results.resultSubMessage = 'RAPIDPASS IS INVALID';
      results.addError(
          'Pass is only valid starting on ${qrData.validFromDisplayDate()}',
          source: RapidPassField.validFrom);
    }
    if (now.isAfter(qrData.validUntilDateTime())) {
      results.resultMessage = 'ENTRY DENIED';
      results.resultSubMessage = 'RAPIDPASS HAS EXPIRED';
      results.addError('Pass expired on ${qrData.validUntilDisplayTimestamp()}',
          source: RapidPassField.validUntil);
    }
    if (qrData.idOrPlate.isEmpty) {
      results.resultMessage = 'ENTRY DENIED';
      results.resultSubMessage = 'RAPIDPASS IS INVALID';
      results.addError('Invalid Plate Number',
          source: RapidPassField.idOrPlate);
    }
    return results;
  }

  static String normalizePlateNumber(final String plateNumber) {
    return plateNumber.toUpperCase().split('\\s').join();
  }

  Future<ScanResults> checkPlateNumber(final String plateNumber) async {
    final normalizedPlateNumber = normalizePlateNumber(plateNumber);
    final validPass = await apiRepository.localDatabaseService
        .getValidPassByIdOrPlate(normalizedPlateNumber);
    if (validPass != null) {
      final QrData qrData = QrData(
          passType:
              validPass.passType == 1 ? PassType.Vehicle : PassType.Individual,
          apor: validPass.apor,
          controlCode: validPass.controlCode,
          validFrom: validPass.validFrom,
          validUntil: validPass.validUntil,
          idOrPlate: validPass.idOrPlate);
      return ScanResults(qrData);
    } else {
      return ScanResults.invalidPass;
    }
  }

  Future<ScanResults> checkControlCode(final String controlCode) async {
    final String normalizedControlCode = controlCode.toUpperCase();
    final validPass = await apiRepository.localDatabaseService
        .getValidPassByStringControlCode(normalizedControlCode);
    if (validPass != null) {
      final QrData qrData = QrData(
          passType:
              validPass.passType == 1 ? PassType.Vehicle : PassType.Individual,
          apor: validPass.apor,
          controlCode: validPass.controlCode,
          validFrom: validPass.validFrom,
          validUntil: validPass.validUntil,
          idOrPlate: validPass.idOrPlate);
      return ScanResults(qrData);
    } else {
      return ScanResults.invalidPass;
    }
  }
}
