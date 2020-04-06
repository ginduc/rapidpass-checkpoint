import 'dart:convert';

import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/utils/qr_code_decoder.dart';
import 'package:test/test.dart';

void main() {
  test('QrCodeDecoder works with new, encrypted codes', () {
    final String raw = '//7qFlQbr6l8SnZjKCxd5S9ejfETOduxDCusjQ==';
    final bytes = base64.decode(raw);
    final uint8list = bytes.buffer.asByteData();
    final qrData = QrCodeDecoder().convert(uint8list);
    expect(qrData.passType, equals(PassType.Vehicle));
    expect(qrData.apor, equals('GO'));
    expect(qrData.controlCode, equals(2491777155));
    expect(qrData.validFrom, equals(1584921600));
    expect(qrData.validUntil, equals(1585267200));
    expect(qrData.idOrPlate, equals('ABC1234'));
    expect(qrData.signature, equals(0x0c2bac8d));
  });

  test('QrCodeDecoder works with old codes', () {
    final String raw = '0EkTqZtyXlqKgF6q9gAHTkFaMjA3MGxRlmM=';
    final bytes = base64.decode(raw);
    final uint8list = bytes.buffer.asByteData();
    final qrData = QrCodeDecoder().convert(uint8list);
    expect(qrData.passType, equals(PassType.Vehicle));
    expect(qrData.apor, equals("PI"));
    expect(qrData.controlCode, equals(329882482));
    expect(qrData.validFrom, equals(1582992000));
    expect(qrData.validUntil, equals(1588262400));
    expect(qrData.idOrPlate, equals("NAZ2070"));
    expect(qrData.signature, equals(0x6c519663));
  });

  test('QrDecoder.decodeHex works', () {
    final testCases = {
      '': [],
      '00': [0],
      'f4': [0xf4],
      'fedcba9876543210': [0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10]
    };
    testCases.forEach((hex, expected) {
      final decoded = QrCodeDecoder.decodeHex(hex);
      expect(decoded, equals(expected));
    });
  });
}
