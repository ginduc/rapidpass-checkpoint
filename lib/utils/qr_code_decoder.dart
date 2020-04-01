import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';

import 'base32_crockford.dart';

/// Character '0'.
const int $0 = 0x30;

/// Character 'a'
const int $a = 0x61;

/// Character 'f'
const int $f = 0x66;

class QrCodeDecoder extends Converter<ByteData, QrData> {
  final AsciiDecoder asciiDecoder = AsciiDecoder();

  @override
  QrData convert(ByteData input) {
    debugPrint('input.lengthInBytes: ${input.lengthInBytes}');
    if (input.lengthInBytes < 13) {
      throw FormatException(
          'Invalid QR code raw data: ${input.buffer.asUint8List()}',
          input,
          input.lengthInBytes);
    }
    try {
      final pass_type = (input.getUint8(0) & 0x80 == 0x80) ? PassType.Vehicle : PassType.Individual;
      print('pass_type: $pass_type');
      final apor_bytes = [input.getUint8(0) & 0x7f, input.getUint8(1)];
      final apor = asciiDecoder.convert(apor_bytes);
      final control_code = input.getUint32(2);
      print('control_code: $control_code (${crockford.encode(control_code)})');
      final valid_from = input.getUint32(6);
      final valid_until = input.getUint32(10);
      final id_or_plate_len = input.getUint8(14);
      debugPrint('id_or_plate_len: $id_or_plate_len');
      final List<int> bytes = List(id_or_plate_len);
      for (var i = 0; i < id_or_plate_len; ++i) {
        bytes[i] = input.getUint8(15 + i);
      }
      final String id_or_plate = asciiDecoder.convert(bytes);
      final int signature = input.getUint32(15 + id_or_plate_len);
      return QrData(
          pass_type, apor, control_code, valid_from, valid_until, id_or_plate,
          signature: signature);
    } catch (e) {
      throw FormatException(e.toString());
    }
  }

  /// Just a utility method (used mainly in dev/test) to decode a hex string
  /// into a Uint8List (which can then be turned into a `ByteData`.
  static List<int> decodeHex(String hex) {
    if (!hex.length.isEven) {
      throw new FormatException(
          'Invalid input length, must be even.', hex, hex.length);
    }
    return _decode(hex.codeUnits);
  }

  static List<int> _decode(List<int> codeUnits) {
    final targetSize = codeUnits.length ~/ 2;
    final sourceEnd = targetSize * 2;
    final list = List<int>(targetSize);
    var destIndex = 0;
    for (var sourceIndex = 0; sourceIndex < sourceEnd; sourceIndex += 2) {
      final highNibble = _decodeNibble(codeUnits, sourceIndex);
      final lowNibble = _decodeNibble(codeUnits, sourceIndex + 1);
      list[destIndex++] = (highNibble << 4) | lowNibble;
    }
    return list;
  }

  static int _decodeNibble(List<int> codeUnits, int sourceIndex) {
    final codeUnit = codeUnits.elementAt(sourceIndex);
    final digit = $0 ^ codeUnit;
    if (digit <= 9) {
      if (digit >= 0) return digit;
    } else {
      final letter = 0x20 | codeUnit;
      if ($a <= letter && letter <= $f) return letter - $a + 10;
    }

    throw FormatException(
        'Invalid hexadecimal code unit U+${codeUnit.toRadixString(16).padLeft(4, '0')} at position $sourceIndex',
        codeUnits,
        sourceIndex);
  }
}
