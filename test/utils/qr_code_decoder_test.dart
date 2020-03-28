import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:rapidpass_checkpoint/utils/qr_code_decoder.dart';
import 'package:test/test.dart';

void main() {
  test('QrCodeDecoder works', () {
    final String raw = 'x09EMhTHXoDGAF6ppIAHQUJDMTIzNAb/HyA=';
    final bytes = base64.decode(raw);
    final uint8list = bytes.buffer.asByteData();
    final actual = QrCodeDecoder().convert(uint8list);
    print(actual);
  });
  test('utf8', () {
    final hex = '00d6948580835e77fc005e7d42000e41424331323334893c6f13';
    final bytes = QrCodeDecoder.decodeHex(hex);
    debugPrint('bytes: $bytes (${bytes.length} bytes)');
    final s = String.fromCharCodes(bytes);
    debugPrint('s: $s (${s.length} characters)');
    final codeUnits = s.codeUnits;
    debugPrint('codeUnits: $codeUnits (${codeUnits.length} code units)');
    final encoded = utf8.encode(s);
    debugPrint('encoded: $encoded (${encoded.length} elements)');
  });
  test('QrDecoder.decodeHex works on empty string', () {
    final decoded = QrCodeDecoder.decodeHex('');
    expect(decoded.length, equals(0));
  });
  test('QrDecoder.decodeHex works on a single zero byte', () {
    final decoded = QrCodeDecoder.decodeHex('00');
    expect(decoded.length, equals(1));
    expect(decoded[0], equals(0));
  });
  test('QrDecoder.decodeHex works on a single non-zero byte', () {
    final decoded = QrCodeDecoder.decodeHex('f4');
    expect(decoded.length, equals(1));
    expect(decoded[0], equals(0xf4));
  });
  test('QrDecoder.decodeHex works on a string', () {
    final input = 'fedcba9876543210';
    final decoded = QrCodeDecoder.decodeHex(input);
    expect(decoded.length, equals(8));
    final expected = [0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10];
    for (var i = 0; i < expected.length; ++i) {
      expect(decoded[i], equals(expected[i]));
    }
  });
}
